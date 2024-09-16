import 'quiz_summary.dart';

class LessonSummary {
  final int number;
  bool isLocked;
  String? unlockDate;
  double progress;
  String selectedContent;
  Map<String, dynamic> hasClicked;
  QuizSummary? quizSummary;

  LessonSummary({
    required this.number,
    required this.isLocked,
    required this.unlockDate,
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
      isLocked: json['isLocked'],
      unlockDate: json['unlockDate'],
      progress: json['progress'],
      selectedContent: json['selectedContent'],
      hasClicked: json['hasClicked'],
      quizSummary: json['quizSummary'] == null
          ? json['quizSummary']
          : QuizSummary.fromJson(json['quizSummary']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'isLocked': isLocked,
      'unlockDate': unlockDate,
      'progress': progress,
      'selectedContent': selectedContent,
      'hasClicked': hasClicked,
      'quizSummary': quizSummary,
    };
  }

  LessonSummary copyWith({
    int? number,
    bool? isLocked,
    String? unlockDate,
    double? progress,
    String? selectedContent,
    Map<String, dynamic>? hasClicked,
    QuizSummary? quizSummary,
  }) {
    return LessonSummary(
      number: number ?? this.number,
      isLocked: isLocked ?? this.isLocked,
      unlockDate: unlockDate ?? this.unlockDate,
      progress: progress ?? this.progress,
      selectedContent: selectedContent ?? this.selectedContent,
      hasClicked: hasClicked ?? this.hasClicked,
      quizSummary: quizSummary ?? this.quizSummary,
    );
  }
}
