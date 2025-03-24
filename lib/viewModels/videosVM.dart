import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/video.dart';

class VideosVM with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Video> _videos = [];
  bool _isLoading = false;
  String? _error;

  List<Video> get videos => _videos;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchVideos(String moduleId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _videos = await _apiService.fetchVideos(moduleId);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
