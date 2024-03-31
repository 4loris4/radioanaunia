import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class WebcamImage extends StatelessWidget {
  final String url;
  final String description;

  const WebcamImage({
    required this.url,
    required this.description,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: const Alignment(0, 1),
      fit: StackFit.expand,
      children: [
        Container(
          color: Theme.of(context).colorScheme.primary.withOpacity(.1),
          child: const Center(child: CircularProgressIndicator()),
        ),
        FadeInImage.memoryNetwork(
          key: Key("$url?t=${DateTime.now().millisecondsSinceEpoch}"),
          fadeInDuration: const Duration(milliseconds: 200),
          placeholder: kTransparentImage,
          image: "$url?t=${DateTime.now().millisecondsSinceEpoch}",
          fit: BoxFit.contain,
        ),
        Positioned(
          bottom: 8,
          child: Container(
            padding: const EdgeInsets.all(4),
            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(.5),
            child: Text(description),
          ),
        ),
      ],
    );
  }
}
