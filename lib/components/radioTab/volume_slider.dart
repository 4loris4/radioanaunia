import 'package:flutter/material.dart';
import 'package:flutter_series/flutter_series.dart';
import 'package:volume_controller/volume_controller.dart';

class VolumeSlider extends StatefulWidget {
  const VolumeSlider({Key? key}) : super(key: key);

  @override
  State<VolumeSlider> createState() => _VolumeSliderState();
}

class _VolumeSliderState extends State<VolumeSlider> {
  final volumeController = VolumeController();
  double _volume = 0;

  @override
  void initState() {
    super.initState();
    volumeController.showSystemUI = false;
    volumeController.getVolume().then((volume) => _volume = volume);
    volumeController.listener((volume) => setState(() => _volume = volume));
  }

  @override
  void dispose() {
    super.dispose();
    volumeController.removeListener();
  }

  //TODO glow radius
  //TODO rewrite? smoother ranges when changing volume (hide system ui?)

  @override
  Widget build(BuildContext context) {
    return PadRow(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 8,
      children: [
        Icon(Icons.volume_down, color: Colors.white),
        Expanded(
          child: SliderTheme(
            data: SliderThemeData(
              overlayShape: SliderComponentShape.noOverlay,
              thumbColor: Colors.white,
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white.withOpacity(.1),
            ),
            child: Slider(
              value: _volume,
              onChanged: (volume) => volumeController.setVolume(volume),
            ),
          ),
        ),
        Icon(Icons.volume_up, color: Colors.white),
      ],
    );
  }
}
