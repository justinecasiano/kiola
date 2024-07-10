import 'package:bloc/bloc.dart';

class ContentCubit extends Cubit<String?> {
  ContentCubit() : super(null);

  void setContent(String? content) => emit(content);
}
