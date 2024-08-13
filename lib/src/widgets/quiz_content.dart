import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiola/src/models/cubits/student_cubit.dart';
import '../models/question.dart';
import '../models/student.dart';
import 'back_icon.dart';

import '../constants/colors.dart' as colors;
import '../constants/values.dart' as values;
import 'rounded_container.dart';

class QuizContent extends StatelessWidget {
  final int lessonNumber;
  final List<Question> questions;

  late final Map<String, Widget> contents = {
    'inactive': QuizIntro().animate(delay: 1000.ms).fade(duration: 500.ms),
    'active': QuizBody(questions: questions),
    'completed': QuizOutro(
      questions: questions,
      lessonNumber: lessonNumber,
    ).animate(delay: 1000.ms).fade(duration: 500.ms),
  };

  QuizContent({
    super.key,
    required this.lessonNumber,
    required this.questions,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<StudentCubit, Student, String>(
      selector: (state) => state.getLessonQuizSummary().status,
      builder: (context, state) {
        return contents[state]!;
      },
    );
  }
}

class QuizIntro extends StatelessWidget {
  const QuizIntro({super.key});

  @override
  Widget build(BuildContext context) {
    bool hasStarted =
        context.read<StudentCubit>().state.getLessonQuizSummary().hasStarted();

    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: values.large + values.small, vertical: values.large),
        child: Text(
          'Would you like to ${hasStarted ? 'continue' : 'start'} the quiz now?',
          textAlign: TextAlign.center,
          style: values.getTextStyle(context, 'titleMedium',
              color: colors.accentDark, weight: FontWeight.w600),
        ),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(values.large),
                side: BorderSide(color: colors.secondary, width: 1),
              )),
          child: Text(
            'Yes',
            style: values.getTextStyle(context, 'titleSmall',
                color: colors.secondary, weight: FontWeight.bold),
          ),
          onPressed: () {
            context.read<StudentCubit>().setQuizStatus('active');
          },
        ),
        const SizedBox(width: values.medium),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(values.large),
                side: BorderSide(color: colors.secondary, width: 1),
              )),
          child: Text(
            'No',
            style: values.getTextStyle(context, 'titleSmall',
                color: colors.secondary, weight: FontWeight.bold),
          ),
          onPressed: () {
            context.read<StudentCubit>().setContent('default');
          },
        )
      ]),
    ]);
  }
}

class QuizBody extends StatefulWidget {
  final List<Question> questions;

  const QuizBody({super.key, required this.questions});

  @override
  State<QuizBody> createState() => _QuizBodyState();
}

class _QuizBodyState extends State<QuizBody> with WidgetsBindingObserver {
  late Timer timer;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed");
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        Future.delayed(0.ms, () {
          if (timer.isActive) timer.cancel();
          context.read<StudentCubit>().setQuizStatus('inactive');
        });
        break;
      default:
    }
  }

  @override
  void initState() {
    super.initState();
    startTimer();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    timer.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (context.read<StudentCubit>().getQuestionRemainingTime() == 0) {
        onAnswerSelect(context, null);
      } else {
        context.read<StudentCubit>().updateQuestionRemainingTime();
      }
    });
  }

  void onAnswerSelect(BuildContext context, int? answer) {
    timer.cancel();
    context.read<StudentCubit>().setQuestionAnswer(answer);

    Future.delayed(1.seconds, () {
      context.read<StudentCubit>().moveCurrentNumber(context);
      startTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustomTimer(),
        Expanded(
          child: BlocSelector<StudentCubit, Student, int>(
            selector: (state) => state.getLessonQuizSummary().currentNumber,
            builder: (context, currentNumber) {
              return QuestionBuilder(
                currentNumber: currentNumber,
                questions: widget.questions,
                onAnswerSelect: () => onAnswerSelect,
              );
            },
          ),
        )
      ],
    );
  }
}

class QuestionBuilder extends StatelessWidget {
  final bool isReadOnly;
  final int? currentNumber;
  final List<Question> questions;
  final Function()? onAnswerSelect;

  const QuestionBuilder({
    super.key,
    this.isReadOnly = false,
    required this.questions,
    this.currentNumber,
    this.onAnswerSelect,
  });

