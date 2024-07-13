import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../student.dart';
import 'lesson_cubit.dart';

class StudentCubit extends Cubit<Student> {
  StudentCubit(super.student);

  void setQuizScore(int number, int score) {
    Student student = state.copyWith();
    student.lessonStanding[number].score = score;
    emit(student);
  }

  void setLessonProgress(BuildContext context, int number) {
    int percent = context.read<LessonCubit>().getContentPercentage();
    Student student = state.copyWith();
    student.lessonStanding[number].progress += percent;
    emit(student);
  }

  void setOverallProgress() {
    Student student = state.copyWith();
    for (var standing in student.lessonStanding) {
      student.overallProgress += standing.progress;
    }
    student.overallProgress ~/= student.lessonStanding.length;
    emit(student);
  }
}
