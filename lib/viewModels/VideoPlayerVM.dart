import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lms/models/video.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VideoPlayerVM with ChangeNotifier {
  Video? _currentVideo;
  YoutubePlayerController? _youtubeController;
  WebViewController? _vimeoController;
  bool _isYouTube = false;
  bool _isPlaying = true;
  bool _isMiniPlayer = false;
  bool _showForwardIcon = false;
  bool _showRewindIcon = false;
  double _miniPlayerHeight = 250;
  Timer? _overlayTimer;
  AnimationController? animationController;
  bool _isControlsVisible = true;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  Video? get currentVideo => _currentVideo;
  YoutubePlayerController? get youtubeController => _youtubeController;
  WebViewController? get vimeoController => _vimeoController;
  bool get isYouTube => _isYouTube;
  bool get isPlaying => _isPlaying;
  bool get isMiniPlayer => _isMiniPlayer;
  bool get showForwardIcon => _showForwardIcon;
  bool get showRewindIcon => _showRewindIcon;
  double get miniPlayerHeight => _miniPlayerHeight;
  bool get isControlsVisible => _isControlsVisible;
  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;

  void initializePlayer(Video video, TickerProvider vsync) {
    _currentVideo = video; // Set the current video
    _isYouTube = video.videoType.toLowerCase() == 'youtube';
    if (_isYouTube) {
      _initializeYouTubePlayer(video);
    } else {
      _initializeVimeoPlayer(video);
    }

    // Initialize animation controller
    animationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _initializeYouTubePlayer(Video video) {
    String videoId = YoutubePlayer.convertUrlToId(video.videoUrl) ?? '';
    _youtubeController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
    )..addListener(() {
      _isPlaying = _youtubeController!.value.isPlaying;
      _currentPosition = _youtubeController!.value.position;
      _totalDuration = _youtubeController!.value.metaData.duration;
      notifyListeners();
    });
  }

  void _initializeVimeoPlayer(Video video) {
    String videoId = video.videoUrl.split('/').last;
    _vimeoController =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(
            Uri.parse(
              'https://player.vimeo.com/video/$videoId?autoplay=1&muted=0',
            ),
          );
  }

  void seekForward() {
    if (_isYouTube) {
      _youtubeController?.seekTo(
        _youtubeController!.value.position + const Duration(seconds: 10),
      );
      _showOverlayIcon(isForward: true);
    }
  }

  void seekBackward() {
    if (_isYouTube) {
      _youtubeController?.seekTo(
        _youtubeController!.value.position - const Duration(seconds: 10),
      );
      _showOverlayIcon(isForward: false);
    }
  }

  void _showOverlayIcon({required bool isForward}) {
    if (isForward) {
      _showForwardIcon = true;
    } else {
      _showRewindIcon = true;
    }
    notifyListeners();

    _overlayTimer = Timer(const Duration(milliseconds: 500), () {
      _showForwardIcon = false;
      _showRewindIcon = false;
      notifyListeners();
    });
  }

  void toggleMiniPlayer() {
    _isMiniPlayer = !_isMiniPlayer;
    _miniPlayerHeight = _isMiniPlayer ? 100 : 250;
    notifyListeners();
  }

  void togglePlayPause() {
    if (_isYouTube) {
      if (_youtubeController!.value.isPlaying) {
        _youtubeController!.pause();
      } else {
        _youtubeController!.play();
      }
      _isPlaying = !_isPlaying;
      notifyListeners();
    }
  }

  void toggleControlsVisibility() {
    _isControlsVisible = !_isControlsVisible;
    notifyListeners();
  }

  void seekTo(Duration position) {
    if (_isYouTube) {
      _youtubeController?.seekTo(position);
    }
  }

  void animateProgress(double progress) {
    if (animationController != null) {
      animationController!.animateTo(
        progress,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      notifyListeners();
    }
  }

  void setCurrentVideo(Video video) {
    _currentVideo = video;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _overlayTimer?.cancel();
    _youtubeController?.removeListener(() {});
    _youtubeController?.dispose();
    animationController?.dispose();
  }
}
