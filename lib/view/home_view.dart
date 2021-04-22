import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'gif_list_view.dart';
import 'gif_maker_main_view.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex;
  List<Widget> views;
  List<String> generatedGifs;
  Directory gifDirectory;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
    generatedGifs = [];
    views = [];
    _loadRequiredData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Gifzzer")),
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
                backgroundColor: Colors.pink),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.gif_rounded,
                size: 40,
              ),
              label: "GIF",
            )
          ],
        ),
        body: views.isEmpty
            ? Center(
                child: Text("Procurando gifs"),
              )
            : views.elementAt(_selectedIndex));
  }

  void _onGifGenerated() async {
    List<String> _availableGifs = [];
    gifDirectory.list().listen((file) {
      File(file.path).length().then((value) {
        if (value > 0) {
          _availableGifs.add(file.path);
        }
      });
    }).onDone(() {
      generatedGifs = _availableGifs;
      setState(() {
        views.removeAt(1);
        views.insert(
          1,
          GifListView(generatedPaths: generatedGifs),
        );
      });
    });
  }

  void _loadRequiredData() {
    getApplicationDocumentsDirectory().then((directory) {
      gifDirectory = Directory(directory.path + '/gif');
      gifDirectory.exists().then((exists) {
        if (!exists) {
          gifDirectory.create();
        } else {
          List<String> availableGifs = [];
          gifDirectory.list().listen((file) {
            File(file.path).length().then((length) {
              if (length > 0) {
                availableGifs.add(file.path);
              }
            });
          }).onDone(() {
            setState(() {
              generatedGifs = availableGifs;

              views = [
                GifMakerMainView(
                    onGifGenerateCallback: _onGifGenerated,
                    directory: gifDirectory),
                GifListView(generatedPaths: generatedGifs),
              ];
            });
          });
        }
      });
    });
  }
}
