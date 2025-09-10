import 'package:chem_earth_app/utils/import_export.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;


class SubtopicService {
  static Future<List<Subtopic>> loadSubtopics() async {
    final String response = await rootBundle.loadString('assets/database/subtopics.json');
    final data = json.decode(response) as List;
    return data.map((json) => Subtopic.fromJson(json)).toList();
  }
}
