import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/src/widgets/rounded_container.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../extras/utils.dart';
import '../models/cubits/lesson_cubit.dart';
import '../models/cubits/student_cubit.dart';
import '../models/lesson.dart';
import '../models/student.dart';
import '../widgets/custom_background.dart';
import '../constants/values.dart' as values;
import '../constants/colors.dart' as colors;
import '../widgets/quiz_content.dart';

class LessonScreen extends StatelessWidget {
  const LessonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LessonCubit, Lesson>(
      builder: (BuildContext context, Lesson lesson) {
        return CustomBackground(
          isScrollable: lesson.selectedContent == 'default',
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: values.medium),
            child: BlocBuilder<StudentCubit, Student>(
                builder: (BuildContext context, Student student) {
              return lesson.selectedContent == 'default'
                  ? Column(children: [
                      Header(lesson: lesson, student: student),
                      Contents(lesson: lesson)
                    ])
                  : SizedBox(
                      height: Utils.appGetHeight(context, 85),
                      child: Column(children: [
                        Header(lesson: lesson, student: student),
                        Expanded(child: Contents(lesson: lesson))
                      ]),
                    );
            }),
          ),
        );
      },
    );
  }
}

class Header extends StatelessWidget {
  final Lesson? lesson;
  final Student? student;

  const Header({super.key, required this.lesson, required this.student});

  dynamic getContentTitle(BuildContext context) {
    String content = lesson!.selectedContent;
    int number = lesson!.number;
    String title = lesson!.title.toUpperCase();

    return {
      'default': title,
      'pdf': '$title - PDF',
      'ppt': '$title - PPT',
      'video': '$title - Video',
      'quiz': 'Quiz $number - $title'
    }[content];
  }

  @override
  Widget build(BuildContext context) {
    int number = lesson!.number;
    int progress = student!.lessonStanding[number - 1].progress.round();

    return Padding(
      padding: const EdgeInsets.only(
          top: values.medium,
          bottom: values.small,
          left: values.small - 3,
          right: values.small - 3),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(
            child: SizedBox(
              width: Utils.appGetWidth(context, 65),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lesson $number',
                      style: values.getTextStyle(context, 'titleLarge',
                          color: colors.primary, weight: FontWeight.w700),
                    ),
                    const SizedBox(height: values.small),
                    Text(
                      Utils.getDateTime('EEEE, MMMM d y'),
                      style: values.getTextStyle(context, 'bodyMedium',
                          color: colors.primary, weight: FontWeight.w400),
                    ),
                  ]),
            ),
          ),
          RoundedContainer(children: [
            Text(
              '$progress%',
              textAlign: TextAlign.center,
              style: values.getTextStyle(context, 'titleLarge',
                  color: colors.accentLight, weight: FontWeight.bold),
            ),
            const SizedBox(height: values.small - 6),
            Text(
              'Progress',
              textAlign: TextAlign.center,
              style: values.getTextStyle(context, 'bodySmall',
                  color: colors.accentDark, weight: FontWeight.w600),
            ),
          ])
        ]),
        const SizedBox(height: values.large),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: values.medium),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              getContentTitle(context),
              style: values.getTextStyle(context, 'titleLarge',
                  color: colors.primary, weight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: values.small + 5),
      ]),
    );
  }
}

class Contents extends StatelessWidget {
  final Lesson lesson;
  const Contents({super.key, required this.lesson});

  dynamic getContent(String content) {
    return {
      'default': DefaultContent(lesson: lesson),
      'pdf': PDFContent(
        title: lesson.title.toUpperCase(),
      ),
      'ppt': PPTContent(
        title: lesson.title.toUpperCase(),
      ),
      'video': VideoContent(),
      'quiz': QuizContent(quiz: lesson.quiz)
    }[content];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: BorderRadius.circular(values.medium),
      ),
      child: Padding(
        padding: const EdgeInsets.all(values.medium),
        child: getContent(lesson!.selectedContent),
      ),
    );
  }
}

class DefaultContent extends StatelessWidget {
  final Lesson lesson;

