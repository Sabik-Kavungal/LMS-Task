import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lms/models/video.dart';
import 'package:lms/viewModels/VideoPlayerVM.dart';
import 'package:lms/viewModels/videosVM.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class VideoPlayerScreen extends StatefulWidget {
  static const String routeName = '/video-player--screen';

  final Video video;
  const VideoPlayerScreen({super.key, required this.video});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VideoPlayerVM()..initializePlayer(widget.video, this),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            widget.video.title,
            style: GoogleFonts.lato(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        backgroundColor: Colors.white,
        body: Consumer<VideoPlayerVM>(
          builder: (context, provider, child) {
            return Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: provider.miniPlayerHeight,
                  curve: Curves.easeInOut,
                  child: Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: GestureDetector(
                          onDoubleTapDown: (TapDownDetails details) {
                            final RenderBox box =
                                context.findRenderObject() as RenderBox;
                            final double dx =
                                box.globalToLocal(details.globalPosition).dx;
                            final double screenWidth =
                                MediaQuery.of(context).size.width;

                            if (dx < screenWidth / 2) {
                              provider.seekBackward();
                            } else {
                              provider.seekForward();
                            }
                          },
                          child:
                              provider.isYouTube
                                  ? YoutubePlayer(
                                    controller: provider.youtubeController!,
                                  )
                                  : WebViewWidget(
                                    controller: provider.vimeoController!,
                                  ),
                        ),
                      ),
                      if (provider.showRewindIcon)
                        Positioned(
                          left: 30,
                          top: 100,
                          child: Icon(
                                Icons.replay_10,
                                size: 50,
                                color: Colors.white,
                              )
                              .animate()
                              .fadeIn(duration: 300.ms)
                              .fadeOut(duration: 500.ms, delay: 200.ms),
                        ),
                      if (provider.showForwardIcon)
                        Positioned(
                          right: 30,
                          top: 100,
                          child: Icon(
                                Icons.forward_10,
                                size: 50,
                                color: Colors.white,
                              )
                              .animate()
                              .fadeIn(duration: 300.ms)
                              .fadeOut(duration: 500.ms, delay: 200.ms),
                        ),
                      // if (provider.isControlsVisible)
                      //   Positioned(
                      //     bottom: 0,
                      //     left: 0,
                      //     right: 0,
                      //     child: Container(
                      //       color: Colors.black.withOpacity(0.5),
                      //       padding: const EdgeInsets.all(8),
                      //       child: Row(
                      //         children: [
                      //           IconButton(
                      //             icon: Icon(
                      //               provider.isPlaying ? Icons.pause : Icons.play_arrow,
                      //               color: Colors.white,
                      //             ),
                      //             onPressed: provider.togglePlayPause,
                      //           ),
                      //           Expanded(
                      //             child: Slider(
                      //               value: provider.currentPosition.inSeconds.toDouble(),
                      //               min: 0,
                      //               max: provider.totalDuration.inSeconds.toDouble(),
                      //               onChanged: (value) {
                      //                 provider.seekTo(Duration(seconds: value.toInt()));
                      //               },
                      //             ),
                      //           ),
                      //           Text(
                      //             '${provider.currentPosition.inMinutes}:${provider.currentPosition.inSeconds.remainder(60).toString().padLeft(2, '0')} / ${provider.totalDuration.inMinutes}:${provider.totalDuration.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                      //             style: const TextStyle(color: Colors.white),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.video.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.video.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                Expanded(
                  child: Consumer<VideosVM>(
                    builder: (context, videosProvider, child) {
                      return videosProvider.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : videosProvider.error != null
                          ? Center(
                            child: Text(
                              'Error: ${videosProvider.error}',
                              style: GoogleFonts.poppins(),
                            ),
                          )
                          : ListView.builder(
                            itemCount: videosProvider.videos.length,
                            itemBuilder: (context, index) {
                              final relatedVideo = videosProvider.videos[index];
                              return RelatedVideoTile(video: relatedVideo);
                            },
                          );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class RelatedVideoTile extends StatelessWidget {
  final Video video;

  const RelatedVideoTile({required this.video});

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoPlayerVM>(
      builder: (context, videoPlayerVM, child) {
        final isSelected = videoPlayerVM.currentVideo?.id == video.id;

        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 100,
              height: 60,
              color: Colors.grey[200],
              child: const Icon(
                Icons.play_circle_fill,
                size: 40,
                color: Colors.black,
              ),
            ),
          ),
          title: Text(
            video.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color:
                  isSelected
                      ? Colors.blue
                      : Colors.black, // Highlight title if selected
            ),
          ),
          subtitle: Text(
            video.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.roboto(
              fontSize: 12,
              color:
                  isSelected
                      ? Colors.blue
                      : Colors.grey, // Highlight subtitle if selected
            ),
          ),
          onTap: () {
            // Update the current video and initialize the player
            videoPlayerVM.setCurrentVideo(video);

            // Navigate to the VideoPlayerScreen
            // Navigate to the VideoPlayerScreen and replace the current screen
Navigator.pushReplacementNamed(
  context,
  VideoPlayerScreen.routeName,
  arguments: video,
);

          },
          tileColor:
              isSelected
                  ? Colors.blue[50]
                  : null, // Highlight the tile if selected
        );
      },
    );
  }
}
