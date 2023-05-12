import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_series/flutter_series.dart';
import 'package:just_audio/just_audio.dart';
import 'package:radioanaunia/components/archivioTab/controls_button.dart';
import 'package:radioanaunia/components/archivioTab/progress_bar.dart';
import 'package:radioanaunia/pages/archivio_tab.dart';
import 'package:rxdart/rxdart.dart';

class PlayerData {
  final PlayerState playerState;
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
  const PlayerData(this.playerState, this.position, this.bufferedPosition, this.duration);
}

class AudioPlayerTile extends StatelessWidget {
  final ArchivioDataPlayer audio;

  AudioPlayerTile(this.audio, {Key? key}) : super(key: key) {
    if (audioPlayer.playerState.processingState == ProcessingState.idle) {
      audioPlayer.setUrl(audio.url).ignore();
    }
  }

  AudioPlayer get audioPlayer => audio.audioPlayer;

  final _dragStreamController = StreamController<Duration?>();
  late final Stream<PlayerData> _positionDataStream = Rx.combineLatest5<PlayerState, Duration, Duration, Duration?, Duration?, PlayerData>(
    audioPlayer.playerStateStream,
    audioPlayer.positionStream,
    audioPlayer.bufferedPositionStream,
    audioPlayer.durationStream,
    _dragStreamController.stream.startWith(null),
    (playerState, position, bufferedPosition, duration, dragPosition) => PlayerData(
      playerState,
      dragPosition ?? position,
      bufferedPosition,
      duration ?? Duration.zero,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerData>(
      stream: _positionDataStream,
      builder: (context, snapshot) {
        return PadRow(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 16,
          children: [
            ControlsButton(
              audioPlayer: audioPlayer,
              playerState: snapshot.data?.playerState,
            ),
            Expanded(
              child: ProgressBar(
                audioPlayer: audioPlayer,
                playerData: snapshot.data,
                spacing: 16,
                onDragUpdate: (details) => _dragStreamController.add(details.timeStamp),
                onDragEnd: () => _dragStreamController.add(null),
              ),
            ),
          ],
        );
      },
    );
  }
}
