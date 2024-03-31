import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_series/flutter_series.dart';
import 'package:radioanaunia/api/archive.dart';
import 'package:radioanaunia/components/archiveTab/audio_player_tile.dart';
import 'package:radioanaunia/main.dart';
import 'package:radioanaunia/tabs.dart';

class ArchiveTab extends ConsumerWidget {
  static final widget = TabActionWidget(
    title: (context) => lang(context).tabArchive,
    icon: Icons.storage,
    widget: const ArchiveTab(),
  );

  const ArchiveTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final archive = ref.watch(archiveProvider);

    return archive.when(
      data: (sections) {
        return ListView(
          children: sections.map((section) {
            return PadColumn(
              padding: const EdgeInsets.all(16),
              spacing: 16,
              children: [
                Text(section.name, style: Theme.of(context).textTheme.bodyLarge),
                ...section.urls.map(AudioPlayerTile.new),
              ],
            );
          }).toList(),
        );
      },
      error: (e, _) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              lang(context).archiveError,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(lang(context).archiveErrorRetry, textAlign: TextAlign.center),
          ],
        );
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
