import 'package:http/http.dart' as http;

class Track {
  final String name;
  final String id;
  final List<String> imgUrl;
  final String album;
  final List<String> artist;
  final String uri;
  Track(
      {required this.id,
      required this.name,
      required this.album,
      required this.artist,
      required this.imgUrl,
      required this.uri});
}
