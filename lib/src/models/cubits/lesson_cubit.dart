import 'package:flutter_bloc/flutter_bloc.dart';

import '../lesson.dart';
import '../quiz.dart';

class LessonCubit extends Cubit<Lesson> {
  final List<Lesson> lessons;

  LessonCubit({required this.lessons}) : super(lessons.first);

  void setLesson(int number) {
    emit(lessons.firstWhere((lesson) => lesson.number == number));
  }

  void setContent(String content) {
    emit(state.copyWith(selectedContent: content));
  }

  void setContentClicked(String content) {
    Map<String, dynamic> hasClicked = state.copyWith().hasClicked;
    hasClicked[content] = true;
    emit(state.copyWith(hasClicked: hasClicked));
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
