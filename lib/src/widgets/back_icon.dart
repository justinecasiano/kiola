import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants/colors.dart' as colors;
import '../constants/values.dart' as values;
import '../models/cubits/student_cubit.dart';

class BackIcon extends StatelessWidget {
  const BackIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<StudentCubit>().setContent('default');
      },
      child: const Icon(
        Icons.arrow_back_rounded,
        color: colors.accentDark,
        size: values.large + values.small,
      ),
    );
  }
}
