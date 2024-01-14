import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:logging/logging.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:spotify_api_repo/application/service/autenticacao.service.dart';
import 'package:spotify_api_repo/application/use_case/exceptions/token.exception.dart';
import 'package:spotify_api_repo/domain/spotify/spotify_api.dart';
import 'package:spotify_api_repo/domain/spotify/spotify_scope.dart';
import 'package:spotify_api_repo/environment.dart';
import 'package:http/http.dart' as http;
import 'package:spotify_api_repo/infrastructure/service/log.service.dart';
import 'package:spotify_api_repo/infrastructure/service/cookie_jar.service.dart';
import 'package:spotify_api_repo/infrastructure/utils/texto.util.dart';

class AutenticacaoSpotifyService extends AutenticacaoService {
  LogService log = LogService(origem: "AutenticacaoSpotifyService");
  static AutenticacaoSpotifyService? _instancia;
  CookieJarService gerenciadorDeCookies = CookieJarService.instancia;

  AutenticacaoSpotifyService._();

  static get instancia {
    _instancia ??= AutenticacaoSpotifyService._();
    return _instancia;
  }

  Future<Response> efetuarLogin(Request request) async {
    log.exibirInfo("Iniciando o processo de exibição da interface de login do Spotify");
    String state = TextoUtil.obterTextoAleatorio(16);
    String url = '${SpotifyApi.AUTORIZACAO.url}${Uri(
      queryParameters: {
        'response_type': 'code',
        'client_id': Environment.CLIENT_ID,
        'scope': SpotifyScope.obterEscopos(),
        'redirect_uri': Environment.REDIRECT_URI,
        'state': state,
      },
    )}';
    Response response = Response.seeOther(url);

    gerenciadorDeCookies.adicionar(
      [Cookie('state', state)],
      SpotifyApi.AUTORIZACAO.url,
    );
    return response;
  }

  Future<Response> salvarToken(Request request) async {
    final Map<String, dynamic> parametros = request.url.queryParameters;
    String? state = parametros['state'];
    String? code = parametros['code'];

    if (state != null) {
      log.exibirInfo("Iniciando a obtenção do token de acesso do Spotify");
      var url = Uri.parse(SpotifyApi.TOKEN.url);

      var body = {
        'code': code,
        'redirect_uri': Environment.REDIRECT_URI,
        'grant_type': 'authorization_code',
      };

      var headers = {
        'Authorization': 'Basic ${TextoUtil.obterCredenciaisEmBase64}',
        'Content-type': 'application/x-www-form-urlencoded',
      };

      http.Response resposta = await _obterTokens(url, body, headers);
      return Response.seeOther(Environment.FRONT_URI);
    }

    log.exibirErro("Erro ao efetuar a obtenção do token de acesso do Spotify", TokenException());
    return Response.seeOther('/#');
  }

  Future<http.Response> _obterTokens(Uri url, Map<String, dynamic> body, Map<String, String> headers) async {
    return await http.post(url, body: body, headers: headers).then((response) {
      if (_verificarSucesso(response.statusCode)) {
        log.exibirSucesso("Sucesso ao efetuar a obtenção do token de acesso do Spotify");
        _salvarTokenEmCookies(response);
        return response;
      } else {
        log.exibirErro("Erro ao efetuar a obtenção do token de acesso do Spotify", response.body);
        throw TokenException();
      }
    });
  }

  void _salvarTokenEmCookies(http.Response response) {
    if (_verificarSucesso(response.statusCode)) {
      Map<String, dynamic> tokens = jsonDecode(response.body);
      gerenciadorDeCookies.adicionar(
        [
          Cookie('access_token', tokens['access_token']),
          Cookie('refresh_token', tokens['refresh_token']),
        ],
        SpotifyApi.TOKEN.url,
      );
    }
  }

  bool _verificarSucesso(int? status) {
    if (status != null) return status >= 200 && status <= 299;
    return false;
  }
}
