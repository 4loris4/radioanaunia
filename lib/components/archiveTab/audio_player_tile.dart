import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_series/flutter_series.dart';
import 'package:just_audio/just_audio.dart';
import 'package:radioanaunia/components/archiveTab/controls_button.dart';
import 'package:radioanaunia/components/archiveTab/progress_bar.dart';
import 'package:rxdart/rxdart.dart';

class PlayerData {
  final PlayerState playerState;
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
  const PlayerData(this.playerState, this.position, this.bufferedPosition, this.duration);
}

class AudioPlayerTile extends StatefulWidget {
  final String url;

  const AudioPlayerTile(this.url, {super.key});

  @override
  State<AudioPlayerTile> createState() => _AudioPlayerTileState();
}

class _AudioPlayerTileState extends State<AudioPlayerTile> {
  final _dragStreamController = StreamController<Duration?>();
  final _audioPlayer = AudioPlayer();

  late final Stream<PlayerData> _positionDataStream = Rx.combineLatest5<PlayerState, Duration, Duration, Duration?, Duration?, PlayerData>(
    _audioPlayer.playerStateStream,
    _audioPlayer.positionStream,
    _audioPlayer.bufferedPositionStream,
    _audioPlayer.durationStream,
    _dragStreamController.stream.startWith(null),
    (playerState, position, bufferedPosition, duration, dragPosition) => PlayerData(
      playerState,
      dragPosition ?? position,
      bufferedPosition,
      duration ?? Duration.zero,
    ),
  );

  @override
  void initState() {
    super.initState();
    _audioPlayer.setUrl(widget.url).ignore();
  }

  @override
  void dispose() {
    super.dispose();
    _audioPlayer.dispose();
  }

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
              audioPlayer: _audioPlayer,
              playerState: snapshot.data?.playerState,
            ),
            Expanded(
              child: ProgressBar(
                audioPlayer: _audioPlayer,
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
