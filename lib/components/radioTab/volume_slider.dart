import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_series/flutter_series.dart';
import 'package:volume_controller/volume_controller.dart';

class VolumeSlider extends StatefulWidget {
  const VolumeSlider({super.key});

  @override
  State<VolumeSlider> createState() => _VolumeSliderState();
}

class _VolumeSliderState extends State<VolumeSlider> {
  final _volumeController = VolumeController();
  final _volumeStreamController = StreamController<double>();

  @override
  void initState() {
    super.initState();
    _volumeController.showSystemUI = false;
    _volumeController.listener(_volumeStreamController.add);
  }

  @override
  void dispose() {
    super.dispose();
    _volumeController.removeListener();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: _volumeStreamController.stream,
      builder: (context, snapshot) {
        final volume = snapshot.data ?? 0;
        return PadRow(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 8,
          children: [
            const Icon(Icons.volume_down),
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  trackHeight: 4,
                  activeTrackColor: Theme.of(context).colorScheme.onSurface,
                  inactiveTrackColor: Theme.of(context).colorScheme.onSurface.withOpacity(.15),
                  activeTickMarkColor: Colors.transparent,
                  inactiveTickMarkColor: Colors.transparent,
                ),
                child: Slider(
                  value: volume,
                  divisions: 31,
                  onChanged: _volumeController.setVolume,
                ),
              ),
            ),
            const Icon(Icons.volume_up),
          ],
        );
      },
    );
  }
}
