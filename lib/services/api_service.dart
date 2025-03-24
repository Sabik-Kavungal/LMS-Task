import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lms/models/module.dart';
import 'package:lms/models/subject.dart' show Subject;
import 'package:lms/models/video.dart';

class ApiService {
  static const String _baseUrl = 'https://trogon.info/interview/php/api';

  Future<List<Subject>> fetchSubjects() async {
    final response = await http.get(Uri.parse('$_baseUrl/subjects.php'));
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((json) => Subject.fromJson(json))
          .toList();
    }
    throw Exception('Failed to load subjects');
  }

  Future<List<Module>> fetchModules(String subjectId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/modules.php?subject_id=$subjectId'),
    );
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((json) => Module.fromJson(json))
          .toList();
    }
    throw Exception('Failed to load modules');
  }

  Future<List<Video>> fetchVideos(String moduleId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/videos.php?module_id=$moduleId'),
    );
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((json) => Video.fromJson(json))
          .toList();
    }
    throw Exception('Failed to load videos');
  }
}
