import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerView extends StatefulWidget {
  final File videoFile;

  const VideoPlayerView({Key key, this.videoFile}) : super(key: key);
  @override
  _VideoPlayerViewState createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  VideoPlayerController _controller;
  Future<void> _initializedVideoPlayerFuture;
  IconData _videoControllButton;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.videoFile);
    _initializedVideoPlayerFuture =_controller.initialize();
    _controller.addListener(_videoControllerListener);
    _videoControllButton = Icons.play_arrow;
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        builder:(contexto, snap){
          if(snap.connectionState == ConnectionState.done) {
            return Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(aspectRatio: _controller.value.aspectRatio,
                child:VideoPlayer(_controller),),
                IconButton(icon: Icon(_videoControllButton),
                    iconSize: 50,
                    color: Colors.red,
                    onPressed: (){
                      if(_controller.value.isPlaying){
                        _controller.pause();
                      }else{
                        _controller.play();
                      }
                    })
              ],
            );
          }else
          return Center(child: CircularProgressIndicator());
        });
  }

  void _videoControllerListener() {
    setState(() {
      if(_controller.value.isPlaying){
        _videoControllButton = Icons.pause;
      }else{
        if(_controller.value.position == _controller.value.duration){
          _controller.seekTo(Duration(seconds: 0));
          _controller.pause();
        }

        _videoControllButton = Icons.play_arrow;
      }
    });
  }
}
