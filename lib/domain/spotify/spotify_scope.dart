enum SpotifyScope {
  PRIVATE('user-read-private'),
  EMAIL('user-read-email'),
  RECENT('user-read-recently-played'),
  TOP('user-top-read');

  final String scope;

  const SpotifyScope(this.scope);

  static String obterEscopos() {
    return "${PRIVATE.scope} ${EMAIL.scope} ${RECENT.scope} ${TOP.scope}";
  }
}
