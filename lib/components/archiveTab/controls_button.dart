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

  @override
  Widget build(BuildContext context) {
    const size = 36.0;
    final state = playerState?.processingState;
    final playing = playerState?.playing ?? false;
    final loading = [ProcessingState.buffering, ProcessingState.loading, null].contains(playerState?.processingState);
    final completed = (state == ProcessingState.completed);

    return SizedBox(
      width: size,
      height: size,
      child: () {
        if (state == ProcessingState.idle) return const Icon(Icons.error_outline);
        if (loading) return const Padding(padding: EdgeInsets.all(10), child: CircularProgressIndicator(strokeWidth: 2));
        return IconButton(
          iconSize: size - 8,
          padding: EdgeInsets.zero,
          icon: Icon(completed ? Icons.replay : (playing ? Icons.pause : Icons.play_arrow)),
          tooltip: completed ? lang(context).replay : (playing ? lang(context).pause : lang(context).play),
          onPressed: completed //
              ? () => audioPlayer.seek(Duration.zero)
              : (playing ? audioPlayer.pause : audioPlayer.play),
        );
      }(),
    );
  }
}
