import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanoid/nanoid.dart';
import '/src/models/quiz_summary.dart';

import '../student.dart';
import 'lesson_cubit.dart';

class StudentCubit extends Cubit<Student> {
  StudentCubit(super.student);

  void setUuid() {
    if (state.uuid == null) emit(state.copyWith()..uuid = nanoid(8));
  }

  void setInfo(String username, String email) {
    emit(
      state.copyWith()
        ..username = username
        ..email = email,
    );
    setShouldUpdate(true);
  }

  void setCurrentLesson(int number) {
    emit(state.copyWith()..currentLesson = number);
  }

  void setContent(String content) {
    emit(state.copyWith()
      ..lessonSummary[state.currentLesson].selectedContent = content);
  }

  void setContentClicked(String content) {
    Map<String, dynamic> hasClicked =
        state.copyWith().getCurrentLessonSummary().hasClicked;
    hasClicked[content] = true;

    emit(state.copyWith()
      ..lessonSummary[state.currentLesson].hasClicked = hasClicked);
    setLessonProgress();
  }

  void setLessonProgress() {
    Student student = state.copyWith();
    student.lessonSummary[state.currentLesson].progress =
        state.getCurrentLessonSummary().getTotalContentClicked();

    student.overallProgress = 0;
    for (var summary in student.lessonSummary) {
      student.overallProgress += summary.progress;
    }
    student.overallProgress /= student.lessonSummary.length;

    emit(student);
  }

  void setShouldUpdate(bool shouldUpdate) {
    emit(state.copyWith()..shouldUpdate = shouldUpdate);
  }

  void setQuizStatus(String status) {
    emit(state.copyWith()
      ..lessonSummary[state.currentLesson].quizSummary.status = status);
  }

  void moveCurrentNumber(BuildContext context) {
    QuizSummary summary = state.copyWith().getLessonQuizSummary();
    (summary.currentNumber == 9)
        ? onQuizCompleted(context, summary)
        : summary.currentNumber++;

    emit(state.copyWith()
      ..lessonSummary[state.currentLesson].quizSummary = summary);
  }

  int getQuestionRemainingTime() {
    return state.getLessonQuizSummary().getRemainingTime();
  }

  void updateQuestionRemainingTime() {
    QuizSummary summary = state.copyWith().getLessonQuizSummary();
    if (summary.remainingTime[summary.currentNumber] == 0) return;
    summary.remainingTime[summary.currentNumber]--;

    emit(state.copyWith()
      ..lessonSummary[state.currentLesson].quizSummary = summary);
  }

  void setQuestionAnswer(int? answer) {
    QuizSummary summary = state.copyWith().getLessonQuizSummary();
    summary.answers[summary.currentNumber] = answer;

    emit(state.copyWith()
      ..lessonSummary[state.currentLesson].quizSummary = summary);
  }

  int calculateQuizScore(List<int> correctAnswers) {
    List<int?> answers =
        state.lessonSummary[state.currentLesson].quizSummary.answers;

    int score = 0;
    answers.forEach((answer) {
      if (answer == correctAnswers[answers.indexOf(answer)]) score++;
    });

    return score;
  }

  void onQuizCompleted(BuildContext context, QuizSummary summary) async {
    summary.status = 'completed';
    summary.score = calculateQuizScore(
      await Future.delayed(
        0.seconds,
        () => context.read<LessonCubit>().state.getAnswers(),
      ),
    );

    emit(state..lessonSummary[state.currentLesson].quizSummary = summary);
    setContentClicked('quiz');
    setShouldUpdate(true);
  }
}
