import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:radioanaunia/main.dart';

class ControlsButton extends StatelessWidget {
  final AudioPlayer audioPlayer;
  final PlayerState? playerState;

  const ControlsButton({
    required this.audioPlayer,
    required this.playerState,
    super.key,
  });

  final double _size = 28;

  @override
  Widget build(BuildContext context) {
    final state = playerState?.processingState;
    final playing = playerState?.playing ?? false;

    return SizedBox(
      width: _size,
      height: _size,
      child: () {
        if (state == ProcessingState.idle) {
          return const Icon(Icons.error_outline);
        }

        if (state == null || state == ProcessingState.buffering || state == ProcessingState.loading) {
          return const Padding(padding: EdgeInsets.all(5), child: CircularProgressIndicator(strokeWidth: 2.5));
        }

        return IconButton(
          iconSize: _size,
          splashRadius: _size * .75,
          padding: EdgeInsets.zero,
          icon: Icon(
            state == ProcessingState.completed
                ? Icons.replay
                : playing
                    ? Icons.pause
                    : Icons.play_arrow,
          ),
          tooltip: state == ProcessingState.completed
              ? lang(context).replay
              : playing
                  ? lang(context).pause
                  : lang(context).play,
          onPressed: state == ProcessingState.completed
              ? () => audioPlayer.seek(Duration.zero)
              : playing
                  ? audioPlayer.pause
                  : audioPlayer.play,
        );
      }(),
    );
  }
}
