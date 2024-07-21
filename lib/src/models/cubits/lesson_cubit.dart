import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../lesson.dart';
import '../quiz.dart';

class LessonCubit extends Cubit<Lesson> {
  final List<Lesson> lessons;

  LessonCubit({required this.lessons}) : super(lessons.first);

  double getContentPercentage() {
    return 100 / (state.hasVideo ? 4 : 3);
  }

  void setLesson(int number) {
    emit(lessons.firstWhere((lesson) => lesson.number == number));
    if (state.quiz.currentQuestion == null) setCurrentQuestion(0);
  }

  void setContent(String content) {
    emit(state.copyWith(selectedContent: content));
  }

  void setQuizStatus(String status) {
    emit(state.copyWith(quiz: state.quiz.copyWith(status: status)));
  }

  void setCurrentQuestion(int number) {
    if (number == state.quiz.questions.length) return;
    Quiz? quiz = state.copyWith().quiz;
    quiz.currentQuestion = quiz.questions[number];
    emit(state.copyWith(quiz: quiz));
  }

  void setQuestionRemainingTime(int time) {
    if (time == 0) return;
    Quiz? quiz = state.copyWith().quiz;
    quiz.currentQuestion!.remainingTime = time;
    emit(state.copyWith(quiz: quiz));
  }
}
