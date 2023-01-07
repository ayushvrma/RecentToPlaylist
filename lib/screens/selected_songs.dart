import 'package:flutter/material.dart';

class SelectedSongs extends StatefulWidget {
  final List<String> uris;
  const SelectedSongs({Key? key, required this.uris}) : super(key: key);

  @override
  State<SelectedSongs> createState() => _SelectedSongsState();
}

class _SelectedSongsState extends State<SelectedSongs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(child: Text(widget.uris.toString())),
    );
  }
}
