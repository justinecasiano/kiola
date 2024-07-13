import 'question.dart';

class Quiz {
  final Question? currentQuestion;
  final List<Question> questions;

  Quiz({required this.currentQuestion, required this.questions});

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      currentQuestion: json['currentQuestion'],
      questions: (json['questions'] as List)
          .map((question) => Question.fromJson(question))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'currentQuestion': currentQuestion,
        'questions': questions.map((question) => question.toJson()).toList(),
      };
}
