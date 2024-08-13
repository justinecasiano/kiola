import 'quiz_summary.dart';

class LessonSummary {
  final int number;
  double progress;
  String selectedContent;
  Map<String, dynamic> hasClicked;
  QuizSummary quizSummary;

  LessonSummary({
    required this.number,
    required this.progress,
    required this.selectedContent,
    required this.hasClicked,
    required this.quizSummary,
  });

  String getContentStatus(String content) {
    return hasClicked[content] ? 'Completed' : 'Pending';
  }

  double getTotalContentClicked() {
    var contents = hasClicked.values;
    return contents.where((clicked) => clicked).length / contents.length * 100;
  }

  factory LessonSummary.fromJson(Map<String, dynamic> json) {
    return LessonSummary(
      number: json['number'],
      progress: json['progress'],
      selectedContent: json['selectedContent'],
      hasClicked: json['hasClicked'],
      quizSummary: QuizSummary.fromJson(json['quizSummary']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'progress': progress,
      'selectedContent': selectedContent,
      'hasClicked': hasClicked,
      'quizSummary': quizSummary,
    };
  }

  LessonSummary copyWith({
    int? number,
    double? progress,
    String? selectedContent,
    Map<String, dynamic>? hasClicked,
    QuizSummary? quizSummary,
  }) {
    return LessonSummary(
      number: number ?? this.number,
      progress: progress ?? this.progress,
      selectedContent: selectedContent ?? this.selectedContent,
      hasClicked: hasClicked ?? this.hasClicked,
      quizSummary: quizSummary ?? this.quizSummary,
    );
  }
}
