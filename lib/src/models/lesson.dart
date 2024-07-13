import 'quiz.dart';

class Lesson {
  final int number;
  final String title;
  String? selectedContent;
  final bool hasVideo;
  final Quiz quiz;

  Lesson(
      {required this.title,
      required this.number,
      required this.selectedContent,
      required this.hasVideo,
      required this.quiz});

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
        title: json['title'],
        number: json['number'],
        selectedContent: json['selectedContent'],
        hasVideo: json['hasVideo'],
        quiz: Quiz.fromJson(json['quiz']));
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'number': number,
        'selectedContent': selectedContent,
        'hasVideo': hasVideo,
        'quiz': quiz.toJson()
      };

  Lesson copyWith({
    String? title,
    int? number,
    String? selectedContent,
    bool? hasVideo,
    Quiz? quiz,
  }) {
    return Lesson(
        title: title ?? this.title,
        number: number ?? this.number,
        selectedContent: selectedContent ?? this.selectedContent,
        hasVideo: hasVideo ?? this.hasVideo,
        quiz: quiz ?? this.quiz);
  }
}
