import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiola/src/models/lesson_summary.dart';
import 'package:websafe_svg/websafe_svg.dart';
import '../widgets/quiz_content.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../widgets/back_icon.dart';
import '../widgets/rounded_container.dart';
import '../extras/utils.dart';
import '../models/cubits/lesson_cubit.dart';
import '../models/cubits/navigation_cubit.dart';
import '../models/cubits/student_cubit.dart';
import '../models/lesson.dart';
import '../models/student.dart';
import '../widgets/custom_background.dart';
import '../constants/values.dart' as values;
import '../constants/colors.dart' as colors;

class LessonScreen extends StatelessWidget {
  const LessonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<StudentCubit, Student, String>(
      selector: (state) => state.getCurrentLessonSummary().selectedContent,
      builder: (BuildContext context, String selectedContent) {
        return ListView(
          key: selectedContent == 'default' ? UniqueKey() : null,
          physics: selectedContent == 'default'
              ? null
              : const NeverScrollableScrollPhysics(),
          children: [
            Stack(
              children: [
                const CustomBackground(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: values.medium),
                  child: Builder(
                    builder: (context) {
                      LessonSummary lessonSummary = context
                          .read<StudentCubit>()
                          .state
                          .getCurrentLessonSummary();

                      final contents = Column(
                        children: [
                          Header()
                              .animate(delay: 200.ms)
                              .fade(duration: 300.ms),
                          selectedContent == 'default' &&
                                  lessonSummary.number != 0
                              ? Contents()
                              : Expanded(child: Contents())
                        ],
                      );

                      return selectedContent == 'default' &&
                              lessonSummary.number != 0
                          ? contents
                          : SizedBox(
                              height: Utils.appGetHeight(context, 85),
                              child: contents,
                            );
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  dynamic getContentTitle(String title, String content, int number) {
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
    final lessonNumber = BlocSelector<LessonCubit, Lesson, int>(
      selector: (state) => state.number,
      builder: (BuildContext context, int number) {
        return FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            (number != 0) ? 'Lesson $number' : 'Course Materials',
            style: values.getTextStyle(context, 'titleLarge',
                color: colors.primary, weight: FontWeight.w700),
          ),
        );
      },
    );

    final progressIndicator = BlocSelector<StudentCubit, Student, int>(
      selector: (state) => state.getCurrentLessonSummary().progress.round(),
      builder: (BuildContext context, int progress) {
        return Text(
          '$progress%',
          textAlign: TextAlign.center,
          style: values.getTextStyle(context, 'titleLarge',
              color: colors.accentLight, weight: FontWeight.bold),
        );
      },
    );

    final contentTitle = BlocSelector<StudentCubit, Student, String>(
      selector: (state) => state.getCurrentLessonSummary().selectedContent,
      builder: (BuildContext context, String content) {
        Lesson lesson = context.watch<LessonCubit>().state;

        return Text(
          getContentTitle(lesson.title, content, lesson.number),
          style: values.getTextStyle(context, 'titleLarge',
              color: colors.primary, weight: FontWeight.w600),
        ).animate(delay: 500.ms).fade(duration: 500.ms);
      },
    );

    return Padding(
      padding: const EdgeInsets.only(
        top: values.medium,
        bottom: values.small,
        left: values.small - 3,
        right: values.small - 3,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                width: Utils.appGetWidth(context, 65),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      lessonNumber,
                      const SizedBox(height: values.small),
                      Text(
                        Utils.getDateTime('EEEE, MMMM d, y'),
                        style: values.getTextStyle(context, 'bodyMedium',
                            color: colors.primary, weight: FontWeight.w400),
                      ),
                    ]),
              ),
            ),
            RoundedContainer(
              borderRadius: values.medium - 5,
              child: Column(children: [
                progressIndicator,
                const SizedBox(height: values.small - 6),
                Text(
                  'Progress',
                  textAlign: TextAlign.center,
                  style: values.getTextStyle(context, 'bodySmall',
                      color: colors.accentDark, weight: FontWeight.w600),
                ),
              ]),
            )
                .animate(onPlay: ((controller) => controller.repeat()))
                .scaleXY(delay: 4000.ms, end: 1.1, duration: 500.ms)
                .shake(duration: 750.ms)
                .scaleXY(delay: 4500.ms, end: 0.9, duration: 500.ms)
          ],
        ),
        const SizedBox(height: values.large),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: values.medium),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: contentTitle,
          ),
        ),
        const SizedBox(height: values.small + 5),
      ]),
    );
  }
}

class Contents extends StatelessWidget {
  const Contents({super.key});

  Widget getContent(String content, Lesson lesson) {
    return {
      'default': DefaultContent(lesson: lesson),
      'pdf': PDFContent(
        title: lesson.title.toUpperCase(),
      ),
      'ppt': PPTContent(
        title: lesson.title.toUpperCase(),
      ),
      'video': VideoContent(
        title: lesson.title.toUpperCase(),
      ),
      if (lesson.number != 0)
        'quiz': QuizContent(
          lessonNumber: lesson.number,
          questions: lesson.questions!,
        )
    }[content]!;
  }

