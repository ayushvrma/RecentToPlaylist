/*
Get Recently Played Tracks:
curl --request GET \
  --url https://api.spotify.com/v1/me/player/recently-played \
  --header 'Authorization: ' \
  --header 'Content-Type: application/json'


Get Playlist:
curl --request GET \
  --url https://api.spotify.com/v1/playlists/playlist_id \
  --header 'Authorization: ' \
  --header 'Content-Type: application/json'

Create Playlist:
curl --request POST \
  --url https://api.spotify.com/v1/users/user_id/playlists \
  --header 'Authorization: ' \
  --header 'Content-Type: application/json' \
  --data '{
  "name": "New Playlist",
  "description": "New playlist description",
  "public": false
}'


Add items:
curl --request POST \
  --url https://api.spotify.com/v1/playlists/playlist_id/tracks \
  --header 'Authorization: ' \
  --header 'Content-Type: application/json' \
  --data '{
  "uris": [
    "string"
  ],
  "position": 0
}'

uris: A comma-separated list of Spotify URIs 


Add Custom Playlist Cover Image

curl --request PUT \
  --url https://api.spotify.com/v1/playlists/playlist_id/images \
  --header 'Authorization: ' \
  --header 'Content-Type: application/json'

*/


/*
scopes: 
playlist-read-private
playlist-read-collaborative
playlist-modify-private
playlist-modify-public
user-read-recently-played
*/