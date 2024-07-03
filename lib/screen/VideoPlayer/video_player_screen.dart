import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../core/app_export.dart';
import '../../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';

class VideoPlay extends StatefulWidget {
  final String link;

  const VideoPlay({required this.link, super.key});

  @override
  State<VideoPlay> createState() => _VideoPlayState();
}

class _VideoPlayState extends State<VideoPlay> {
  late VideoPlayerController _controller;
  bool _isLoading = true;
  double _progressValue = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.link)
      ..initialize().then((_) {
        setState(() {
          _isLoading = false;
        });
      });

    _controller.addListener(() {
      setState(() {
        _progressValue = _controller.value.position.inSeconds.toDouble();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          Center(
            child: _isLoading
                ? const CircularProgressIndicator() // Show loading indicator
                : _controller.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      )
                    : Container(),
          ),
          // if (_controller.value.isBuffering) // Show buffering indicator
          //   Center(
          //     child: CircularProgressIndicator(),
          //   ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: VideoProgressIndicator(
                _controller,
                allowScrubbing: true,
                colors: VideoProgressColors(
                  playedColor: theme.colorScheme.primary,
                  bufferedColor: Colors.grey,
                  backgroundColor: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.colorScheme.primary,
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          color: appTheme.white,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.back,
        onTap: () {
          Navigator.of(context).pop();
        },
        margin: EdgeInsets.only(
          left: 21.h,
          top: 14.v,
          bottom: 14.v,
        ),
      ),
      centerTitle: true,
      title: AppbarTitle(
        text: "",
      ),
    );
  }
}