  @override
  Widget build(BuildContext context) {
    final content = BlocSelector<StudentCubit, Student, String>(
      selector: (state) => state.getCurrentLessonSummary().selectedContent,
      builder: (BuildContext context, String content) {
        final widget = getContent(content, context.read<LessonCubit>().state);
        return (content == 'quiz')
            ? widget
            : widget.animate(delay: 1000.ms).fade(duration: 500.ms);
      },
    );
    return RoundedContainer(
      padding: EdgeInsets.zero,
      borderRadius: values.medium,
      child: Stack(
        children: [
          Positioned(
              left: -values.medium,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: values.large + values.large + values.large),
                child: WebsafeSvg.asset('assets/images/heron.svg',
                    fit: BoxFit.contain),
              )),
          Padding(
            padding: const EdgeInsets.all(values.medium),
            child: content,
          ),
        ],
      ),
    );
  }
}

class DefaultContent extends StatelessWidget {
  final Lesson lesson;

  const DefaultContent({super.key, required this.lesson});

  List<Widget> hasVideoContent(BuildContext context) {
    return (lesson.hasVideo)
        ? [
            const SizedBox(height: values.medium),
            ContentCard(
                type: 'video',
                title: 'Video for ${lesson.title}',
                thumbnail: 'content/video.png',
                onTap: onTap(context, 'video'))
          ]
        : [];
  }

  Function() onTap(BuildContext context, String content) {
    return () {
      context.read<StudentCubit>().setContent(content);
    };
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> contents = lesson.number == 0
        ? [
            ContentCard(
              type: 'pdf',
              title: 'Course Outline - PDF',
              thumbnail: 'content/pdf/lesson-${lesson.number}.png',
              onTap: onTap(context, 'pdf'),
            ),
          ]
        : [
            ContentCard(
              type: 'pdf',
              title: '${lesson.title} - PDF',
              thumbnail: 'content/pdf/lesson-${lesson.number}.png',
              onTap: onTap(context, 'pdf'),
            ),
            const SizedBox(height: values.medium),
            ContentCard(
              type: 'ppt',
              title: '${lesson.title} - PPT',
              thumbnail: 'content/ppt/lesson-${lesson.number}.png',
              onTap: onTap(context, 'ppt'),
            ),
            ...hasVideoContent(context),
            const SizedBox(height: values.medium),
            ContentCard(
              type: 'quiz',
              title: 'Quiz for ${lesson.title}',
              thumbnail: 'content/quiz.png',
              onTap: onTap(context, 'quiz'),
            )
          ];

    return Column(
      children: contents
          .animate(delay: 1000.ms, interval: 100.ms)
          .scale(duration: 200.ms)
          .slideX(duration: 200.ms),
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
                context.read<StudentCubit>().setContentClicked('pdf');
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
                context.read<StudentCubit>().setContentClicked('ppt');
              }
            },
          ),
        ),
      ],
    );
  }
}

class VideoContent extends StatefulWidget {
  final String title;

  const VideoContent({super.key, required this.title});

  @override
  State<VideoContent> createState() => _VideoContentState();
}

class _VideoContentState extends State<VideoContent> {
  late final player = Player();
  late final controller = VideoController(player);

  @override
  void initState() {
    super.initState();
    player.open(Media('asset:///assets/videos/${widget.title}.mp4'));
    player.stream.completed.listen((isCompleted) {
      isCompleted
          ? context.read<StudentCubit>().setContentClicked('video')
          : null;
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BackIcon(),
        const SizedBox(height: values.small),
        Expanded(
          child: BlocListener<NavigationCubit, int>(
            listener: (BuildContext context, int state) {
              (state == 1) ? player.play() : player.pause();
            },
            child: Video(controller: controller),
          ),
        )
      ],
    );
  }
}

class ContentCard extends StatelessWidget {
  final String type;
  final String title;
  final String thumbnail;
  final Function() onTap;

  const ContentCard({
    super.key,
    required this.type,
    required this.title,
    required this.thumbnail,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: RoundedContainer(
        padding: EdgeInsets.zero,
        borderRadius: values.medium,
        child: Stack(
          children: [
            SizedBox(
                width: double.infinity,
                height: 115,
                child: Image.asset('assets/images/thumbnails/$thumbnail',
                    fit: BoxFit.fitWidth)),
            Padding(
              padding: const EdgeInsets.only(
                  left: values.small + 5,
                  right: values.small + 5,
                  bottom: values.small),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 95),
                  BlocSelector<StudentCubit, Student, String>(
                    selector: (state) =>
                        state.getCurrentLessonSummary().getContentStatus(type),
                    builder: (context, status) {
                      return RoundedContainer(
                        color: status == 'Pending'
                            ? colors.primary
                            : colors.accentDark,
                        child: Text(
                          status,
                          textAlign: TextAlign.center,
                          style: values.getTextStyle(context, 'titleSmall',
                              color: status == 'Pending'
                                  ? colors.accentDark
                                  : colors.primary,
                              weight: FontWeight.bold),
                        )
                            .animate(delay: 2200.ms)
                            .scaleXY(end: 1.1, duration: 500.ms)
                            .shake(duration: 750.ms)
                            .scaleXY(delay: 500.ms, end: 0.9, duration: 500.ms),
                      );
                    },
                  ),
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
          ],
        ),
      ),
    );
  }
}
