import '../extras/utils.dart';
import 'lesson_standing.dart';

class Student {
  final String? username;
  final String? email;
  final int? lastSaved;
  List<LessonStanding> lessonStanding;
  int overallProgress;

  Student({
    required this.username,
    required this.email,
    required this.lastSaved,
    required this.lessonStanding,
    required this.overallProgress,
  });

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        username: json['username'],
        email: json['email'],
        lastSaved: json['lastSaved'],
        overallProgress: json['overallProgress'],
        lessonStanding: (json['lessonStanding'] as List)
            .map((standing) => LessonStanding.fromJson(standing))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'lastSaved': Utils.getSecondsSinceEpoch(),
        'overallProgress': overallProgress,
        'lessonStanding':
            lessonStanding.map((standing) => standing.toJson()).toList(),
      };

  Student copyWith({
    String? username,
    String? email,
    int? lastSaved,
    List<LessonStanding>? lessonStanding,
    int? overallProgress,
  }) {
    return Student(
      username: username ?? this.username,
      email: email ?? this.email,
      lastSaved: lastSaved ?? this.lastSaved,
      lessonStanding: lessonStanding ?? this.lessonStanding,
      overallProgress: overallProgress ?? this.overallProgress,
    );
  }
}
