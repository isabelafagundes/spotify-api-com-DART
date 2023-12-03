import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:spotify_api_repo/application/component/autenticacao.component.dart';
import 'package:spotify_api_repo/application/component/usuario.component.dart';
import 'package:spotify_api_repo/domain/faixa.dart';
import 'package:spotify_api_repo/domain/header/header.dart';
import 'package:spotify_api_repo/domain/usuario.dart';
import 'package:spotify_api_repo/infrastructure/service/autenticacao_spotify.service.dart';
import 'package:spotify_api_repo/infrastructure/service/usuario_spotify.service.dart';

class Rotas {
  AutenticacaoComponent autenticacaoComponent = AutenticacaoComponent();
  UsuarioComponent usuarioComponent = UsuarioComponent();

  void inicializar() {
    autenticacaoComponent.inicializar(AutenticacaoSpotifyService.instancia);
    usuarioComponent.inicializar(UsuarioSpotifyService.intancia);
  }

  Router get router {
    final router = Router();

    router.get('/login', (Request request) async => await autenticacaoComponent.efetuarLogin(request));

    router.get('/callback', (Request request) async => await autenticacaoComponent.salvarToken(request));

    router.get('/usuario', (Request request) async {
      Usuario usuario = await usuarioComponent.obterPerfil(request);
      String response = jsonEncode(usuario.paraMapa());
      return Response.ok(response, headers: {...Header.JSON.header, ...Header.CORS.header});
    });

    router.get('/faixas', (Request request) async {
      List<Faixa> faixas = await usuarioComponent.obterPrincipaisFaixas(request);
      String response = jsonEncode(faixas.map((e) => e.paraMapa()));
      return Response.ok(response, headers: {...Header.JSON.header, ...Header.CORS.header});
    });

    return router;
  }
}
