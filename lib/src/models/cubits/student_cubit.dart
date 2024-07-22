import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../lesson.dart';
import '../student.dart';
import 'lesson_cubit.dart';

class StudentCubit extends Cubit<Student> {
  StudentCubit(super.student);

  void setQuizScore(int number, int score) {
    Student student = state.copyWith();
    student.lessonStanding[number].score = score;
    emit(student);
  }

  void setLessonProgress(BuildContext context, String content) {
    context.read<LessonCubit>().setContentClicked(content);
    Lesson lesson = context.read<LessonCubit>().state;

    Student student = state.copyWith();
    student.lessonStanding[lesson.number - 1].progress =
        lesson.getTotalContentClicked();
    emit(setOverallProgress(student));
  }

  Student setOverallProgress(Student student) {
    for (var standing in student.lessonStanding) {
      student.overallProgress += standing.progress;
    }
    student.overallProgress /= student.lessonStanding.length;
    return student;
  }

  void setQuestionAnswer(int lessonNumber, int questionNumber, int answer) {
    Student student = state.copyWith();
    student.lessonStanding[lessonNumber].answers[questionNumber] = answer;
    emit(student);
  }
}
