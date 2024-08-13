class QuizSummary {
  String status;
  int currentNumber;
  int? score;
  List<int?> answers;
  List<int> remainingTime;

  QuizSummary({
    required this.status,
    required this.currentNumber,
    required this.score,
    required this.answers,
    required this.remainingTime,
  });

  int? getCurrentAnswer() => answers[currentNumber];

  int getRemainingTime() => remainingTime[currentNumber];

  int? viewCurrentAnswer(int index) => answers[index];

  bool hasStarted() => remainingTime[0] != 10;

  factory QuizSummary.fromJson(Map<String, dynamic> json) {
    return QuizSummary(
      status: json['status'],
      currentNumber: json['currentNumber'],
      score: json['score'],
      answers:
          (json['answers'] as List).map((answer) => answer as int?).toList(),
      remainingTime: (json['remainingTime'] as List)
          .map((remainingTime) => remainingTime as int)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'currentNumber': currentNumber,
      'score': score,
      'answers': answers,
      'remainingTime': remainingTime,
    };
  }

  QuizSummary copyWith({
    String? status,
    int? currentNumber,
    int? score,
    List<int?>? answers,
    List<int>? remainingTime,
  }) {
    return QuizSummary(
      status: status ?? this.status,
      currentNumber: currentNumber ?? this.currentNumber,
      score: score ?? this.score,
      answers: answers ?? this.answers,
      remainingTime: remainingTime ?? this.remainingTime,
    );
  }
}
