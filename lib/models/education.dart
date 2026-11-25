import 'package:json_annotation/json_annotation.dart';

part 'education.g.dart';

/// Riwayat pendidikan yang disinkronkan dengan API Django REST Framework.
@JsonSerializable(fieldRename: FieldRename.snake)
class Education {
  const Education({
    this.id,
    required this.institution,
    required this.level,
    required this.startedAt,
    this.major = '',
    this.endedAt,
    this.levelDisplay = '',
    this.isOngoing = false,
    this.starCount = 0,
    this.isStarred = false,
  });

  factory Education.fromJson(Map<String, dynamic> json) =>
      _$EducationFromJson(json);

  // Field hanya-baca dari server: tidak ikut dikirim saat POST.
  @JsonKey(includeToJson: false)
  final String? id;
  final String institution;

  /// Kode jenjang: sd, smp, sma, atau kuliah.
  final String level;
  @JsonKey(defaultValue: '')
  final String major;

  /// Format tanggal YYYY-MM-DD.
  final String startedAt;
  final String? endedAt;
  @JsonKey(includeToJson: false, defaultValue: '')
  final String levelDisplay;
  @JsonKey(includeToJson: false, defaultValue: false)
  final bool isOngoing;
  @JsonKey(includeToJson: false, defaultValue: 0)
  final int starCount;
  @JsonKey(includeToJson: false, defaultValue: false)
  final bool isStarred;

  Map<String, dynamic> toJson() => _$EducationToJson(this);
}
