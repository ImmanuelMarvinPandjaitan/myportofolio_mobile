import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/models/education.dart';

void main() {
  test('Education.fromJson memetakan kunci snake_case dari DRF', () {
    final education = Education.fromJson({
      'id': 'abc',
      'institution': 'Universitas Indonesia',
      'level': 'kuliah',
      'level_display': 'Kuliah',
      'major': 'Ilmu Komputer',
      'started_at': '2024-08-01',
      'ended_at': null,
      'is_ongoing': true,
      'star_count': 3,
      'is_starred': false,
    });
    expect(education.institution, 'Universitas Indonesia');
    expect(education.levelDisplay, 'Kuliah');
    expect(education.startedAt, '2024-08-01');
    expect(education.endedAt, isNull);
    expect(education.starCount, 3);
  });

  test('Education.toJson hanya berisi field yang boleh dikirim', () {
    const education = Education(
      id: 'abc',
      institution: 'SMA Negeri 1',
      level: 'sma',
      major: 'IPA',
      startedAt: '2021-07-01',
      endedAt: '2024-06-01',
      levelDisplay: 'SMA/SMK',
      starCount: 5,
    );
    final json = education.toJson();
    expect(json['institution'], 'SMA Negeri 1');
    expect(json['started_at'], '2021-07-01');
    expect(json['ended_at'], '2024-06-01');
    expect(json.containsKey('id'), isFalse);
    expect(json.containsKey('star_count'), isFalse);
    expect(json.containsKey('level_display'), isFalse);
  });
}
