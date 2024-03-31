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

  @override
  Widget build(BuildContext context) {
    final playing = playerState?.playing ?? false;
    final loading = [AudioProcessingState.buffering, AudioProcessingState.loading, null].contains(playerState?.processingState);

    play() async {
      try {
        await audioHandler.setUrl(radioURL);
        audioHandler.play();
      } catch (_) {}
    }

    return IconButton(
      iconSize: 56,
      icon: loading //
          ? const Padding(padding: EdgeInsets.all(10), child: CircularProgressIndicator())
          : Icon(playing ? Icons.stop : Icons.play_arrow),
      tooltip: loading //
          ? null
          : (playing ? lang(context).stop : lang(context).play),
      onPressed: loading //
          ? null
          : (playing ? audioHandler.stop : play),
    );
  }
}
