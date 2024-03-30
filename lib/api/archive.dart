import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final archiveProvider = FutureProvider<List<ArchiveItem>>((ref) => fetchArchiveItems());

class ArchiveItem {
  final String name;
  final String description;
  final List<String> urls;

  const ArchiveItem({
    required this.name,
    required this.description,
    required this.urls,
  });

  static const nameKey = "name";
  static const descriptionKey = "description";
  static const filesKey = "files";
  static const filePathKey = "path";

  factory ArchiveItem.fromJson(Map<String, dynamic> json) {
    return ArchiveItem(
      name: json[nameKey],
      description: json[descriptionKey],
      urls: List<Map<String, dynamic>>.from(json[filesKey]).map((e) => Uri.parse("https://radioanaunia.it/archivio/${e[filePathKey]}").toString()).toList(),
    );
  }
}

Future<List<ArchiveItem>> fetchArchiveItems() async {
  final response = await http.get(Uri.parse("https://www.radioanaunia.it/api/programs.php"));
  final json = jsonDecode(response.body);
  return List<Map<String, dynamic>>.from(json).map(ArchiveItem.fromJson).toList();
}
