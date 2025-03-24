import 'package:lms/viewModels/VideoPlayerVM.dart';
import 'package:lms/viewModels/modulesVM.dart';
import 'package:lms/viewModels/subjectsVM.dart';
import 'package:lms/viewModels/videosVM.dart';
import 'package:provider/provider.dart';

class AppProviders {
  static List<ChangeNotifierProvider> getProviders() {
    return [
      ChangeNotifierProvider<VideosVM>(create: (_) => VideosVM()),
      ChangeNotifierProvider<SubjectsVM>(create: (_) => SubjectsVM()),
      ChangeNotifierProvider<ModulesVM>(create: (_) => ModulesVM()),
      ChangeNotifierProvider<VideoPlayerVM>(create: (_) => VideoPlayerVM()),
    ];
  }
}
