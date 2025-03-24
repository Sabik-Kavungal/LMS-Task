import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/subject.dart';

class SubjectsVM with ChangeNotifier {
  SubjectsVM() {
    fetchSubjects();
  }
  final ApiService _apiService = ApiService();
  List<Subject> _subjects = [];
  bool _isLoading = false;

  List<Subject> get subjects => _subjects;
  bool get isLoading => _isLoading;

  Future<void> fetchSubjects() async {
    _isLoading = true;
    notifyListeners();
    try {
      _subjects = await _apiService.fetchSubjects();
    } catch (e) {
      _subjects = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
