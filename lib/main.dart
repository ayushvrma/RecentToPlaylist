import 'package:flutter/material.dart';
import 'package:recent_to_playlist/testpage.dart';
import 'utils/const.dart';
import 'package:get/get.dart';
import 'widgets/song_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: spotify_theme,
      home: TestPage(),
    );
  }
}
