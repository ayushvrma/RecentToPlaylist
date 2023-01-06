import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:recent_to_playlist/screens/show_recents.dart';
import '../info.dart';
import 'dart:io' show HttpServer;
import 'dart:math' as math;
import '../utils/const.dart';

class AuthPage extends StatefulWidget {
  static const routeName = '/authPage';
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage>
    with SingleTickerProviderStateMixin {
  late AnimationController animController;
  late Animation<double> animation;
  void initState() {
    super.initState();
    startServer();
    animController =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));

    final curvedAnimation = CurvedAnimation(
        parent: animController,
        curve: Curves.bounceIn,
        reverseCurve: Curves.easeOut);

    animation =
        Tween<double>(begin: 0, end: 2 * math.pi).animate(curvedAnimation)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              animController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              animController.forward();
            }
          });
    animController.forward();
  }

  String _status = '';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Scaffold(
          body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 80),
          Container(
            padding: EdgeInsets.only(left: 10),
            alignment: Alignment.topLeft,
            child: Text(
              'Authenticate Spotify',
              style: TextStyle(
                  color: spotify_green,
                  fontSize: 32,
                  fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(height: 40),
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(100, 0, 100, 0),
              child: RotatingTransition(
                  angle: animation,
                  child:
                      DiskImage()), // can also use pre built RotationTransition that takes turns instead of angle
            ),
          ),
          Expanded(
            child: Container(
                padding: EdgeInsets.all(100),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)), // <-- Radius
                  ),
                  onPressed: authenticate,
                  child: Text('Sign In'),
                )),
          ),
        ],
      )),
    );
  }

  Future<void> startServer() async {
    final server = await HttpServer.bind('127.0.0.1', 43823);

    server.listen((req) async {
      setState(() {
        _status = 'Received request!';
      });

      req.response.headers.add('Content-Type', 'text/html');
      req.response.close();
    });
  }

  void authenticate() async {
    client_id = client_id;
    redirect_url = redirect_url;
    // Present the dialog to the user
    final result = await FlutterWebAuth.authenticate(
      url:
          "https://accounts.spotify.com/authorize?client_id=${client_id}&redirect_uri=${redirect_url}&scope=user-read-recently-played&scope=playlist-modify-public&scope=playlist-modify-private&scope=&response_type=token&state=123",
      callbackUrlScheme: "appname",
    );

    final token = Uri.parse(result);
    String at = token.fragment;

    var t = at.substring(
        at.indexOf('=') + 1, at.indexOf('&')); // to just get the access token
    // print('token');
    // print(accesstoken);
    print(at);
    print(t);
    setState(() {
      _status = 'Got token yayy';
    });
    Navigator.pushNamed(context, ShowRecents.routeName, arguments: t);
  }

  @override
  void dispose() {
    animController.dispose(); // very important
    super.dispose();
  }
}

class RotatingTransition extends StatelessWidget {
  RotatingTransition({required this.angle, required this.child});

  late final Widget child; // container holding the image
  late final Animation<double> angle;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: angle,
      builder: (context, child) {
        return Transform.rotate(
            // seperated animation motion into a seperate Widget (rotating transition), which can be used with any Widget.
            angle: angle.value,
            child: child); // to optimise the perfomance of the app
      },
      child: child,
    );
  }
}

class DiskImage extends StatelessWidget {
  // now we can get this listenable from the super class
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10),
        child: Image.asset('assets/vinyl.png'));
  }
}
