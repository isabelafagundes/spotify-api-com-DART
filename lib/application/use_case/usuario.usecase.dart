import 'package:logging/logging.dart';
import 'package:shelf/shelf.dart';
import 'package:spotify_api_repo/application/service/usuario.service.dart';
import 'package:spotify_api_repo/application/use_case/exceptions/usuario_nao_encontrado.exception.dart';
import 'package:spotify_api_repo/domain/spotify/spotify_api.dart';
import 'package:spotify_api_repo/domain/faixa.dart';
import 'package:spotify_api_repo/domain/usuario.dart';
import 'package:spotify_api_repo/infrastructure/service/log.service.dart';
import 'package:spotify_api_repo/infrastructure/service/cookie_jar.service.dart';

class UsuarioUseCase {
  LogService log = LogService(origem: "UsuarioUseCase");

  final UsuarioService _service;

  UsuarioUseCase(this._service);

  Future<List<Faixa>> obterPrincipaisFaixas(Request request) async {
    try {
      log.exibirInfo("Obtendo as principais faixas do usuário");
      List<Faixa> faixas = await _service.obterPrincipaisFaixas(request);
      log.exibirSucesso("Sucesso ao obter as principais faixas do usuário");
      return faixas;
    } catch (erro) {
      log.exibirErro("Erro ao obter as principais faixas do usuário!!", erro);
      rethrow;
    }
  }

  Future<Usuario> obterPerfil(Request request) async {
    try {
      log.exibirInfo("Obtendo perfil do Spotify do usuário");
      Usuario usuario = await _service.obterPerfil(request);
      log.exibirSucesso("Sucesso ao obter o perfil do usuário");
      return usuario;
    } catch (erro) {
      log.exibirErro("Erro ao obter o perfil do usuário", erro);
      rethrow;
    }
  }
}
