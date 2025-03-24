import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lms/screens/VideoPlayerScreen.dart';
import 'package:lms/viewModels/videosVM.dart';
import 'package:provider/provider.dart';

class VideosScreen extends StatefulWidget {
  static const String routeName = '/video-screen';
  final String moduleId;

  const VideosScreen({super.key, required this.moduleId});

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VideosVM>(
        context,
        listen: false,
      ).fetchVideos(widget.moduleId);
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videosProvider = Provider.of<VideosVM>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Videos",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body:
          videosProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : videosProvider.error != null
              ? Center(
                child: Text(
                  "Error: ${videosProvider.error}",
                  style: GoogleFonts.poppins(color: Colors.red, fontSize: 16),
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: videosProvider.videos.length,
                  itemBuilder: (context, index) {
                    final video = videosProvider.videos[index];
                    return FadeTransition(
                      opacity: _animationController,
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        elevation: 3,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              VideoPlayerScreen.routeName,
                              arguments: video,
                            );
                          },
                          child: Row(
                            children: [
                              // Video Thumbnail Placeholder
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  width: 95,
                                  height: 100,
                                  color: const Color.fromARGB(
                                    255,
                                    239,
                                    248,
                                    255,
                                  ),
                                  child: const Icon(
                                    Icons.play_circle_fill,
                                    size: 40,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Video Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      video.title,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      video.description,
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),

                              // Play Button Icon
                              const Icon(
                                Icons.chevron_right,
                                color: Colors.blue,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
    );
  }
}
