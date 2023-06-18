import 'package:url_launcher/url_launcher.dart';

void openUrl(String url) async {
  try {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } catch (_) {}
}

extension StringExtension on String {
  String toCapitalized() => isEmpty ? "" : "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  String toCapitalizedWords() => replaceAll("(", "( ").split(" ").map((str) => str.toCapitalized()).join(" ").replaceAll("( ", "(");
}

extension DurationExtension on Duration {
  String toShortString([bool forceHours = false]) {
    final minutes = inMinutes.remainder(Duration.minutesPerHour).toString().padLeft(2, "0");
    final seconds = inSeconds.remainder(Duration.secondsPerMinute).toString().padLeft(2, "0");
    return "${(inHours > 0 || forceHours) ? "$inHours:" : ""}$minutes:$seconds";
  }
}
