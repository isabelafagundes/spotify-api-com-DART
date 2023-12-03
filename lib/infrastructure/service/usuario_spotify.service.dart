import 'dart:convert';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:shelf/shelf.dart';
import 'package:spotify_api_repo/application/service/usuario.service.dart';
import 'package:spotify_api_repo/application/use_case/exceptions/bad_oauth_request.exception.dart';
import 'package:spotify_api_repo/application/use_case/exceptions/faixas_nao_encontradas.exception.dart';
import 'package:spotify_api_repo/application/use_case/exceptions/limite.exception.dart';
import 'package:spotify_api_repo/application/use_case/exceptions/token.exception.dart';
import 'package:spotify_api_repo/application/use_case/exceptions/token_expirado.exception.dart';
import 'package:spotify_api_repo/application/use_case/exceptions/usuario_nao_encontrado.exception.dart';
import 'package:spotify_api_repo/domain/spotify/spotify_api.dart';
import 'package:spotify_api_repo/domain/faixa.dart';
import 'package:spotify_api_repo/domain/usuario.dart';
import 'package:spotify_api_repo/infrastructure/service/log.service.dart';
import 'package:spotify_api_repo/infrastructure/service/cookie_jar.service.dart';
import 'package:http/http.dart' as http;

class UsuarioSpotifyService extends UsuarioService {
  LogService log = LogService(origem: "UsuarioSpotifyService");
  static UsuarioSpotifyService? _instancia;
  CookieJarService gerenciadorDeCookies = CookieJarService.instancia;

  UsuarioSpotifyService._();

  static UsuarioSpotifyService get intancia {
    _instancia ??= UsuarioSpotifyService._();
    return _instancia!;
  }

  Future<Usuario> obterPerfil(Request request) async {
    log.exibirInfo("Iniciando a obtenção do perfil do usuário");
    Usuario usuario = await http.get(Uri.parse(SpotifyApi.USUARIO.url), headers: await obterHeader).catchError((erro) {
      if (erro.statusCode == 404) throw UsuarioNaoEncontradoException();
      _tratarErrosGenericos(erro);
      _verificarSucesso(erro, "obtençao do perfil do usuário");
    }).then((usuario) => _obterPerfil(usuario));
    String? id = await gerenciadorDeCookies.obter(SpotifyApi.USUARIO.url, 'id');
    log.exibirSucesso("Sucesso na obtenção do perfil do usuário de id $id");
    return usuario;
  }

  Usuario _obterPerfil(http.Response response) {
    Map<String, dynamic> usuario = jsonDecode(response.body);
    Usuario? usuarioDeMapa = Usuario.obterUsuarioDeMapa(usuario);
    if (usuarioDeMapa == null) throw UsuarioNaoEncontradoException();
    gerenciadorDeCookies.adicionar([Cookie('id', usuarioDeMapa.id)], SpotifyApi.USUARIO.url);
    return usuarioDeMapa;
  }

  Future<List<Faixa>> obterPrincipaisFaixas(Request request) async {
    log.exibirInfo("Iniciando a obtenção das principais faixas do usuário");
    List<Faixa> faixas =
        await http.get(Uri.parse(SpotifyApi.TOP_FAIXAS.url), headers: await obterHeader).catchError((erro) {
      if (erro.statusCode == 404) throw FaixasNaoEncontradasException();
      _tratarErrosGenericos(erro);
      _verificarSucesso(erro, "obtençao das principais faixas do usuário");
    }).then((response) => _obterPrincipaisFaixas(response));
    log.exibirSucesso("Sucesso na obtenção das principais faixas do usuário");
    return faixas;
  }

  List<Faixa> _obterPrincipaisFaixas(http.Response response) {
    Map<String, dynamic> faixasAsMap = jsonDecode(response.body);
    List<Faixa> faixas = (faixasAsMap as List).map((e) => Faixa.carregarDeMapa(e)).toList();
    return faixas;
  }

  Future<Map<String, String>> get obterHeader async {
    String? accessToken = await gerenciadorDeCookies.obter(SpotifyApi.TOKEN.url, 'access_token');
    if (accessToken == null) throw TokenException();
    return {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };
  }

  void _verificarSucesso(http.Response response, String situacao) {
    if (response.statusCode >= 200 && response.statusCode <= 299) return;
    log.exibirErro("Ocorreu um erro no processo de $situacao", response);
  }

  void _tratarErrosGenericos(http.Response response) {
    if (response.statusCode == 401) throw TokenExpiradoException();
    if (response.statusCode == 403) throw BadOAuthRequestException();
    if (response.statusCode == 429) throw LimiteException();
  }
}
