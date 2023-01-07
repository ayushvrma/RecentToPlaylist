import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:recent_to_playlist/utils/playlist.dart';
import 'package:http/http.dart' as http;

class ShowPlaylist extends StatefulWidget {
  final List<String> uris;
  final String token;
  const ShowPlaylist({Key? key, required this.uris, required this.token})
      : super(key: key);

  @override
  State<ShowPlaylist> createState() => _ShowPlaylistState();
}

class _ShowPlaylistState extends State<ShowPlaylist> {
  Future<List<Playlist>> getRecents() async {
    final token = widget.token;
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    String url = "https://api.spotify.com/v1/me/playlists";
    final response = await http.get(Uri.parse(url), headers: requestHeaders);
    var responseData = json.decode(response.body);
    // print(responseData);

    //Creating a list to store input data;
    List<Playlist> playlists = [];
    for (var item in responseData['items']) {
      Playlist track = Playlist(
          id: item['id'],
          name: item['name'],
          imgUrl: item['images'][0]['url'],
          desc: item['description']);
      //Adding user to the list.
      playlists.add(track);
      print(track.name);
    }
    return playlists;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
        child: FutureBuilder(
          future: getRecents(),
          builder: (BuildContext ctx, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (ctx, index) => ListTile(
                  leading: Image.network(snapshot.data[index].imgUrl),
                  title: Text(snapshot.data[index].name),
                  subtitle: Text(snapshot.data[index].desc),
                  contentPadding: const EdgeInsets.only(bottom: 20.0),
                ),
              );
            }
          },
        ),
      )),
    );
  }
}
