import 'package:shelf/shelf.dart';
import 'package:spotify_api_repo/domain/faixa.dart';
import 'package:spotify_api_repo/domain/usuario.dart';

abstract class UsuarioService {
  Future<Usuario> obterPerfil(Request request);

  Future<List<Faixa>> obterPrincipaisFaixas(Request request);
}