  Widget generateQuestion(BuildContext context, Question question, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: values.small),
        RoundedContainer(
          border: Border.all(color: colors.accentDark, width: 2),
          borderRadius: values.small,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              'Question ${index + 1}',
              style: values.getTextStyle(context, 'titleLarge',
                  color: colors.accentLight, weight: FontWeight.bold),
            ),
            const SizedBox(height: values.small),
            Text(
              question.question,
              style: values.getTextStyle(context, 'titleMedium',
                  color: colors.secondary, weight: FontWeight.w500),
            ),
          ]),
        ).animate(delay: 200.ms).fade(duration: 300.ms),
        const SizedBox(height: values.medium),
        isReadOnly
            ? OptionBuilder(
                index: index,
                isReadOnly: isReadOnly,
                options: question.options,
              )
            : OptionBuilder(
                options: question.options,
                onAnswerSelect: onAnswerSelect,
              )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return isReadOnly
        ? Column(
            children: questions
                .asMap()
                .entries
                .map((question) {
                  return [
                    generateQuestion(context, question.value, question.key),
                    const SizedBox(height: values.small - 5),
                  ];
                })
                .expand<Widget>((i) => i)
                .toList(),
          )
        : ListView(
            key: ObjectKey(questions[currentNumber!]),
            children: [
              generateQuestion(
                  context, questions[currentNumber!], currentNumber!)
            ],
          );
  }
}

class OptionBuilder extends StatelessWidget {
  final int? index;
  final List<String> options;
  final Function()? onAnswerSelect;
  final bool isReadOnly;

  OptionBuilder({
    super.key,
    this.index,
    required this.options,
    this.onAnswerSelect,
    this.isReadOnly = false,
  });

  Widget createOption(BuildContext context, int key, String value,
      int? selected, bool isDisabled) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
            vertical: values.small + 5, horizontal: values.large),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(values.large),
          side: BorderSide(color: colors.secondary, width: 1),
        ),
        foregroundColor: colors.accentDark,
        overlayColor: colors.accentDark,
        backgroundColor: key == selected ? colors.accentDark : colors.primary,
        disabledBackgroundColor:
            key == selected ? colors.accentDark : colors.primary,
      ),
      onPressed: isDisabled ? null : () => onAnswerSelect!()(context, key),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          value,
          style: values.getTextStyle(context, 'titleSmall',
              color: key == selected ? colors.primary : colors.secondary,
              weight: FontWeight.w500),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options
          .asMap()
          .entries
          .map((option) {
            return [
              BlocSelector<StudentCubit, Student, bool>(
                selector: (state) =>
                    state.getLessonQuizSummary().getRemainingTime() == 0 ||
                    state.getLessonQuizSummary().getCurrentAnswer() != null,
                builder: (context, isDisabled) {
                  final int? selected = isReadOnly
                      ? context
                          .read<StudentCubit>()
                          .state
                          .getLessonQuizSummary()
                          .viewCurrentAnswer(index!)
                      : context
                          .read<StudentCubit>()
                          .state
                          .getLessonQuizSummary()
                          .getCurrentAnswer();
                  return createOption(
                      context, option.key, option.value, selected, isDisabled);
                },
              ),
              const SizedBox(height: values.medium),
            ];
          })
          .expand<Widget>((i) => i)
          .toList()
          .animate(delay: 400.ms, interval: 200.ms)
          .scale(duration: 300.ms)
          .slideX(duration: 300.ms),
    );
  }
}

class QuizOutro extends StatelessWidget {
  final int lessonNumber;
  final List<Question> questions;

  const QuizOutro({
    super.key,
    required this.lessonNumber,
    required this.questions,
  });

