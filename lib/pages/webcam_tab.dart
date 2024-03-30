import 'package:flutter/material.dart';
import 'package:flutter_series/flutter_series.dart';
import 'package:radioanaunia/components/webcamTab/webcam_image.dart';
import 'package:radioanaunia/main.dart';

class WebcamTab extends StatefulWidget {
  const WebcamTab({super.key});

  @override
  State<WebcamTab> createState() => _WebcamTabState();
}

class _WebcamTabState extends State<WebcamTab> {
  static final _webcams = <({String url, String Function(BuildContext context) description})>[
    (
      url: "https://radioanaunia.it/webcam/cam_1.jpg",
      description: (context) => lang(context).webcam1Desc,
    ),
    (
      url: "https://radioanaunia.it/webcam/cam_2.jpg",
      description: (context) => lang(context).webcam2Desc,
    )
  ];

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
                  children: _webcams.map((webcam) {
                    final width = MediaQuery.of(context).size.width * .8;
                    return SizedBox(
                      width: width,
                      height: width * .75,
                      child: WebcamImage(url: webcam.url, description: webcam.description(context)),
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
