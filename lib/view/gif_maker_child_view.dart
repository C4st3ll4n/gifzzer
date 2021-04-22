import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gifzzer/view/video_player_view.dart';

import 'gif_maker_main_view.dart' show NatureOfFile;

class GifMakerChildView extends StatelessWidget {
  final Function onUploadVideoPressed;
  final Function onConvertGifPressed;
  final NatureOfFile natureOfFile;
  final String filePath;

  const GifMakerChildView(
      {Key key,
      this.onUploadVideoPressed,
      this.onConvertGifPressed,
      this.natureOfFile,
      this.filePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Align(
            alignment: Alignment.center,
            child: Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildFileView(),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Expanded(
                child: Align(
                    alignment: Alignment.center, child: _imageSelectButton()),
              ),
              Expanded(
                  child: Align(
                alignment: Alignment.center,
                child: _convertToGifButton(),
              ))
            ],
          ),
        ),
      ],
    );
  }

  Widget _convertToGifButton() {
    return SizedBox(
        width: 150,
        child: RaisedButton(
          onPressed: onConvertGifPressed,
          child: Text("Convert to GIF"),
        ));
  }

  Widget _imageSelectButton() {
    return SizedBox(
        width: 150,
        child: RaisedButton(
            onPressed: onUploadVideoPressed, child: Text("Upload video")));
  }

  Widget _buildFileView() {
    switch (natureOfFile){

      case NatureOfFile.Video:
        return VideoPlayerView(
          videoFile: File(filePath),
        );        break;
      case NatureOfFile.Asset:
        return Image.asset(filePath);
        break;
      case NatureOfFile.Gif:
        return Image.file(File(filePath));
        break;
      case NatureOfFile.Identifying:
        return CircularProgressIndicator();
        break;
    }
  }
}
