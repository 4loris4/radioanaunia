import 'package:flutter/material.dart';
import 'package:flutter_series/flutter_series.dart';
import 'package:radioanaunia/components/webcamTab/webcam_image.dart';

const webcams = [
  WebcamData(
    "https://radioanaunia.it/webcam/cam_1.jpg",
    "Webcam sulla Montagna di Cles",
  ),
  WebcamData(
    "https://radioanaunia.it/webcam/cam_2.jpg",
    "Webcam sulla Piazza Granda (Cles)",
  ),
];

class WebcamTab extends StatefulWidget {
  const WebcamTab({Key? key}) : super(key: key);

  @override
  State<WebcamTab> createState() => _WebcamTabState();
}

class _WebcamTabState extends State<WebcamTab> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => setState(() {}),
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            PadColumn(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: webcams.map((webcam) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width * .8,
                  height: MediaQuery.of(context).size.width * .8 * 3 / 4,
                  child: WebcamImage(webcam),
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}
