import '../extras/utils.dart';
import 'lesson_summary.dart';
import 'quiz_summary.dart';

class Student {
  String? uuid;
  String? username;
  String? email;
  final int? lastSaved;
  bool shouldUpdate;
  double overallProgress;
  int currentLesson;
  List<LessonSummary> lessonSummary;

  Student({
    required this.uuid,
    required this.username,
    required this.email,
    required this.lastSaved,
    required this.shouldUpdate,
    required this.overallProgress,
    required this.currentLesson,
    required this.lessonSummary,
  });

  LessonSummary getCurrentLessonSummary() {
    return lessonSummary[currentLesson];
  }

  QuizSummary getLessonQuizSummary() {
    return getCurrentLessonSummary().quizSummary;
  }

  List<int?> getQuizScores() {
    return lessonSummary.map((summary) => summary.quizSummary.score).toList();
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      uuid: json['uuid'],
      username: json['username'],
      email: json['email'],
      lastSaved: json['lastSaved'],
      shouldUpdate: json['shouldUpdate'],
      overallProgress: json['overallProgress'],
      currentLesson: json['currentLesson'],
      lessonSummary: json['lessonSummary']
          .map<LessonSummary>(
              (lessonSummary) => LessonSummary.fromJson(lessonSummary))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'username': username,
      'email': email,
      'lastSaved': Utils.getSecondsSinceEpoch(),
      'shouldUpdate': shouldUpdate,
      'overallProgress': overallProgress,
      'currentLesson': currentLesson,
      'lessonSummary': lessonSummary,
    };
  }

  Student copyWith({
    String? uuid,
    String? username,
    String? email,
    int? lastSaved,
    bool? shouldUpdate,
    double? overallProgress,
    int? currentLesson,
    List<LessonSummary>? lessonSummary,
  }) {
    return Student(
      uuid: uuid ?? this.uuid,
      username: username ?? this.username,
      email: email ?? this.email,
      lastSaved: lastSaved ?? this.lastSaved,
      shouldUpdate: shouldUpdate ?? this.shouldUpdate,
      overallProgress: overallProgress ?? this.overallProgress,
      currentLesson: currentLesson ?? this.currentLesson,
      lessonSummary: lessonSummary ?? this.lessonSummary,
    );
  }
}