  const DefaultContent({super.key, required this.lesson});

  List<Widget> hasVideoContent(BuildContext context) {
    return (lesson.hasVideo())
        ? [
            const SizedBox(height: values.medium),
            ContentCard(
                title: 'Video for ${lesson.title}',
                status: lesson.getContentStatus('video'),
                thumbnail: 'content/content-3.png',
                number: lesson.number,
                onTap: onTap(context, 'video'))
          ]
        : [];
  }

  Function() onTap(BuildContext context, String content) {
    return () {
      context.read<LessonCubit>().setContent(content);
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ContentCard(
          title: '${lesson.title} - PDF',
          status: lesson.getContentStatus('pdf'),
          thumbnail: 'content/content-1.png',
          number: lesson.number,
          onTap: onTap(context, 'pdf'),
        ),
        const SizedBox(height: values.medium),
        ContentCard(
          title: '${lesson.title} - PPT',
          status: lesson.getContentStatus('ppt'),
          thumbnail: 'content/content-2.png',
          number: lesson.number,
          onTap: onTap(context, 'ppt'),
        ),
        ...hasVideoContent(context),
        const SizedBox(height: values.medium),
        ContentCard(
          title: 'Quiz for ${lesson.title}',
          status: lesson.getContentStatus('quiz'),
          thumbnail: 'content/content-3.png',
          number: lesson.number,
          onTap: onTap(context, 'quiz'),
        )
      ],
    );
  }
}

class PDFContent extends StatelessWidget {
  final String title;

  const PDFContent({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BackIcon(),
        const SizedBox(height: values.small),
        Expanded(
          child: SfPdfViewer.asset(
            'assets/modules/$title.pdf',
            canShowPaginationDialog: false,
            onPageChanged: (page) {
              if (page.isLastPage) {
                context.read<StudentCubit>().setLessonProgress(context, 'pdf');
              }
            },
          ),
        ),
      ],
    );
  }
}

class PPTContent extends StatelessWidget {
  final String title;
  const PPTContent({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BackIcon(),
        const SizedBox(height: values.small),
        Expanded(
          child: SfPdfViewer.asset(
            'assets/powerpoints/$title.pdf',
            canShowPaginationDialog: false,
            onPageChanged: (page) {
              if (page.isLastPage) {
                context.read<StudentCubit>().setLessonProgress(context, 'ppt');
              }
            },
          ),
        ),
      ],
    );
  }
}

class VideoContent extends StatelessWidget {
  const VideoContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [BackIcon()],
    );
  }
}

class ContentCard extends StatelessWidget {
  final Function() onTap;
  final String title;
  final String thumbnail;
  final String status;
  final int number;

  const ContentCard(
      {super.key,
      required this.onTap,
      required this.title,
      required this.status,
      required this.thumbnail,
      required this.number});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: RoundedContainer(
        padding: EdgeInsets.zero,
        borderRadius: values.medium,
        children: [
          Stack(children: [
            SizedBox(
                height: 115,
                child: Image.asset('assets/images/thumbnails/$thumbnail',
                    fit: BoxFit.cover)),
            Padding(
              padding: const EdgeInsets.only(
                  left: values.small + 5,
                  right: values.small + 5,
                  bottom: values.small),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 95),
                  RoundedContainer(children: [
                    Text(
                      status,
                      textAlign: TextAlign.center,
                      style: values.getTextStyle(context, 'titleSmall',
                          color: colors.accentDark, weight: FontWeight.w600),
                    ),
                  ]),
                  const SizedBox(height: values.small - 5),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: values.getTextStyle(context, 'titleMedium',
                        color: colors.secondary, weight: FontWeight.w500),
                  ),
                ],
              ),
            )
          ])
        ],
      ),
    );
  }
}

class BackIcon extends StatelessWidget {
  const BackIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<LessonCubit>().setContent('default');
      },
      child: const Icon(
        Icons.arrow_back_rounded,
        color: colors.accentDark,
        size: values.large + values.small,
      ),
    );
  }
}
