import 'package:logging/logging.dart';
import 'package:shelf/shelf.dart';
import 'package:spotify_api_repo/application/service/autenticacao.service.dart';
import 'package:spotify_api_repo/infrastructure/service/log.service.dart';

class AutenticacaoUseCase {
  LogService log = LogService(origem: "AutenticacaoUseCase");

  final AutenticacaoService _service;

  AutenticacaoUseCase(this._service);

  Future<Response> efetuarLogin(Request request) async {
    try {
      log.exibirInfo("Iniciando o login com a API do Spotify");
      Response response = await _service.efetuarLogin(request);
      log.exibirSucesso("Sucesso ao efetuar login com a API do Spotify");
      return response;
    } catch (erro) {
      log.exibirErro("Erro ao efetuar login com a API do Spotify", erro);
      rethrow;
    }
  }

  Future<Response> salvarToken(Request request) async {
    try {
      log.exibirInfo("Iniciando o salvamento do token de acesso do Spotify");
      Response response = await _service.salvarToken(request);
      log.exibirSucesso("Sucesso no salvamento do token de acesso do Spotify");
      return response;
    } catch (erro) {
      log.exibirErro("Erro no salvamento do token de acesso do Spotify", erro);
      rethrow;
    }
  }
}
