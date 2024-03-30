import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_series/flutter_series.dart';
import 'package:image_fade/image_fade.dart';
import 'package:radioanaunia/components/radioTab/live_controls_button.dart';
import 'package:radioanaunia/components/radioTab/now_playing_stream.dart';
import 'package:radioanaunia/components/radioTab/scroll_text.dart';
import 'package:radioanaunia/components/radioTab/volume_slider.dart';
import 'package:radioanaunia/main.dart';
import 'package:radioanaunia/utils_functions.dart';

const radioURL = "https://s6.mediastreaming.it/m/9134?ext=.mp3";

class RadioTab extends StatefulWidget {
  const RadioTab({super.key});

  @override
  State<RadioTab> createState() => _RadioTabState();
}

class _RadioTabState extends State<RadioTab> {
  final _nowPlaying = NowPlayingStream();

  @override
  void dispose() {
    super.dispose();
    _nowPlaying.dispose();
  }

  double _getCoverSize(bool playing) {
    final minSize = min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    return minSize * (playing ? .7 : .5);
  }

  Widget _buildCover(AudioDetails? audioDetails, bool playing) {
    return Expanded(
      flex: 1,
      child: AnimatedContainer(
        duration: playing ? const Duration(milliseconds: 1500) : const Duration(milliseconds: 750),
        curve: playing ? Curves.elasticOut : Curves.ease,
        color: (audioDetails?.color ?? Colors.grey.shade400).withOpacity(playing ? 1 : .5),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: AnimatedContainer(
              duration: playing ? const Duration(milliseconds: 1500) : const Duration(milliseconds: 750),
              curve: playing ? Curves.elasticOut : Curves.ease,
              width: _getCoverSize(playing),
              height: _getCoverSize(playing),
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
    );
  }

  Widget _buildControls(AudioDetails? audioDetails, PlaybackState? playerState) {
    return AnimatedSize(
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
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    if (audioDetails.author != null)
                      ScrollText(
                        audioDetails.author!,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(.6),
                          fontSize: 16,
                        ),
                      )
                  ],
                ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Center(child: LiveControlsButton(playerState: playerState)),
              ),
              const VolumeSlider(),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<AudioDetails>(
        stream: _nowPlaying.stream,
        builder: (context, snapshot) {
          final audioDetails = snapshot.data;

          if (audioDetails != null) {
            audioHandler.mediaItem.add(MediaItem(
              id: audioDetails.title,
              title: audioDetails.title,
              artist: audioDetails.author,
              artUri: tryOrNull(() => Uri.parse(audioDetails.cover!)),
            ));
          }

          return StreamBuilder<PlaybackState>(
            stream: audioHandler.playbackState,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildCover(audioDetails, playerState?.playing ?? false),
                  _buildControls(audioDetails, playerState),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
