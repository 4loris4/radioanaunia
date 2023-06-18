import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:radioanaunia/main.dart';
import 'package:radioanaunia/pages/radio_tab.dart';

class LiveControlsButton extends StatelessWidget {
  final AudioPlayer audioPlayer;
  final PlayerState? playerState;

  const LiveControlsButton({
    required this.audioPlayer,
    required this.playerState,
    super.key,
  });

  final double _size = 60;

  @override
  Widget build(BuildContext context) {
    final state = playerState?.processingState;
    final playing = playerState?.playing ?? false;

    return SizedBox(
      width: _size,
      height: _size,
      child: () {
        if (state == null || state == ProcessingState.buffering || state == ProcessingState.loading) {
          return const Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator());
        }

        return IconButton(
          iconSize: _size,
          splashRadius: _size * .75,
          padding: EdgeInsets.zero,
          icon: Icon(playing ? Icons.stop : Icons.play_arrow),
          tooltip: playing ? lang(context).stop : lang(context).play,
          onPressed: playing
              ? audioPlayer.stop
              : () async {
                  try {
                    await audioPlayer.setUrl(radioURL);
                    audioPlayer.play();
                  } catch (_) {}
                },
        );
      }(),
    );
  }
}
