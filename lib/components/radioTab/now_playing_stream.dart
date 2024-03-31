import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;
import 'package:palette_generator/palette_generator.dart';
import 'package:radioanaunia/utils_functions.dart';

class AudioDetails {
  final String title;
  final String? author;
  final String? cover;
  final Color? color;

  const AudioDetails({required this.title, required this.author, required this.cover, required this.color});
}

class NowPlayingStream {
  final _streamController = StreamController<AudioDetails>.broadcast();
  late final Timer _updateTimer;

  Stream<AudioDetails> get stream => _streamController.stream;

  NowPlayingStream() {
    _fetchData();
    _updateTimer = Timer.periodic(const Duration(seconds: 10), (_) => _fetchData());
  }

  Future<String?> _fetchCoverImage(String query) async {
    try {
      final response = await http.get(
        Uri.parse("https://itunes.apple.com/search?media=music&country=it&term=${Uri.encodeComponent(query)}"),
        headers: {"Accept": "application/json"},
      );
      return (jsonDecode(response.body)["results"][0]["artworkUrl100"] as String).replaceAll("100x100bb.jpg", "1000x1000bb.jpg");
    } catch (_) {
      return null;
    }
  }

  Future<String?> _fetchPlaying() async {
    try {
      final response = await http.get(
        Uri.parse("https://s6.mediastreaming.it/9134/html5/onairtxt.php"),
        headers: {"Accept": "application/json"},
      );

      final responseText = HtmlUnescape().convert(response.body).substring(response.body.indexOf("=") + 1).trim();
      if (responseText.isNotEmpty) return responseText;
    } catch (_) {}
    return null;
  }

  void _fetchData() async {
    final playingText = await _fetchPlaying();
    if (playingText == null) return;

    final splitText = playingText.split("-").map((str) => str.trim().toCapitalizedWords()).where((str) => str.length > 2).toList();
    final title = splitText.length > 1 ? splitText[1] : playingText.toCapitalizedWords();
    final coverUrl = await _fetchCoverImage(playingText.toCapitalizedWords());
    final coverColor = coverUrl == null ? null : (await PaletteGenerator.fromImageProvider(NetworkImage(coverUrl))).dominantColor?.color;

    _streamController.add(AudioDetails(
      title: title,
      author: splitText.length > 1 ? splitText[0] : null,
      cover: coverUrl,
      color: coverColor,
    ));
  }

  void dispose() {
    _updateTimer.cancel();
  }
}
