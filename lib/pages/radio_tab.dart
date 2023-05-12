import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_series/flutter_series.dart';
import 'package:http/http.dart' as http;
import 'package:image_fade/image_fade.dart';
import 'package:just_audio/just_audio.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:radioanaunia/components/radioTab/scroll_text.dart';
import 'package:radioanaunia/components/radioTab/volume_slider.dart';
import 'package:radioanaunia/utils_functions.dart';

class AudioData {
  final String title;
  final String? author;
  final String cover;
  final Color color;

  const AudioData({
    required this.title,
    required this.author,
    required this.cover,
    required this.color,
  });
}

class RadioTab extends StatefulWidget {
  static final audioPlayer = AudioPlayer();

  const RadioTab({Key? key}) : super(key: key);

  @override
  State<RadioTab> createState() => _RadioTabState();
}

class _RadioTabState extends State<RadioTab> {
  final _streamURL = "https://s6.mediastreaming.it/m/9134?ext=.mp3";
  final _defaultCoverUrl = "https://s6.mediastreaming.it/9134/html5/skin/default.png";
  final _defaultCoverColor = Colors.grey.shade400;
  Timer? _updateTimer;
  AudioData? _nowPlaying;
  bool _loading = false;

  double getCoverSize(BuildContext context) {
    final minSize = min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    return minSize * (RadioTab.audioPlayer.playing ? .7 : .5);
  }

  void _fetchPlaying() async {
    Future<String?> getCoverUrl(String query) async {
      try {
        final response = await http.get(
          Uri.parse("https://itunes.apple.com/search?media=music&country=us&term=${query.replaceAll(" ", "+")}"),
          headers: {
            "Accept": "application/json"
          },
        );
        return jsonDecode(response.body)["results"][0]["artworkUrl100"];
      } catch (_) {
        return null;
      }
    }

    String responseText;
    try {
      final response = await http.get(
        Uri.parse("https://s6.mediastreaming.it/9134/html5/onairtxt.php"),
        headers: {
          "Accept": "application/json"
        },
      );
      responseText = response.body.substring(response.body.indexOf("=") + 1).trim();
      if (responseText.isEmpty) throw "";
    } catch (_) {
      return;
    }

    final splitText = responseText.split("-").map((str) => str.trim().toCapitalizedWords()).where((str) => str.isNotEmpty).toList();
    final title = splitText.length > 1 ? splitText[1] : responseText.toCapitalizedWords();
    final coverUrl = await getCoverUrl(responseText.toCapitalizedWords()) ?? _defaultCoverUrl;
    final coverColor = (await PaletteGenerator.fromImageProvider(NetworkImage(coverUrl))).dominantColor?.color ?? _defaultCoverColor;

    if (mounted) {
      setState(
        () => _nowPlaying = AudioData(
          title: title,
          author: splitText.length > 1 ? splitText[0] : null,
          cover: coverUrl,
          color: coverColor,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchPlaying();
    _updateTimer = Timer.periodic(const Duration(seconds: 15), (_) => _fetchPlaying());
  }

  @override
  void dispose() {
    super.dispose();
    _updateTimer?.cancel();
  }

  //TODO rewrite using streams

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            color: _nowPlaying?.color ?? _defaultCoverColor,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: AnimatedContainer(
                  duration: RadioTab.audioPlayer.playing ? const Duration(milliseconds: 1500) : const Duration(milliseconds: 750),
                  curve: RadioTab.audioPlayer.playing ? Curves.elasticOut : Curves.ease,
                  width: getCoverSize(context),
                  height: getCoverSize(context),
                  color: Colors.white,
                  child: ImageFade(
                    duration: const Duration(milliseconds: 500),
                    image: _nowPlaying?.cover != null ? NetworkImage(_nowPlaying!.cover) : null,
                    fit: BoxFit.cover,
                    placeholder: Image.asset("assets/coverDefault.png", fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.bottomCenter,
          child: Column(
            children: [
              if (_nowPlaying == null) const LinearProgressIndicator(color: Colors.white, backgroundColor: Colors.black),
              PadColumn(
                spacing: 10,
                padding: EdgeInsets.all(20),
                children: [
                  if (_nowPlaying != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ScrollText(
                          _nowPlaying!.title,
                          fontSize: 24,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        if (_nowPlaying!.author != null)
                          ScrollText(
                            _nowPlaying!.author!,
                            fontSize: 16,
                            style: TextStyle(color: Colors.white.withOpacity(.6)),
                          )
                      ],
                    ),
                  Center(
                    child: _loading
                        ? Container(
                            width: 76,
                            height: 76,
                            padding: EdgeInsets.all(20),
                            child: CircularProgressIndicator(color: Colors.white),
                          )
                        : IconButton(
                            onPressed: () async {
                              if (RadioTab.audioPlayer.playing) {
                                RadioTab.audioPlayer.stop();
                              } else {
                                setState(() => _loading = true);
                                await RadioTab.audioPlayer.playURL(_streamURL);
                              }
                              if (mounted) {
                                setState(() => _loading = false);
                              }
                            },
                            icon: Icon(RadioTab.audioPlayer.playing ? Icons.stop : Icons.play_arrow),
                            color: Colors.white,
                            iconSize: 60,
                            splashRadius: 40,
                          ),
                  ),
                  VolumeSlider(),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
