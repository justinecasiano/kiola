import 'package:flutter_bloc/flutter_bloc.dart';

import '../lesson.dart';

class LessonCubit extends Cubit<Lesson> {
  final List<Lesson> lessons;
  late int number;

  LessonCubit({required this.lessons}) : super(lessons.first) {
    number = lessons.first.number;
  }

  int getLessonNumber() => number;

  String? getContent() => state.selectedContent;

  int getContentPercentage() {
    return state.hasVideo ? 100 ~/ 4 : 100 ~/ 3;
  }

  void setLesson(int number) {
    this.number = number;
    emit(lessons.firstWhere((lesson) => lesson.number == number));
  }

  void setContent(String? content) {
    Lesson? currentLesson = state.copyWith(selectedContent: content);
    emit(currentLesson);
  }
}
