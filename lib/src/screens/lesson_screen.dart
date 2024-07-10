import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/src/widgets/rounded_container.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../extras/utils.dart';
import '../models/content_cubit.dart';
import '../models/lesson_cubit.dart';
import '../widgets/custom_background.dart';
import '../constants/values.dart' as values;
import '../constants/colors.dart' as colors;

class LessonScreen extends StatelessWidget {
  const LessonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String? state = context.watch<ContentCubit>().state;

    return const CustomBackground(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: values.medium),
      child: Column(children: [Header(), Contents()]),
    ));
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  dynamic getContentTitle(BuildContext context, int lesson, String? content) {
    String lessonTitle = Utils.getLesson(lesson)['title'].toUpperCase();

    return content == null
        ? lessonTitle
        : {
            'pdf': '$lessonTitle - PDF',
            'ppt': '$lessonTitle - PPT',
            'video': '$lessonTitle - Video',
            'quiz': 'Quiz $lesson - $lessonTitle'
          }[content];
  }

  @override
  Widget build(BuildContext context) {
    int lesson = context.watch<LessonCubit>().state;
    String? content = context.watch<ContentCubit>().state;

    return Padding(
      padding: const EdgeInsets.only(
          top: values.medium,
          bottom: values.small,
          left: values.small - 3,
          right: values.small - 3),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Row(children: [
          Expanded(
            child: SizedBox(
              width: Utils.appGetWidth(context, 65),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lesson $lesson',
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
              '100%',
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
          padding: const EdgeInsets.symmetric(horizontal: values.small),
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              getContentTitle(context, lesson, content),
              textAlign: TextAlign.center,
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
  const Contents({super.key});

  dynamic getContent(String? content) {
    const lessonContents = {
      'pdf': PDFContent(),
      'ppt': PPTContent(),
      'video': VideoContent(),
      'quiz': QuizContent()
    };

    return content == null ? const DefaultContent() : lessonContents[content];
  }

  @override
  Widget build(BuildContext context) {
    String? content = context.watch<ContentCubit>().state;

    return Container(
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: BorderRadius.circular(values.medium),
      ),
      child: Padding(
          padding: const EdgeInsets.all(values.medium),
          child: getContent(content)),
    );
  }
}

class DefaultContent extends StatelessWidget {
  const DefaultContent({super.key});

  List<Widget> hasVideo(BuildContext context) {
    int lesson = context.read<LessonCubit>().state;

    return (Utils.getLesson(lesson)['hasVideo'] != null)
        ? [
            const SizedBox(height: values.medium),
            ContentCard(
                title: 'Video for ${Utils.getLesson(lesson)['title']}',
                thumbnail: 'content/content-3.png',
                onTap: onTap(context, 'video'))
          ]
        : [];
  }

  Function() onTap(BuildContext context, String content) {
    return () {
      context.read<ContentCubit>().setContent(content);
    };
  }

  @override
  Widget build(BuildContext context) {
    int lesson = context.watch<LessonCubit>().state;
    String title = Utils.getLesson(lesson)['title'];

    return Column(
      children: [
        ContentCard(
          title: '$title - PDF',
          thumbnail: 'content/content-1.png',
          onTap: onTap(context, 'pdf'),
        ),
        const SizedBox(height: values.medium),
        ContentCard(
          title: '$title - PPT',
          thumbnail: 'content/content-2.png',
          onTap: onTap(context, 'ppt'),
        ),
        ...hasVideo(context),
        const SizedBox(height: values.medium),
        ContentCard(
          title: 'Quiz for $title',
          thumbnail: 'content/content-3.png',
          onTap: onTap(context, 'quiz'),
        )
      ],
    );
  }
}

class PDFContent extends StatelessWidget {
  const PDFContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BackIcon(),
        SfPdfViewer.asset(
            'assets/modules/${Utils.getLesson(context.read<LessonCubit>().state).toUpperCase()}.pdf')
      ],
    );
  }
}

class PPTContent extends StatelessWidget {
  const PPTContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [BackIcon()],
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

class QuizContent extends StatelessWidget {
  const QuizContent({super.key});

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

  const ContentCard(
      {super.key,
      required this.onTap,
      required this.title,
      required this.thumbnail});

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
                      'Lesson ${context.read<LessonCubit>().state}',
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
        context.read<ContentCubit>().setContent(null);
      },
      child: const Icon(
        Icons.arrow_back_rounded,
        color: colors.accentDark,
        size: values.large,
      ),
    );
  }
}
