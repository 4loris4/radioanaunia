import 'dart:ui';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart' as other;
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_series/flutter_series.dart';
import 'package:just_audio/just_audio.dart';
import 'package:radioanaunia/components/archiveTab/audio_player_tile.dart';
import 'package:radioanaunia/main.dart';
import 'package:radioanaunia/utils_functions.dart';

class ProgressBar extends StatelessWidget {
  final AudioPlayer audioPlayer;
  final PlayerData? playerData;
  final double spacing;
  final void Function(ThumbDragDetails details)? onDragUpdate;
  final void Function()? onDragEnd;

  const ProgressBar({
    required this.audioPlayer,
    required this.playerData,
    this.spacing = 16,
    this.onDragUpdate,
    this.onDragEnd,
    super.key,
  });

  bool get hasError => playerData?.playerState.processingState == ProcessingState.idle;

  String _durationText(BuildContext context, PlayerData? positionData) {
    if (positionData == null) return "--:--/--:--";
    if (hasError) return lang(context).notAvailable;

    final forceHours = positionData.duration.inHours > 0;
    return "${positionData.position.toShortString(forceHours)}/${positionData.duration.toShortString(forceHours)}";
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return PadRow(
      spacing: spacing,
      children: [
        Expanded(
          child: IgnorePointer(
            ignoring: hasError,
            child: other.ProgressBar(
              barHeight: 4,
              baseBarColor: primaryColor.withOpacity(.15),
              bufferedBarColor: hasError ? Colors.transparent : primaryColor.withOpacity(.25),
              progressBarColor: hasError ? Colors.transparent : primaryColor,
              thumbColor: hasError ? Colors.transparent : primaryColor,
              thumbRadius: 9,
              thumbGlowRadius: 18,
              timeLabelLocation: TimeLabelLocation.none,
              progress: playerData?.position ?? Duration.zero,
              buffered: playerData?.bufferedPosition ?? Duration.zero,
              total: playerData?.duration ?? Duration.zero,
              onDragUpdate: onDragUpdate,
              onDragEnd: onDragEnd,
              onSeek: audioPlayer.seek,
            ),
          ),
        ),
        Text(
          _durationText(context, playerData),
          style: const TextStyle(
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        )
      ],
    );
  }
}
