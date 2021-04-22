import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:image_picker/image_picker.dart';

import 'gif_maker_child_view.dart';

class GifMakerMainView extends StatefulWidget {
  final String assetImagePath = 'assets/images/photo-placeholder-250.png';
  final Directory _directory;
  final Function _onGifGenerateCallback;

  const GifMakerMainView({Key key, directory, onGifGenerateCallback})
      : _directory = directory,
        _onGifGenerateCallback = onGifGenerateCallback,
        super(key: key);

  @override
  _GifMakerMainViewState createState() => _GifMakerMainViewState();
}

class _GifMakerMainViewState extends State<GifMakerMainView> {
  String _filePath;
  NatureOfFile _fileType;
  FlutterFFmpeg _fFmpeg;

  @override
  void initState() {
    super.initState();
    _filePath = widget.assetImagePath;
    _fileType = NatureOfFile.Asset;
    _fFmpeg = FlutterFFmpeg();
  }

  @override
  Widget build(BuildContext context) {
    return GifMakerChildView(
      filePath: _filePath,
      onConvertGifPressed: _onConvertGifPressed,
      onUploadVideoPressed: _onUploadVideoPressed,
      natureOfFile: _fileType,
    );
  }

  void _onConvertGifPressed() {
    if (_fileType == NatureOfFile.Gif || _fileType == NatureOfFile.Asset) {
      _showErrorSnackBar(message: "Upload video");
    } else {
      setState(() {
        _fileType = NatureOfFile.Identifying;
      });

      final gifOutput = widget._directory.path +
          "/" + DateTime
          .now()
          .millisecond
          .toString() + ".gif";

      final arguments = [
        '-i',
        _filePath,
        '-t',
        '2.5',
        '-ss',
        '2.0',
        '-f',
        'gif',
        gifOutput
      ];

      _fFmpeg.executeWithArguments(arguments).then((result) {
        setState(() {
          if (result == 0) {
            print('Gif created successfully');
            _filePath = gifOutput;
            _fileType = NatureOfFile.Gif;
            widget._onGifGenerateCallback();
          } else {
            print('GIF failed to create');
            _filePath = widget.assetImagePath;
            _fileType = NatureOfFile.Asset;
            _showErrorSnackBar(
                message: 'Filed to generate GIF. Try Again');
          }
        });
      });
    }
  }


void _onUploadVideoPressed() {
  setState(() {
    _fileType = NatureOfFile.Identifying;
  });

  ImagePicker().getVideo(source: ImageSource.gallery).then((video) {
    setState(() {
      if (video != null) {
        _filePath = video.path;
        _fileType = NatureOfFile.Video;
      } else {
        _filePath = widget.assetImagePath;
        _fileType = NatureOfFile.Asset;
        _showErrorSnackBar(message: "Falha ao enviar o vídeo");
      }
    });
  });
}

void _showErrorSnackBar({@required String message}) {
  Scaffold.of(context).hideCurrentSnackBar();
  Scaffold.of(context).showSnackBar(
    SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.error,
            color: Colors.red,
          ),
          SizedBox(
            width: 5,
          ),
          Text(message ?? "")
        ],
      ),
    ),
  );
}}

enum NatureOfFile { Video, Asset, Gif, Identifying }
