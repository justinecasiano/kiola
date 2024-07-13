import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/src/widgets/rounded_container.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../extras/utils.dart';
import '../models/cubits/lesson_cubit.dart';
import '../models/lesson.dart';
import '../widgets/custom_background.dart';
import '../constants/values.dart' as values;
import '../constants/colors.dart' as colors;

class LessonScreen extends StatelessWidget {
  const LessonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Lesson? lesson = context.watch<LessonCubit>().state;

    return const CustomBackground(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: values.medium),
      child: Column(children: [Header(), Contents()]),
    ));
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  dynamic getContentTitle(BuildContext context, Lesson? lesson) {
    String? content = context.read<LessonCubit>().getContent();
    String title = lesson!.title.toUpperCase();
    int number = lesson.number;

    return content == null
        ? title
        : {
            'pdf': '$title - PDF',
            'ppt': '$title - PPT',
            'video': '$title - Video',
            'quiz': 'Quiz for $title'
          }[content];
  }

  @override
  Widget build(BuildContext context) {
    Lesson? lesson = context.watch<LessonCubit>().state;
    int? number = context.watch<LessonCubit>().state!.number;

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
              getContentTitle(context, lesson),
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
    return content == null
        ? const DefaultContent()
        : const {
            'pdf': PDFContent(),
            'ppt': PPTContent(),
            'video': VideoContent(),
            'quiz': QuizContent()
          }[content];
  }

  @override
  Widget build(BuildContext context) {
    Lesson? lesson = context.watch<LessonCubit>().state;
    String? content = context.read<LessonCubit>().getContent();

    print('Content: $content');

    return Container(
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: BorderRadius.circular(values.medium),
      ),
      child: Padding(
        padding: const EdgeInsets.all(values.medium),
        child: getContent(context.read<LessonCubit>().getContent()),
      ),
    );
  }
}

class DefaultContent extends StatelessWidget {
  const DefaultContent({super.key});

  List<Widget> hasVideo(BuildContext context) {
    Lesson? lesson = context.read<LessonCubit>().state;

    return (lesson.hasVideo)
        ? [
            const SizedBox(height: values.medium),
            ContentCard(
                title: 'Video for ${lesson.title}',
                thumbnail: 'content/content-3.png',
                onTap: onTap(context, 'video'))
          ]
        : [];
  }

  Function() onTap(BuildContext context, String content) {
    return () {
      context.read<LessonCubit>().setContent(content);
      print(context.read<LessonCubit>().getContent());
    };
  }

  @override
  Widget build(BuildContext context) {
    Lesson? lesson = context.watch<LessonCubit>().state;
    String title = lesson!.title;

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
    Lesson? lesson = context.watch<LessonCubit>().state;
    String title = context.read<LessonCubit>().state.title.toUpperCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BackIcon(),
        const SizedBox(height: values.small),
        SizedBox(
            width: Utils.appGetWidth(context, 100),
            height: Utils.appGetWidth(context, 100),
            child: SfPdfViewer.asset('assets/modules/$title.pdf')),
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
      children: [
        BackIcon(),
      ],
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
                      'Lesson ${context.read<LessonCubit>().state!.number}',
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
        context.read<LessonCubit>().setContent(null);
        print(context.read<LessonCubit>().getContent());
      },
      child: const Icon(
        Icons.arrow_back_rounded,
        color: colors.accentDark,
        size: values.large,
      ),
    );
  }
}
