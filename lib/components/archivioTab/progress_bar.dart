import 'dart:ui';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart' as other;
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_series/flutter_series.dart';
import 'package:just_audio/just_audio.dart';
import 'package:radioanaunia/components/archivioTab/audio_player_tile.dart';
import 'package:radioanaunia/utils_functions.dart';

class ProgressBar extends StatelessWidget {
  final AudioPlayer audioPlayer;
  final PlayerData? playerData;
  final double spacing;
  final void Function(ThumbDragDetails details)? onDragUpdate;
  final void Function()? onDragEnd;

  ProgressBar({
    required this.audioPlayer,
    required this.playerData,
    this.spacing = 16,
    this.onDragUpdate,
    this.onDragEnd,
    super.key,
  });

  bool get hasError => playerData?.playerState.processingState == ProcessingState.idle;

  String _durationText(PlayerData? positionData) {
    if (positionData == null) return "--:--/--:--";
    if (hasError) return "Non disponibile";

    final forceHours = positionData.duration.inHours > 0;
    return "${positionData.position.toShortString(forceHours)}/${positionData.duration.toShortString(forceHours)}";
  }

  @override
  Widget build(BuildContext context) {
    return PadRow(
      spacing: spacing,
      children: [
        Expanded(
          child: IgnorePointer(
            ignoring: hasError,
            child: other.ProgressBar(
              barHeight: 4,
              baseBarColor: Colors.white.withAlpha(32),
              bufferedBarColor: hasError ? Colors.transparent : Colors.white.withAlpha(64),
              progressBarColor: hasError ? Colors.transparent : Colors.white,
              thumbColor: hasError ? Colors.transparent : Colors.white,
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
          _durationText(playerData),
          style: TextStyle(
            color: Colors.white,
            fontFeatures: [
              FontFeature.tabularFigures()
            ],
          ),
        )
      ],
    );
  }
}
