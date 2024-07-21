import 'package:flutter/material.dart';
import '../constants/colors.dart' as colors;
import '../constants/values.dart' as values;
import '../models/quiz.dart';

class QuizContent extends StatelessWidget {
  final Quiz quiz;
  final dynamic contents = const {
    'active': QuizIntro(),
    'inactive': QuizBody(),
    'completed': QuizOutro()
  };

  const QuizContent({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    return contents[quiz.status];
  }
}

class QuizIntro extends StatelessWidget {
  const QuizIntro({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
        'Would you like to start the quiz now?',
        style: values.getTextStyle(context, 'titleMedium',
            color: colors.secondary, weight: FontWeight.w500),
      ),
    ]);
  }
}

class QuizBody extends StatelessWidget {
  const QuizBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
        'Time remaining',
        style: values.getTextStyle(context, 'titleMedium',
            color: colors.secondary, weight: FontWeight.w500),
      ),
    ]);
  }
}

class QuizOutro extends StatelessWidget {
  const QuizOutro({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
        'Summary',
        style: values.getTextStyle(context, 'titleLarge',
            color: colors.secondary, weight: FontWeight.w500),
      ),
    ]);
  }
}
