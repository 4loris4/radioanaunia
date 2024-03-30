import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:radioanaunia/main.dart';
import 'package:radioanaunia/pages/radio_tab.dart';

class LiveControlsButton extends StatelessWidget {
  final PlaybackState? playerState;

  const LiveControlsButton({
    required this.playerState,
    super.key,
  });

  final double _size = 56;

  @override
  Widget build(BuildContext context) {
    final state = playerState?.processingState;
    final playing = playerState?.playing ?? false;

    return SizedBox(
      width: _size,
      height: _size,
      child: () {
        if (state == null || state == AudioProcessingState.buffering || state == AudioProcessingState.loading) {
          return const Padding(padding: EdgeInsets.all(14), child: CircularProgressIndicator(strokeWidth: 3));
        }

        return IconButton(
          iconSize: _size,
          padding: EdgeInsets.zero,
          icon: Icon(playing ? Icons.stop : Icons.play_arrow),
          tooltip: playing ? lang(context).stop : lang(context).play,
          onPressed: playing
              ? audioHandler.stop
              : () async {
                  try {
                    await audioHandler.setUrl(radioURL);
                    audioHandler.play();
                  } catch (_) {}
                },
        );
      }(),
    );
  }
}
