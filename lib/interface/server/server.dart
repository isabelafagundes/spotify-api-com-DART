import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart' as cors;
import 'package:spotify_api_repo/application/component/autenticacao.component.dart';
import 'package:spotify_api_repo/application/component/usuario.component.dart';
import 'package:spotify_api_repo/domain/faixa.dart';
import 'package:spotify_api_repo/domain/header/header.dart';
import 'package:spotify_api_repo/domain/usuario.dart';
import 'package:spotify_api_repo/infrastructure/service/autenticacao_spotify.service.dart';
import 'package:spotify_api_repo/infrastructure/service/log.service.dart';
import 'package:spotify_api_repo/infrastructure/service/usuario_spotify.service.dart';
import 'package:spotify_api_repo/infrastructure/utils/texto.util.dart';
import 'package:spotify_api_repo/interface/server/rotas.dart';

class Server {
  LogService logService = LogService(origem: "Server");
  Rotas rotas = Rotas();

  void inicializar() async {
    logService.inicializar();
    rotas.inicializar();

    final handler = await Pipeline().addMiddleware(cors.corsHeaders()).addMiddleware((response) {
      return (request) async {
        try {
          return _tratarRequest(request, response);
        } catch (erro) {
          return _tratarErro(erro);
        }
      };
    }).addHandler(rotas.router);
    var server = await shelf.serve(handler, 'localhost', 8080);
    print(TextoUtil.logoSpollete);
    print('Servidor rodando em ${server.address.host}:${server.port}');
  }

  Future<Response> _tratarErro(Object? erro) async {
    return Response.internalServerError(
      body: 'Erro interno do servidor: $erro',
      headers: Header.TEXT.header,
    );
  }

  Future<Response> _tratarRequest(Request request, Function(Request) response) async {
    if (request.method == 'OPTIONS') {
      return Response.ok('', headers: {
        ...Header.CORS.header,
        ...Header.JSON.header,
      });
    }
    Response resposta = await response(request);
    return resposta.change(headers: {
      ...Header.CORS.header,
      ...Header.JSON.header,
    });
  }
}
