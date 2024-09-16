import '../extras/utils.dart';
import 'lesson_summary.dart';
import 'quiz_summary.dart';

class Student {
  String? uuid;
  String? username;
  String? email;
  final int? lastSaved;
  bool shouldUpdate;
  bool shouldUnlockLessons;
  double overallProgress;
  int currentLesson;
  List<LessonSummary> lessonSummary;

  Student({
    required this.uuid,
    required this.username,
    required this.email,
    required this.lastSaved,
    required this.shouldUpdate,
    required this.shouldUnlockLessons,
    required this.overallProgress,
    required this.currentLesson,
    required this.lessonSummary,
  });

  LessonSummary getCurrentLessonSummary() {
    return lessonSummary[currentLesson];
  }

  QuizSummary getLessonQuizSummary() {
    return getCurrentLessonSummary().quizSummary!;
  }

  List<int?> getQuizScores() {
    List<int?> scores = [];
    for (var summary in lessonSummary) {
      if (summary.number > 0) scores.add(summary.quizSummary!.score);
    }

    return scores;
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      uuid: json['uuid'],
      username: json['username'],
      email: json['email'],
      lastSaved: json['lastSaved'],
      shouldUpdate: json['shouldUpdate'],
      shouldUnlockLessons: json['shouldUnlockLessons'],
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
      'shouldUnlockLessons': shouldUnlockLessons,
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
    bool? shouldUnlockLessons,
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
      shouldUnlockLessons: shouldUnlockLessons ?? this.shouldUnlockLessons,
      overallProgress: overallProgress ?? this.overallProgress,
      currentLesson: currentLesson ?? this.currentLesson,
      lessonSummary: lessonSummary ?? this.lessonSummary,
    );
  }
}
