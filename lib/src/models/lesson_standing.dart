class LessonStanding {
  int number;
  List<int?> answers;
  int? score;
  double progress;

  LessonStanding(
      {required this.number,
      required this.answers,
      required this.score,
      required this.progress});

  factory LessonStanding.fromJson(Map<String, dynamic> json) => LessonStanding(
        number: json['number'],
        answers:
            (json['answers'] as List).map((answer) => answer as int?).toList(),
        score: json['score'],
        progress: json['progress'],
      );

  Map<String, dynamic> toJson() => {
        'number': number,
        'answers': answers,
        'score': score,
        'progress': progress,
      };
}
