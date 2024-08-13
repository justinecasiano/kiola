import 'question.dart';

class Lesson {
  final int number;
  final String title;
  final bool hasVideo;
  final List<Question> questions;

  Lesson({
    required this.number,
    required this.title,
    required this.hasVideo,
    required this.questions,
  });

  List<int> getAnswers() {
    return questions.map((question) => question.correctAnswer).toList();
  }

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      number: json['number'],
      title: json['title'],
      hasVideo: json['hasVideo'],
      questions: json['questions']
          .map<Question>((question) => Question.fromJson(question))
          .toList(),
    );
  }
}
