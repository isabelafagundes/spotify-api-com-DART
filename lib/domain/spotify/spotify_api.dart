enum SpotifyApi {
  AUTORIZACAO('https://accounts.spotify.com/authorize'),
  TOKEN('https://accounts.spotify.com/api/token'),
  USUARIO('https://api.spotify.com/v1/me'),
  TOP_ARTISTAS('https://api.spotify.com/v1/me/top/artists'),
  TOP_FAIXAS('https://api.spotify.com/v1/me/top/tracks?time_range=short_term&limit=5');

  final String url;

  const SpotifyApi(this.url);
}
