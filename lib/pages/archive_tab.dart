import 'package:flutter/material.dart';
import 'package:flutter_series/flutter_series.dart';
import 'package:just_audio/just_audio.dart';
import 'package:radioanaunia/components/archiveTab/audio_player_tile.dart';
import 'package:radioanaunia/main.dart';

class ArchiveDataPlayer {
  final String url;
  final AudioPlayer audioPlayer = AudioPlayer();

  ArchiveDataPlayer(this.url);
}

class ArchiveTab extends StatelessWidget {
  const ArchiveTab({super.key});

  static final _sections = <({String Function(BuildContext context) title, List<ArchiveDataPlayer> audioPlayers})>[
    (
      title: (context) => lang(context).archiveNews,
      audioPlayers: [
        ArchiveDataPlayer("https://radioanaunia.it/archivio/notizie_appuntamenti.mp3"),
      ],
    ),
    (
      title: (_) => "Doi ciacole dre al Nos",
      audioPlayers: [
        ArchiveDataPlayer("https://radioanaunia.it/archivio/doiciacole_1.mp3"),
        ArchiveDataPlayer("https://radioanaunia.it/archivio/doiciacole_2.mp3"),
        ArchiveDataPlayer("https://radioanaunia.it/archivio/doiciacole_3.mp3"),
        ArchiveDataPlayer("https://radioanaunia.it/archivio/doiciacole_4.mp3"),
        ArchiveDataPlayer("https://radioanaunia.it/archivio/doiciacole_5.mp3"),
      ],
    ),
    (
      title: (_) => "Tempo Reale",
      audioPlayers: [
        ArchiveDataPlayer("https://radioanaunia.it/archivio/tempo_reale.mp3"),
      ],
    ),
    (
      title: (_) => "Il caffè del venerdì",
      audioPlayers: [
        ArchiveDataPlayer("https://radioanaunia.it/archivio/caffe_venerdi.mp3"),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: _sections.map((section) {
        return PadColumn(
          padding: const EdgeInsets.all(16),
          spacing: 16,
          children: [
            Text(section.title(context), style: const TextStyle(fontSize: 18)),
            ...section.audioPlayers.map(AudioPlayerTile.new),
          ],
        );
      }).toList(),
    );
  }
}
