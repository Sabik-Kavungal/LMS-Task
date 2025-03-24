import 'package:flutter/material.dart';
import 'package:lms/models/video.dart';
import 'package:lms/screens/ModulesScreen.dart';
import 'package:lms/screens/VideoPlayerScreen.dart';
import 'package:lms/screens/VideosScreen.dart';
import 'package:lms/screens/subjectsScreen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case SubjectsScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SubjectsScreen(),
      );

    case ModulesScreen.routeName:
      var subjectId = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ModulesScreen(subjectId: subjectId),
      );

    case VideosScreen.routeName:
      var moduleId = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => VideosScreen(moduleId: moduleId),
      );

    case VideoPlayerScreen.routeName:
      var video = routeSettings.arguments as Video;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => VideoPlayerScreen(video: video),
      );

    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder:
            (_) => const Scaffold(
              body: Center(child: Text('Screen does not exist!')),
            ),
      );
  }
}
