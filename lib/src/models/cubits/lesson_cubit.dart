import 'package:flutter_bloc/flutter_bloc.dart';

import '../lesson.dart';

class LessonCubit extends Cubit<Lesson> {
  final List<Lesson> lessons;

  LessonCubit({required this.lessons}) : super(lessons.first);

  double getContentPercentage() {
    return 100 / (state.hasVideo ? 4 : 3);
  }

  void setLesson(int number) {
    emit(lessons.firstWhere((lesson) => lesson.number == number));
  }

  void setContent(String content) {
    emit(state.copyWith(selectedContent: content));
  }
}
