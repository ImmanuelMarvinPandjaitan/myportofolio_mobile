import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

/// Formulir tambah pendidikan, sesuai EducationSerializer di backend Django.
class EducationFormPage extends StatefulWidget {
  const EducationFormPage({super.key});

  @override
  State<EducationFormPage> createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  static const String _defaultLevel = 'kuliah';
  // Kode jenjang (dikirim ke API) -> label yang ditampilkan.
  static const Map<String, String> _levels = {
    'sd': 'SD',
    'smp': 'SMP',
    'sma': 'SMA/SMK',
    'kuliah': 'Kuliah',
  };

  String _institution = '';
  String _level = _defaultLevel;
  String _major = '';
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  /// Tampilan di kolom: dd/MM/yyyy.
  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  /// Format yang diterima API: YYYY-MM-DD.
  String _isoDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          (isStart ? _startDate : (_endDate ?? _startDate)) ?? DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
    );
    if (picked == null || !mounted) return;
    setState(() {
      if (isStart) {
        _startDate = picked;
        _startDateController.text = _formatDate(picked);
      } else {
        _endDate = picked;
        _endDateController.text = _formatDate(picked);
      }
    });
  }

  // ===== Validator =====

  String? _validateInstitution(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama institusi tidak boleh kosong!';
    }
    if (value.trim().length > 255) {
      return 'Nama institusi maksimal 255 karakter!';
    }
    return null;
  }

  String? _validateMajor(String? value) {
    if (value != null && value.trim().length > 255) {
      return 'Program studi maksimal 255 karakter!';
    }
    return null;
  }

  String? _validateStartDate() {
    if (_startDate == null) return 'Tanggal mulai harus dipilih!';
    return null;
  }

  /// Opsional (kosong = masih berlangsung), tidak boleh sebelum tanggal mulai.
  String? _validateEndDate() {
    if (_endDate == null) return null;
    if (_startDate != null && _endDate!.isBefore(_startDate!)) {
      return 'Tanggal selesai tidak boleh sebelum tanggal mulai!';
    }
    return null;
  }

  String _errorMessage(ApiException e) {
    switch (e.statusCode) {
      case 400:
        return 'Data ditolak server (400). Periksa kembali isian.';
      case 403:
        return 'Akun ini tidak punya izin menambah data (403).';
      default:
        return 'Gagal menyimpan data (${e.statusCode}).';
    }
  }

  InputDecoration _decoration(String label, {String? hint, Widget? suffix}) {
    return InputDecoration(
      hintText: hint ?? label,
      labelText: label,
      suffixIcon: suffix,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
    );
  }

  Widget _withPadding(Widget child) {
    return Padding(padding: const EdgeInsets.all(8.0), child: child);
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _startDateController.clear();
    _endDateController.clear();
    setState(() {
      _institution = '';
      _level = _defaultLevel;
      _major = '';
      _startDate = null;
      _endDate = null;
    });
  }

  void _showSuccessDialog(Education created) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Data pendidikan berhasil ditambahkan!'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Institusi: ${created.institution}'),
                Text('Jenjang: ${created.levelDisplay}'),
                Text(
                  'Program Studi: ${created.major.isEmpty ? "-" : created.major}',
                ),
                Text('Tanggal Mulai: ${created.startedAt}'),
                Text(
                  'Tanggal Selesai: ${created.endedAt ?? "Masih berlangsung"}',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
                _resetForm();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthState>();
    final api = context.read<ApiClient>();
    final messenger = ScaffoldMessenger.of(context);

    // Pastikan sudah login (membuka layar login jika belum).
    final loggedIn = await ensureLoggedIn(context);
    final token = auth.token;
    if (!mounted || !loggedIn || token == null) return;

    setState(() {
      _isSubmitting = true;
    });
    try {
      final created = await api.createEducation(
        Education(
          institution: _institution.trim(),
          level: _level,
          major: _major.trim(),
          startedAt: _isoDate(_startDate!),
          endedAt: _endDate == null ? null : _isoDate(_endDate!),
        ),
        token: token,
      );
      if (!mounted) return;
      _showSuccessDialog(created);
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        // Token tidak valid: logout dan minta login ulang.
        await auth.logout();
        if (!mounted) return;
        messenger.showSnackBar(
          const SnackBar(
            content: Text(
              'Sesi login berakhir (401). Login ulang lalu simpan lagi.',
            ),
          ),
        );
        await ensureLoggedIn(context);
      } else {
        messenger.showSnackBar(SnackBar(content: Text(_errorMessage(e))));
      }
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Tidak dapat terhubung ke server: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Add Education Form')),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _withPadding(
                TextFormField(
                  decoration: _decoration('Nama Institusi'),
                  onChanged: (value) => _institution = value,
                  validator: _validateInstitution,
                ),
              ),
              _withPadding(
                DropdownButtonFormField<String>(
                  decoration: _decoration('Jenjang'),
                  initialValue: _defaultLevel,
                  items: _levels.entries
                      .map(
                        (entry) => DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value),
                        ),
                      )
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _level = newValue ?? _defaultLevel;
                    });
                  },
                ),
              ),
              _withPadding(
                TextFormField(
                  decoration: _decoration(
                    'Program Studi (opsional)',
                    hint: 'Contoh: Ilmu Komputer',
                  ),
                  onChanged: (value) => _major = value,
                  validator: _validateMajor,
                ),
              ),
              _withPadding(
                TextFormField(
                  controller: _startDateController,
                  readOnly: true,
                  decoration: _decoration(
                    'Tanggal Mulai',
                    hint: 'Pilih tanggal mulai',
                    suffix: const Icon(Icons.calendar_today),
                  ),
                  onTap: () => _pickDate(isStart: true),
                  validator: (value) => _validateStartDate(),
                ),
              ),
              _withPadding(
                TextFormField(
                  controller: _endDateController,
                  readOnly: true,
                  decoration: _decoration(
                    'Tanggal Selesai (opsional)',
                    hint: 'Kosongkan jika masih berlangsung',
                    suffix: const Icon(Icons.calendar_today),
                  ),
                  onTap: () => _pickDate(isStart: false),
                  validator: (value) => _validateEndDate(),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: _withPadding(
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.indigo),
                    ),
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Simpan',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
