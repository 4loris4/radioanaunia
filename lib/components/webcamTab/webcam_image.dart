import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class WebcamData {
  final String url;
  final String title;

  const WebcamData(this.url, this.title);
}

class WebcamImage extends StatelessWidget {
  final WebcamData data;

  const WebcamImage(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment(0, 1),
      fit: StackFit.expand,
      children: [
        Container(
          color: Colors.white.withOpacity(.1),
          child: Center(child: const CircularProgressIndicator(color: Colors.white)),
        ),
        FadeInImage.memoryNetwork(
          fadeInDuration: const Duration(milliseconds: 200),
          placeholder: kTransparentImage,
          image: "${data.url}?t=${DateTime.now().millisecondsSinceEpoch}",
          fit: BoxFit.contain,
        ),
        Positioned(
          bottom: 8,
          child: Container(
            padding: EdgeInsets.all(4),
            color: Colors.black.withOpacity(.5),
            child: Text(
              data.title,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
