import 'package:flutter/material.dart';

class ShowRecents extends StatefulWidget {
  static const routeName = '/showRecents';
  const ShowRecents({Key? key}) : super(key: key);

  @override
  State<ShowRecents> createState() => _ShowRecentsState();
}

class _ShowRecentsState extends State<ShowRecents> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(),
      body: Container(child: Text(args.toString())),
    );
  }
}
