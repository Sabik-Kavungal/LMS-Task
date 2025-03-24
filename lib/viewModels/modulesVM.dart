import 'package:flutter/material.dart';
import 'package:lms/models/module.dart';
import 'package:lms/services/api_service.dart';

class ModulesVM with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Module> _modules = [];
  bool _isLoading = false;
  String? _error;
  List<Module> get modules => _modules;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchModules(String subjectId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _modules = await _apiService.fetchModules(subjectId);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
