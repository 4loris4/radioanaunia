import 'package:flutter/material.dart';
import 'package:flutter_series/flutter_series.dart';
import 'package:radioanaunia/components/archiveTab/audio_player_tile.dart';
import 'package:radioanaunia/main.dart';

class ArchiveTab extends StatelessWidget {
  const ArchiveTab({super.key});

  static final _sections = <({String Function(BuildContext context) title, List<String> urls})>[
    (
      title: (context) => lang(context).archiveNews,
      urls: [
        "https://radioanaunia.it/archivio/notizie_appuntamenti.mp3",
      ],
    ),
    (
      title: (_) => "Doi ciacole dre al Nos",
      urls: [
        "https://radioanaunia.it/archivio/doiciacole_1.mp3",
        "https://radioanaunia.it/archivio/doiciacole_2.mp3",
        "https://radioanaunia.it/archivio/doiciacole_3.mp3",
        "https://radioanaunia.it/archivio/doiciacole_4.mp3",
        "https://radioanaunia.it/archivio/doiciacole_5.mp3",
      ],
    ),
    (
      title: (_) => "Tempo Reale",
      urls: [
        "https://radioanaunia.it/archivio/tempo_reale.mp3",
      ],
    ),
    (
      title: (_) => "Il caffè del venerdì",
      urls: [
        "https://radioanaunia.it/archivio/caffe_venerdi.mp3",
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
            ...section.urls.map(AudioPlayerTile.new),
          ],
        );
      }).toList(),
    );
  }
}
