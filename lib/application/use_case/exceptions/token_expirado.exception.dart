class TokenExpiradoException implements Exception {
  @override
  String toString() => 'O token de autenticação expirou!!';
}