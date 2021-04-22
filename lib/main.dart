import 'package:flutter/material.dart';

import 'view/home_view.dart';

void main() {
  runApp(GifzzerApp());
}

class GifzzerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeView());
  }
}
