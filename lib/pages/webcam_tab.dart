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
    return LayoutBuilder(
      builder: (context, constraints) => RefreshIndicator(
        onRefresh: () async => setState(() {}),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: PadColumn(
                  spacing: 20,
                  children: webcams.map((webcam) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width * .8,
                      height: MediaQuery.of(context).size.width * .8 * 3 / 4,
                      child: WebcamImage(webcam),
                    );
                  }).toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
