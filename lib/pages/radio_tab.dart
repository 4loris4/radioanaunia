import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_series/flutter_series.dart';
import 'package:image_fade/image_fade.dart';
import 'package:just_audio/just_audio.dart';
import 'package:radioanaunia/components/radioTab/live_controls_button.dart';
import 'package:radioanaunia/components/radioTab/now_playing_stream.dart';
import 'package:radioanaunia/components/radioTab/scroll_text.dart';
import 'package:radioanaunia/components/radioTab/volume_slider.dart';

const radioURL = "https://s6.mediastreaming.it/m/9134?ext=.mp3";

class RadioTab extends StatefulWidget {
  const RadioTab({super.key});

  @override
  State<RadioTab> createState() => _RadioTabState();
}

class _RadioTabState extends State<RadioTab> {
  final _audioPlayer = AudioPlayer();
  final _nowPlaying = NowPlayingStream();

  @override
  void dispose() {
    super.dispose();
    _audioPlayer.dispose();
    _nowPlaying.dispose();
  }

  double _getCoverSize(BuildContext context, bool playing) {
    final minSize = min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    return minSize * (playing ? .7 : .5);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<AudioDetails>(
        stream: _nowPlaying.stream,
        builder: (context, snapshot) {
          final audioDetails = snapshot.data;
          return StreamBuilder<PlayerState>(
            stream: _audioPlayer.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final playing = playerState?.playing ?? false;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 1,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      color: audioDetails?.color ?? Colors.grey.shade400,
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: AnimatedContainer(
                            duration: playing ? const Duration(milliseconds: 1500) : const Duration(milliseconds: 750),
                            curve: playing ? Curves.elasticOut : Curves.ease,
                            width: _getCoverSize(context, playing),
                            height: _getCoverSize(context, playing),
                            child: ImageFade(
                              duration: const Duration(milliseconds: 500),
                              fit: BoxFit.cover,
                              image: audioDetails?.cover != null ? NetworkImage(audioDetails!.cover!) : null,
                              placeholder: Image.asset("assets/coverDefault.png", fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: [
                        if (audioDetails == null) const LinearProgressIndicator(backgroundColor: Colors.transparent),
                        PadColumn(
                          padding: const EdgeInsets.all(16),
                          children: [
                            if (audioDetails != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ScrollText(
                                    audioDetails.title,
                                    fontSize: 24,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  if (audioDetails.author != null)
                                    ScrollText(
                                      audioDetails.author!,
                                      fontSize: 16,
                                      style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(.6)),
                                    )
                                ],
                              ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Center(child: LiveControlsButton(audioPlayer: _audioPlayer, playerState: playerState)),
                            ),
                            const VolumeSlider(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
