import 'package:flutter/material.dart';
import 'package:recent_to_playlist/screens/auth_page.dart';
import 'package:recent_to_playlist/screens/show_recents.dart';
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
      routes: {
        AuthPage.routeName: (context) => const AuthPage(),
        ShowRecents.routeName: (context) => const ShowRecents(),
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Gotham',
        colorScheme: ColorScheme.dark().copyWith(primary: spotify_green),
      ),
      home: AuthPage(),
    );
  }
}
