import 'question.dart';

class Quiz {
  String status;
  Question? currentQuestion;
  final List<Question> questions;

  Quiz(
      {required this.currentQuestion,
      required this.questions,
      required this.status}) {
    currentQuestion = currentQuestion ?? questions.first;
  }

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      status: json['status'],
      currentQuestion: json['currentQuestion'],
      questions: (json['questions'] as List)
          .map((question) => Question.fromJson(question))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'currentQuestion': currentQuestion,
        'questions': questions.map((question) => question.toJson()).toList(),
      };

  Quiz copyWith({
    String? status,
    Question? currentQuestion,
    List<Question>? questions,
  }) {
    return Quiz(
      status: status ?? this.status,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      questions: questions ?? this.questions,
    );
  }
}
