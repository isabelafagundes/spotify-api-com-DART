import 'package:shelf/shelf.dart';

abstract class AutenticacaoService {
  Future<Response> efetuarLogin(Request request);

  Future<Response> salvarToken(Request request);
}
