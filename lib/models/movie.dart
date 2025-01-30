

class Movie {
  final int? id;
  final String title;
  final bool tbd;
  final DateTime? date;

  const Movie ({
    this.id,
    required this.title,
    required this.tbd,
    this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      // SQLiteでは真偽値は0(false)か1(true)で保存
      'tbd': tbd ? 1 : 0,
      // tbdがtrueならdateはnull
      'date': tbd ? null : date?.toIso8601String(),
    };
  }

  // SQLiteから読み込んだMapからMovieオブジェクトを作成
  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'],
      title: map['title'],
      tbd: map['tbd'] == 1, // 1はtrue、0はfalse
      date: map['date'] != null ? DateTime.parse(map['date']) : null,
    );
  }
}