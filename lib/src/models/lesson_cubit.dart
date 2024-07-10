import 'package:bloc/bloc.dart';

class LessonCubit extends Cubit<int> {
  LessonCubit() : super(1);

  void setLesson(int lesson) => emit(lesson);
}
