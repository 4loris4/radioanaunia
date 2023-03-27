import 'package:flutter/material.dart';
import 'package:flutter_series/flutter_series.dart';
import 'package:just_audio/just_audio.dart';
import 'package:radioanaunia/components/archivioTab/audio_player_tile.dart';

class ArchivioDataPlayer {
  final String? title;
  final String url;
  final AudioPlayer audioPlayer = AudioPlayer();

  ArchivioDataPlayer(this.title, this.url);
}

class ArchivioDataSection {
  final String title;
  final List<ArchivioDataPlayer> audioPlayers;

  const ArchivioDataSection(this.title, this.audioPlayers);
}

class ArchivioTab extends StatelessWidget {
  static final List<ArchivioDataSection> sections = [
    ArchivioDataSection("Notizie ed appuntamenti", [
      ArchivioDataPlayer(null, "https://radioanaunia.it/archivio/notizie_appuntamenti.mp3"),
    ]),
    ArchivioDataSection("Doi ciacole dre al Nos", [
      ArchivioDataPlayer("Prima parte", "https://radioanaunia.it/archivio/doiciacole_1.mp3"),
      ArchivioDataPlayer("Seconda parte", "https://radioanaunia.it/archivio/doiciacole_2.mp3"),
      ArchivioDataPlayer("Terza parte", "https://radioanaunia.it/archivio/doiciacole_3.mp3"),
      ArchivioDataPlayer("Quarta parte", "https://radioanaunia.it/archivio/doiciacole_4.mp3"),
      ArchivioDataPlayer("Quinta parte", "https://radioanaunia.it/archivio/doiciacole_5.mp3"),
    ]),
    ArchivioDataSection("Tempo Reale", [
      ArchivioDataPlayer(null, "https://radioanaunia.it/archivio/tempo_reale.mp3"),
    ]),
    ArchivioDataSection("Il caffè del venerdì", [
      ArchivioDataPlayer(null, "https://radioanaunia.it/archivio/caffe_venerdi.mp3"),
    ]),
  ];

  const ArchivioTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: PadColumn(
        spacing: 32,
        padding: EdgeInsets.all(16),
        children: sections
            .map(
              (section) => PadColumn(
                spacing: 8,
                children: [
                  Text(section.title, style: TextStyle(color: Colors.white, fontSize: 18)),
                  ...section.audioPlayers.map((audio) {
                    return PadColumn(
                      spacing: 8,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (audio.title != null) Text(audio.title!, style: TextStyle(color: Colors.white, fontSize: 13)),
                        AudioPlayerTile(audio)
                      ],
                    );
                  })
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
