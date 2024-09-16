import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../lesson.dart';
import 'student_cubit.dart';

class LessonCubit extends Cubit<Lesson> {
  List<Lesson> lessons;

  LessonCubit({required this.lessons}) : super(lessons.first);

  void setLesson(BuildContext context, int number) {
    context.read<StudentCubit>().setCurrentLesson(number);
    emit(lessons.firstWhere((lesson) => lesson.number == number));
  }

  Lesson getLesson(int number) {
    return lessons.firstWhere((lesson) => lesson.number == number);
  }
}
