class Question {
  final String question;
  final List<String> options;
  final int correctAnswer;
  final int remainingTime;

  Question({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.remainingTime,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'],
      options:
          (json['options'] as List).map((option) => option.toString()).toList(),
      correctAnswer: json['correctAnswer'],
      remainingTime: json['remainingTime'],
    );
  }

  Map<String, dynamic> toJson() => {
        'question': question,
        'options': options,
        'correctAnswer': correctAnswer,
        'remainingTime': remainingTime,
      };
}
