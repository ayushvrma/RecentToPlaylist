// ignore_for_file: prefer_const_constructors

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
  final List<String> list = <String>['Private', 'Public'];
  final _playlistName = TextEditingController();
  final _description = TextEditingController();
  Future<List<Playlist>> getRecents() async {
    final token = widget.token;
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    String url = "https://api.spotify.com/v1/me/playlists?limit=50";
    final response = await http.get(Uri.parse(url), headers: requestHeaders);
    var responseData = json.decode(response.body);
    // print(responseData);

    //Creating a list to store input data;
    List<Playlist> playlists = [];
    for (var item in responseData['items']) {
      Playlist playlist = Playlist(
          id: item['id'],
          name: item['name'],
          imgUrl: item['images'][0]['url'],
          desc: item['description']);
      //Adding user to the list.
      playlists.add(playlist);
      print(playlist.name);
    }
    return playlists;
  }

  @override
  Widget build(BuildContext context) {
    String dropdownValue = list.first;

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(actions: [
            TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              20.0,
                            ),
                          ),
                        ),
                        contentPadding: EdgeInsets.only(
                          top: 10.0,
                        ),
                        title: Text(
                          "New Playlist",
                          style: TextStyle(fontSize: 24.0),
                        ),
                        content: Container(
                          height: 400,
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Enter Playlist Name ",
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: _playlistName,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Enter Playlist Name here',
                                        labelText: 'Name'),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Enter Playlist Description ",
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: _description,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText:
                                            'Enter Playlist Description here',
                                        labelText: 'Description'),
                                  ),
                                ),
                                DropdownButton<String>(
                                  value: dropdownValue,
                                  icon: const Icon(Icons.arrow_downward),
                                  elevation: 16,
                                  underline: Container(
                                    height: 2,
                                  ),
                                  onChanged: (String? value) {
                                    // This is called when the user selects an item.
                                    setState(() {
                                      dropdownValue = value!;
                                    });
                                  },
                                  items: list.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 60,
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final token = widget.token;
                                      Map<String, String> requestHeaders = {
                                        'Accept': 'application/json',
                                        'Content-type': 'application/json',
                                        'Authorization': 'Bearer $token',
                                      };
                                      String url =
                                          'https://api.spotify.com/v1/me';
                                      final response = await http.get(
                                          Uri.parse(url),
                                          headers: requestHeaders);
                                      var responseData =
                                          json.decode(response.body);
                                      String id = responseData['id'];
                                      String _isPublic =
                                          (dropdownValue == 'Public')
                                              ? 'true'
                                              : 'false';
                                      String body = jsonEncode({
                                        "name": _playlistName.text,
                                        "description": _description.text,
                                        "public": _isPublic,
                                      });

                                      url =
                                          'https://api.spotify.com/v1/users/${id}/playlists';
                                      final res2 = await http.post(
                                          Uri.parse(url),
                                          body: body,
                                          headers: requestHeaders);

                                      setState(() {
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    child: Text(
                                      "Create",
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Note'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'lol',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              },
              child: Text('Create New'),
            )
          ]),
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
