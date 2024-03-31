import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final archiveProvider = FutureProvider<List<ArchiveItem>>((ref) => fetchArchiveItems());

class ArchiveItem {
  final String name;
  final List<String> urls;

  const ArchiveItem({
    required this.name,
    required this.urls,
  });

  static const nameKey = "name";
  static const filesKey = "files";
  static const filePathKey = "path";

  factory ArchiveItem.fromJson(Map<String, dynamic> json) {
    return ArchiveItem(
      name: () {
        return (json[nameKey] as String).replaceAllMapped(
          RegExp(r"[aeiou]'(?=\s|$)"), //cSpell:disable-line
          (match) => {"a": "à", "e": "è", "i": "ì", "o": "ò", "u": "ù"}[match[0]![0]]!,
        );
      }(),
      urls: List<Map<String, dynamic>>.from(json[filesKey]).map((e) => Uri.parse("https://radioanaunia.it/archivio/${e[filePathKey]}").toString()).toList(),
    );
  }
}

Future<List<ArchiveItem>> fetchArchiveItems() async {
  final response = await http.get(Uri.parse("https://www.radioanaunia.it/api/programs.php"));
  final json = jsonDecode(response.body);
  return List<Map<String, dynamic>>.from(json).map(ArchiveItem.fromJson).toList();
}
