import 'package:just_audio/just_audio.dart';
import 'package:url_launcher/url_launcher.dart';

void openUrl(String url) async {
  try {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } catch (_) {}
}

String titleCase(String str) {
  String tmpString = str.toLowerCase();
  String match = " -.0123456789";
  List<String> substrings;

  for (int i = 0; i < match.length; i++) {
    substrings = tmpString.split(match[i]);
    for (int i = 0; i < substrings.length && substrings.length > 0; i++) {
      try {
        substrings[i] = substrings[i][0].toUpperCase() + substrings[i].substring(1);
      } catch (Exception) {}
    }
    tmpString = substrings.join(match[i]);
  }

  return tmpString;
}

extension StringExtension on String {
  String toCapitalized() => this.isEmpty ? "" : "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  String toCapitalizedWords() => this.split(" ").map((str) => str.toCapitalized()).join(" ");
}

extension AudioPlayerExtension on AudioPlayer {
  Future<void> playURL(String url) async {
    try {
      await this.setUrl(url);
      this.play();
    } catch (_) {}
  }
}

extension DurationExtension on Duration {
  String toShortString([bool forceHours = false]) {
    final minutes = this.inMinutes.remainder(Duration.minutesPerHour).toString().padLeft(2, "0");
    final seconds = this.inSeconds.remainder(Duration.secondsPerMinute).toString().padLeft(2, "0");
    return "${(this.inHours > 0 || forceHours) ? "${this.inHours}:" : ""}$minutes:$seconds";
  }
}
