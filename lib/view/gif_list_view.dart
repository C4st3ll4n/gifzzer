import 'dart:io';

import 'package:flutter/material.dart';

class GifListView extends StatelessWidget {
  final List<String> _generatedPaths;

  const GifListView({Key key, List<String> generatedPaths})
      : _generatedPaths = generatedPaths,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return _generatedPaths.isEmpty
        ? Center(
            child: Text("Nenhum GIF ainda 🙁"),
          )
        : GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: _generatedPaths.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 8,
                child: Image.file(
                  File(
                    _generatedPaths[index],
                  ),
                ),
              );
            },
          );
  }
}