  @override
  Widget build(BuildContext context) {
    String? name = context.read<StudentCubit>().state.username;
    int score =
        context.read<StudentCubit>().state.getLessonQuizSummary().score!;

    return ListView(
      children: [
        Align(alignment: Alignment.topLeft, child: BackIcon()),
        const SizedBox(height: values.small - 5),
        Text(
          'Summary',
          textAlign: TextAlign.center,
          style: values.getTextStyle(context, 'titleLarge',
              color: colors.secondary, weight: FontWeight.w500),
        ),
        const SizedBox(height: values.medium),
        RoundedContainer(
          borderRadius: values.small + 5,
          padding: EdgeInsets.symmetric(
              horizontal: values.small, vertical: values.small + 5),
          border: Border.all(color: colors.secondary, width: 2),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '$name',
              style: values.getTextStyle(context, 'titleLarge',
                  color: colors.secondary, weight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: values.medium),
        AccuracyBar(percentage: score / 10),
        const SizedBox(height: values.medium),
        Text(
          'Performance Statistics',
          textAlign: TextAlign.center,
          style: values.getTextStyle(context, 'titleMedium',
              color: colors.secondary, weight: FontWeight.w500),
        ),
        const SizedBox(height: values.medium - 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: values.large),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: RoundedContainer(
                  borderRadius: values.small + 5,
                  padding: EdgeInsets.symmetric(
                      vertical: values.small, horizontal: values.medium),
                  border: Border.all(color: colors.secondary, width: 2),
                  child: Column(
                    children: [
                      Text(
                        '$score',
                        style: values.getTextStyle(context, 'headlineLarge',
                            color: colors.accentLight, weight: FontWeight.bold),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Correct',
                          style: values.getTextStyle(context, 'titleSmall',
                              color: colors.accentDark,
                              weight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                )
                    .animate(delay: 1500.ms)
                    .scaleXY(end: 1.1, duration: 500.ms)
                    .shake(duration: 750.ms)
                    .scaleXY(delay: 500.ms, end: 0.9, duration: 500.ms),
              ),
              const SizedBox(width: values.medium),
              Expanded(
                child: RoundedContainer(
                  borderRadius: values.small + 5,
                  padding: EdgeInsets.symmetric(
                      vertical: values.small, horizontal: values.medium),
                  border: Border.all(color: colors.secondary, width: 2),
                  child: Column(
                    children: [
                      Text(
                        '${10 - score}',
                        style: values.getTextStyle(context, 'headlineLarge',
                            color: Colors.grey, weight: FontWeight.bold),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Incorrect',
                          style: values.getTextStyle(context, 'titleSmall',
                              color: colors.accentDark,
                              weight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                )
                    .animate(delay: 1500.ms)
                    .scaleXY(end: 1.1, duration: 500.ms)
                    .shake(duration: 750.ms)
                    .scaleXY(delay: 500.ms, end: 0.9, duration: 500.ms),
              ),
            ],
          ),
        ),
        const SizedBox(height: values.large),
        Text(
          'Answers Overview',
          textAlign: TextAlign.center,
          style: values.getTextStyle(context, 'titleMedium',
              color: colors.secondary, weight: FontWeight.w500),
        ),
        const SizedBox(height: values.small - 5),
        QuestionBuilder(isReadOnly: true, questions: questions),
      ],
    );
  }
}

class CustomTimer extends StatelessWidget {
  const CustomTimer({super.key});

  @override
  Widget build(BuildContext context) {
    final remainingTime = BlocSelector<StudentCubit, Student, int>(
      selector: (state) => state.getLessonQuizSummary().getRemainingTime(),
      builder: (context, remainingTime) => Text(
        '$remainingTime',
        style: values.getTextStyle(context, 'titleLarge',
            color: colors.secondary, weight: FontWeight.bold),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(right: values.small - 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [Icon(Icons.timer, color: colors.secondary), remainingTime]
            .animate(onPlay: (controller) => controller.repeat())
            .scaleXY(end: 1.1, duration: 500.ms)
            .shake(duration: 750.ms)
            .scaleXY(delay: 500.ms, end: 0.9, duration: 500.ms),
      ),
    );
  }
}

class AccuracyBar extends StatelessWidget {
  final double percentage;

  const AccuracyBar({super.key, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      border: Border.all(color: colors.secondary, width: 2),
      padding: EdgeInsets.all(values.small + 5),
      borderRadius: values.small + 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Accuracy',
            style: values.getTextStyle(context, 'titleSmall',
                color: colors.secondary, weight: FontWeight.w500),
          ),
          const SizedBox(height: values.small),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = percentage * constraints.maxWidth;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: values.medium,
                    child: RoundedContainer(
                      color: colors.primaryShade,
                      border: Border.all(width: 0),
                      padding: EdgeInsets.zero,
                      borderRadius: values.small - 5,
                      child: Padding(
                        padding: EdgeInsets.only(
                            right: constraints.maxWidth - width),
                        child: RoundedContainer(
                          color: colors.accentDark,
                          border: Border.all(width: 0),
                          borderRadius: values.small - 5,
                        )
                            .animate(delay: 1750.ms)
                            .slideX(begin: -1, duration: 1000.ms),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -(values.small - 5),
                    child: Padding(
                      padding: EdgeInsets.only(left: width),
                      child: RoundedContainer(
                        padding: EdgeInsets.all(values.small - 5),
                        border: Border.all(color: colors.accentDark, width: 1),
                        borderRadius: values.small,
                        child: Text(
                          '${(percentage * 100).round()}%',
                          style: values.getTextStyle(context, 'titleSmall',
                              color: colors.accentDark,
                              weight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ).animate(delay: 1750.ms).moveX(
                      begin: -width,
                      end: switch (percentage) {
                        0 => 0,
                        >= 0.7 && <= 1 => -38,
                        >= 0.1 && <= 0.3 => -10,
                        _ => -20,
                      },
                      duration: 1000.ms),
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
