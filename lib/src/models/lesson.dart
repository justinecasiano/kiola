import 'quiz.dart';

class Lesson {
  final int number;
  final String title;
  String selectedContent;
  final Map<String, dynamic> hasClicked;
  final Quiz quiz;

  Lesson(
      {required this.title,
      required this.number,
      required this.selectedContent,
      required this.hasClicked,
      required this.quiz});

  bool hasVideo() {
    return hasClicked.keys.contains('video');
  }

  String getContentStatus(String content) {
    return hasClicked[content] ? 'Completed' : 'Pending';
  }

  double getTotalContentClicked() {
    var contents = hasClicked.values;
    return contents.where((clicked) => clicked).length / contents.length * 100;
  }

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      title: json['title'],
      number: json['number'],
      selectedContent: json['selectedContent'],
      hasClicked: json['hasClicked'],
      quiz: Quiz.fromJson(json['quiz']),
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'number': number,
        'selectedContent': selectedContent,
        'hasClicked': hasClicked,
        'quiz': quiz.toJson(),
      };

  Lesson copyWith({
    String? title,
    int? number,
    String? selectedContent,
    Map<String, dynamic>? hasClicked,
    Quiz? quiz,
  }) {
    return Lesson(
      title: title ?? this.title,
      number: number ?? this.number,
      selectedContent: selectedContent ?? this.selectedContent,
      hasClicked: hasClicked ?? this.hasClicked,
      quiz: quiz ?? this.quiz,
    );
  }
}
