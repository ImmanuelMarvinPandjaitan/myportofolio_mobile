import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

/// Halaman formulir untuk menambah data pendidikan (Education).
class EducationFormPage extends StatefulWidget {
  const EducationFormPage({super.key});

  @override
  State<EducationFormPage> createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {
  // Kunci untuk mengakses state Form (validate dan reset dari tombol Simpan).
  final _formKey = GlobalKey<FormState>();

  // Controller dipakai agar tanggal hasil showDatePicker tampil di kolom.
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  static const String _defaultDegree = 'S1';
  final List<String> _degrees = ['SMA/SMK', 'D3', 'S1', 'S2', 'S3'];

  String _institution = "";
  String _degree = _defaultDegree;
  String _major = "";
  DateTime? _startDate;
  DateTime? _endDate;
  String _gpa = "";
  String _description = "";

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  /// Format tanggal dd/MM/yyyy tanpa paket tambahan.
  String _formatDate(DateTime date) {
    final String day = date.day.toString().padLeft(2, '0');
    final String month = date.month.toString().padLeft(2, '0');
    return "$day/$month/${date.year}";
  }

  /// Membuka kalender dan menyimpan tanggal yang dipilih.
  Future<void> _pickDate({required bool isStart}) async {
    final DateTime? picked = await showDatePicker(
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

  /// Wajib diisi (spasi saja ditolak) dan dibatasi panjangnya.
  String? _validateRequired(String? value, String label, int maxLength) {
    if (value == null || value.trim().isEmpty) {
      return "$label tidak boleh kosong!";
    }
    if (value.trim().length > maxLength) {
      return "$label maksimal $maxLength karakter!";
    }
    return null;
  }

  String? _validateStartDate() {
    if (_startDate == null) {
      return "Tanggal mulai harus dipilih!";
    }
    return null;
  }

  /// Opsional (kosong = masih berlangsung), tetapi tidak boleh sebelum mulai.
  String? _validateEndDate() {
    if (_endDate == null) return null;
    if (_startDate != null && _endDate!.isBefore(_startDate!)) {
      return "Tanggal selesai tidak boleh sebelum tanggal mulai!";
    }
    return null;
  }

  /// Opsional, tetapi jika diisi harus angka antara 0 dan 4.
  String? _validateGpa(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final double? gpa = double.tryParse(value.trim().replaceAll(',', '.'));
    if (gpa == null) {
      return "IPK harus berupa angka, contoh: 3.75";
    }
    if (gpa < 0 || gpa > 4) {
      return "IPK harus antara 0.00 dan 4.00!";
    }
    return null;
  }

  // ===== Helper tampilan =====

  InputDecoration _decoration(String label, {String? hint, Widget? suffix}) {
    return InputDecoration(
      hintText: hint ?? label,
      labelText: label,
      suffixIcon: suffix,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
    );
  }

  Widget _withPadding(Widget child) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: child,
    );
  }

  /// Mengosongkan form dan semua variabel penampung isian.
  void _resetForm() {
    _formKey.currentState!.reset();
    _startDateController.clear();
    _endDateController.clear();
    setState(() {
      _institution = "";
      _degree = _defaultDegree;
      _major = "";
      _startDate = null;
      _endDate = null;
      _gpa = "";
      _description = "";
    });
  }

  void _showSummaryDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Data pendidikan berhasil disimpan!'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Institusi: ${_institution.trim()}'),
                Text('Jenjang: $_degree'),
                Text('Program Studi: ${_major.trim()}'),
                Text('Tanggal Mulai: ${_formatDate(_startDate!)}'),
                Text(
                  'Tanggal Selesai: '
                  '${_endDate == null ? "Masih berlangsung" : _formatDate(_endDate!)}',
                ),
                Text('IPK: ${_gpa.trim().isEmpty ? "-" : _gpa.trim()}'),
                Text(
                  'Deskripsi: ${_description.trim().isEmpty ? "-" : _description.trim()}',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Tutup'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Add Education Form'),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        // SingleChildScrollView menjaga semua input dan tombol tetap
        // terjangkau pada layar sempit atau saat papan ketik tampil.
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === Nama Institusi ===
              _withPadding(
                TextFormField(
                  decoration: _decoration("Nama Institusi"),
                  onChanged: (String? value) {
                    setState(() {
                      _institution = value ?? "";
                    });
                  },
                  validator: (String? value) =>
                      _validateRequired(value, "Nama institusi", 100),
                ),
              ),
              // === Jenjang ===
              _withPadding(
                DropdownButtonFormField<String>(
                  decoration: _decoration("Jenjang"),
                  initialValue: _defaultDegree,
                  items: _degrees
                      .map((degree) => DropdownMenuItem(
                            value: degree,
                            child: Text(degree),
                          ))
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _degree = newValue ?? _defaultDegree;
                    });
                  },
                ),
              ),
              // === Program Studi ===
              _withPadding(
                TextFormField(
                  decoration: _decoration("Program Studi"),
                  onChanged: (String? value) {
                    setState(() {
                      _major = value ?? "";
                    });
                  },
                  validator: (String? value) =>
                      _validateRequired(value, "Program studi", 100),
                ),
              ),
              // === Tanggal Mulai ===
              _withPadding(
                TextFormField(
                  controller: _startDateController,
                  readOnly: true,
                  decoration: _decoration(
                    "Tanggal Mulai",
                    hint: "Pilih tanggal mulai",
                    suffix: const Icon(Icons.calendar_today),
                  ),
                  onTap: () => _pickDate(isStart: true),
                  validator: (String? value) => _validateStartDate(),
                ),
              ),
              // === Tanggal Selesai ===
              _withPadding(
                TextFormField(
                  controller: _endDateController,
                  readOnly: true,
                  decoration: _decoration(
                    "Tanggal Selesai (opsional)",
                    hint: "Kosongkan jika masih berlangsung",
                    suffix: const Icon(Icons.calendar_today),
                  ),
                  onTap: () => _pickDate(isStart: false),
                  validator: (String? value) => _validateEndDate(),
                ),
              ),
              // === IPK ===
              _withPadding(
                TextFormField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: _decoration(
                    "IPK (opsional)",
                    hint: "Contoh: 3.75",
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _gpa = value ?? "";
                    });
                  },
                  validator: _validateGpa,
                ),
              ),
              // === Deskripsi ===
              _withPadding(
                TextFormField(
                  maxLines: 4,
                  maxLength: 300,
                  decoration: _decoration(
                    "Deskripsi (opsional)",
                    hint: "Kegiatan, prestasi, atau catatan lain",
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _description = value ?? "";
                    });
                  },
                ),
              ),
              // === Tombol Simpan ===
              Align(
                alignment: Alignment.bottomCenter,
                child: _withPadding(
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.indigo),
                    ),
                    onPressed: () {
                      // Dialog hanya muncul jika semua validator lolos.
                      if (_formKey.currentState!.validate()) {
                        _showSummaryDialog();
                      }
                    },
                    child: const Text(
                      "Simpan",
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
