import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'info.dart';
import 'dart:io' show HttpServer;

const html = """
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Grant Access to Flutter</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <style>
    html, body { margin: 0; padding: 0; }

    main {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      min-height: 100vh;
      font-family: -apple-system,BlinkMacSystemFont,Segoe UI,Helvetica,Arial,sans-serif,Apple Color Emoji,Segoe UI Emoji,Segoe UI Symbol;
    }

    #icon {
      font-size: 96pt;
    }

    #text {
      padding: 2em;
      max-width: 260px;
      text-align: center;
    }

    #button a {
      display: inline-block;
      padding: 6px 12px;
      color: white;
      border: 1px solid rgba(27,31,35,.2);
      border-radius: 3px;
      background-image: linear-gradient(-180deg, #34d058 0%, #22863a 90%);
      text-decoration: none;
      font-size: 14px;
      font-weight: 600;
    }

    #button a:active {
      background-color: #279f43;
      background-image: none;
    }
  </style>
</head>
<body>
  <main>
    <div id="icon">&#x1F3C7;</div>
    <div id="text">Press the button below to sign in using your Localtest.me account.</div>
    <div id="button"><a href="foobar://success?code=1337">Sign in</a></div>
  </main>
</body>
</html>
""";

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  void initState() {
    super.initState();
    startServer();
  }

  String _status = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      children: [
        Container(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: authenticate,
              child: Text('press here'),
            )),
        Text('Status is: $_status')
      ],
    ));
  }

  Future<void> startServer() async {
    final server = await HttpServer.bind('127.0.0.1', 43823);

    server.listen((req) async {
      setState(() {
        _status = 'Received request!';
      });

      req.response.headers.add('Content-Type', 'text/html');
      req.response.write(html);
      req.response.close();
    });
  }

  void authenticate() async {
    client_id = client_id;
    redirect_url = redirect_url;
    // Present the dialog to the user
    final result = await FlutterWebAuth.authenticate(
      url:
          "https://accounts.spotify.com/authorize?client_id=${client_id}&redirect_uri=${redirect_url}&scope=user-read-recently-played&response_type=token&state=123",
      callbackUrlScheme: "appname",
    );
// Extract token from resulting url
    final token = Uri.parse(result);
    String at = token.fragment;
    // at = "https://example.com/$at"; // Just for easy persing
    // final access_token = Uri.parse(at).queryParameters['access_token'];
    var t = at.substring(at.indexOf('=') + 1, at.indexOf('&'));
    // print('token');
    // print(accesstoken);
    print(at);
    print(t);
    setState(() {
      _status = 'Got token yayy';
    });
  }
}