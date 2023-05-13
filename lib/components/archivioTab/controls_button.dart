import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

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
          return Icon(Icons.error_outline, color: Colors.white);
        }

        if (state == null || state == ProcessingState.buffering || state == ProcessingState.loading) {
          return Padding(
            padding: const EdgeInsets.all(5),
            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
          );
        }

        return IconButton(
          iconSize: _size,
          splashRadius: _size * .75,
          padding: EdgeInsets.zero,
          color: Colors.white,
          icon: Icon(
            state == ProcessingState.completed
                ? Icons.replay
                : playing
                    ? Icons.pause
                    : Icons.play_arrow,
          ),
          tooltip: state == ProcessingState.completed
              ? "Riascolta"
              : playing
                  ? "Pausa"
                  : "Riproduci",
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
