import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recent_to_playlist/screens/selected_songs.dart';
import 'package:recent_to_playlist/screens/show_playlist.dart';
import 'package:recent_to_playlist/utils/track.dart';

class ShowRecents extends StatefulWidget {
  final String token;
  const ShowRecents({Key? key, required this.token}) : super(key: key);

  @override
  State<ShowRecents> createState() => _ShowRecentsState();
}

class _ShowRecentsState extends State<ShowRecents> {
  List<String> selectedSongs = [];
  List<bool> _isChecked = [];
  final myController = TextEditingController();

  @override
  void initState() {
    _isChecked = List<bool>.filled(10, false);
    super.initState();
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  Future<List<Track>> getRecents() async {
    final token = widget.token;
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    String url =
        "https://api.spotify.com/v1/me/player/recently-played?limit=10";
    final response = await http.get(Uri.parse(url), headers: requestHeaders);
    var responseData = json.decode(response.body);
    // print(responseData);

    //Creating a list to store input data;
    List<Track> tracks = [];
    for (var item in responseData['items']) {
      List<String> artists = [];
      for (var artist in item['track']['artists']) {
        artists.add(artist['name']);
      }

      List<String> img_urls = [];
      for (var url in item['track']['album']['images']) {
        img_urls.add(url['url']);
      }
      Track track = Track(
          id: item['track']['id'],
          name: item['track']['name'],
          album: item['track']['album']['name'],
          artist: artists,
          imgUrl: img_urls,
          uri: item['track']['uri']);
      //Adding user to the list.
      tracks.add(track);
      // print(track.imgUrl);
    }
    return tracks;
  }

  void addToPlaylist(String playlistLink, List<String> uris) async {
    final token = widget.token;
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    String url =
        'https://api.spotify.com/v1/playlists/3cEYpjA9oz9GiPac4AsH4n/tracks?uris=spotify%3Atrack%3A4iV5W9uYEdYUVa79Axb7Rh%2Cspotify%3Atrack%3A1301WleyT98MSxVHPZCA6M';
    final response = await http.get(Uri.parse(url), headers: requestHeaders);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
          title: TextButton(
              onPressed: () {
                final token = widget.token;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShowPlaylist(
                        token: token,
                        uris: selectedSongs,
                      ),
                    ));
              },
              child: const Text('Add to Playlist'))),
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
                  leading: Image.network(snapshot.data[index].imgUrl[0]),
                  title: Text(snapshot.data[index].name),
                  subtitle: Text(snapshot.data[index].artist.toString()),
                  trailing: Checkbox(
                    value: _isChecked[index],
                    onChanged: (value) {
                      setState(() {
                        print(value);
                        _isChecked[index] = value!;
                        // print(selectedSongs);
                        if (_isChecked[index]) {
                          if (!selectedSongs
                              .contains(snapshot.data[index].uri)) {
                            selectedSongs.add(snapshot.data[index].uri);
                          }
                        } else {
                          selectedSongs.remove(snapshot.data[index].uri);
                        }
                        // print(selectedSongs);
                      });
                    },
                  ),
                  contentPadding: const EdgeInsets.only(bottom: 20.0),
                ),
              );
            }
          },
        ),
      ),
    ));
    ;
  }
}
