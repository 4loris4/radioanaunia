import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_series/flutter_series.dart';
import 'package:just_audio/just_audio.dart';
import 'package:radioanaunia/pages/archivio_tab.dart';
import 'package:radioanaunia/utils_functions.dart';

class AudioPlayerTile extends StatefulWidget {
  final ArchivioDataPlayer audio;

  const AudioPlayerTile(this.audio, {Key? key}) : super(key: key);

  @override
  State<AudioPlayerTile> createState() => _AudioPlayerTileState();
}

class _AudioPlayerTileState extends State<AudioPlayerTile> {
  Duration? _duration;
  Duration? _playback;
  late Future<Duration?> ready;
  Timer? playbackUpdate;

  AudioPlayer get audioPlayer => widget.audio.audioPlayer;

  Widget _getIcon() {
    if (_duration == null) {
      return const SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2,
        ),
      );
    }

    return Icon(
      _duration!.isNegative
          ? Icons.error_outline
          : audioPlayer.playing
              ? Icons.pause
              : Icons.play_arrow,
      color: Colors.white,
    );
  }

  void setPlaybackUpdate([activate = true]) {
    if (playbackUpdate != null) {
      playbackUpdate!.cancel();
      playbackUpdate = null;
    }

    if (activate) {
      playbackUpdate = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;

        if (audioPlayer.playerState.processingState == ProcessingState.completed) {
          audioPlayer.pause();
          audioPlayer.seek(Duration.zero);
          setPlaybackUpdate(false);
          setState(() => _playback = Duration.zero);
        } else {
          setState(() => _playback = audioPlayer.position);
        }
      });
    } else {
      setState(() => _playback = audioPlayer.position);
    }
  }

  @override
  void initState() {
    super.initState();

    if (audioPlayer.duration == null) {
      ready = audioPlayer.setUrl(widget.audio.url);
      ready.then((value) {
        if (mounted) {
          setState(() {
            _playback = Duration.zero;
            _duration = value;
          });
        }
      });
      ready.catchError((_) {
        if (mounted) {
          setState(() => _duration = Duration(seconds: -1));
        }
      });
    } else {
      ready = Future.delayed(Duration.zero);
      if (mounted) {
        setState(() {
          _playback = audioPlayer.position;
          _duration = audioPlayer.duration;
        });
      }
      if (audioPlayer.playing) setPlaybackUpdate();
    }
  }

  @override
  void dispose() {
    super.dispose();
    playbackUpdate?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return PadRow(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 16,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: IconButton(
            onPressed: _duration == null || _duration!.isNegative == true
                ? null
                : () {
                    if (audioPlayer.playing) {
                      audioPlayer.pause();
                      setPlaybackUpdate(false);
                    } else {
                      audioPlayer.play();
                      setPlaybackUpdate();
                    }
                    setState(() {});
                  },
            splashRadius: 18,
            padding: EdgeInsets.zero,
            icon: _getIcon(),
          ),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderThemeData(
              overlayShape: SliderComponentShape.noOverlay,
              thumbColor: Colors.white,
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white.withOpacity(.1),
              disabledThumbColor: Colors.transparent,
              disabledInactiveTrackColor: Colors.white.withOpacity(.05),
              trackHeight: 2,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7),
            ),
            child: () {
              final maxValue = _duration == null || _duration!.isNegative ? 1.0 : _duration!.inSeconds.toDouble();
              return Slider(
                min: 0,
                max: maxValue,
                value: min(max(0, _playback?.inSeconds.toDouble() ?? 0), maxValue),
                onChanged: _duration == null || _duration!.isNegative
                    ? null
                    : (value) {
                        final valueDuration = Duration(seconds: value.toInt());
                        setState(() {
                          audioPlayer.seek(valueDuration);
                          _playback = valueDuration;
                        });
                      },
              );
            }(),
          ),
        ),
        Text(() {
          if (_duration?.isNegative == true) return "Non disponibile";
          if (_duration == null || _playback == null) return "--:--/--:--";
          return "${_playback!.toShortString()}/${_duration!.toShortString()}";
        }(), style: TextStyle(color: Colors.white))
      ],
    );
  }
}
