import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoApp extends StatefulWidget {
  final String urlVideo;

  const VideoApp({Key? key, required this.urlVideo}) : super(key: key);

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  bool _areControlsVisible = true;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.urlVideo)
      ..initialize().then((_) {
        setState(() {}); // برای به‌روز رسانی وضعیت UI پس از مقداردهی اولیه
      }).catchError((error) {
        print(error.toString()); // نمایش جزئیات خطا در کنسول
      });

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 16 / 9,
      autoPlay: true,
      looping: true,
      allowPlaybackSpeedChanging: true,
      autoInitialize: true,
      draggableProgressBar: true,
    );

    _videoPlayerController.addListener(() {
      if (_videoPlayerController.value.isPlaying) {
        // اگر ویدئو در حال پخش است، مخفی کردن دکمه‌ها
        _hideControlsAfterDelay();
      } else {
        // اگر ویدئو متوقف شده است، نمایش دکمه‌ها
        _showControls();
      }
    });
  }

  void _showControls() {
    setState(() {
      _areControlsVisible = true;
    });
  }

  void _hideControls() {
    setState(() {
      _areControlsVisible = false;
    });
  }

  void _hideControlsAfterDelay() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _videoPlayerController.value.isPlaying) {
        _hideControls();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            color: Colors.orange.shade500,
            icon: const Icon(CupertinoIcons.arrow_right_circle_fill),
            onPressed: () {
              dispose();
              Navigator.pop(context);
            },
          ),
          title: const Center(
              child:
              Text('نمایش ویدیو', style: TextStyle(color: Colors.orange))),
        ),
        body: GestureDetector(
          onTap: () {
            // هنگامی که روی ویدئو کلیک می‌شود، نمایش یا مخفی کردن دکمه‌ها
            setState(() {
              _areControlsVisible = !_areControlsVisible;
            });
            _hideControlsAfterDelay();
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Chewie(
                controller: _chewieController,
              ),
              Visibility(
                visible: _areControlsVisible,
                child: Positioned(
                  left: 10,
                  child: IconButton(
                    icon: const Icon(Icons.replay_10),
                    onPressed: () {
                      _rewindVideo();
                    },
                  ),
                ),
              ),
              Visibility(
                visible: _areControlsVisible,
                child: Positioned(
                  right: 10,
                  child: IconButton(
                    icon: const Icon(Icons.forward_10),
                    onPressed: () {
                      _forwardVideo();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _rewindVideo() {
    _videoPlayerController
        .seekTo(_videoPlayerController.value.position - const Duration(seconds: 10));
  }

  void _forwardVideo() {
    _videoPlayerController
        .seekTo(_videoPlayerController.value.position + const Duration(seconds: 10));
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }
}
