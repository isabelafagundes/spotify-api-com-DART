import 'package:shelf/shelf.dart';
import 'package:spotify_api_repo/application/service/autenticacao.service.dart';
import 'package:spotify_api_repo/application/use_case/autenticacao.usecase.dart';

class AutenticacaoComponent {
  late AutenticacaoUseCase _useCase;

  void inicializar(AutenticacaoService service) => _useCase = AutenticacaoUseCase(service);

  Future<Response> efetuarLogin(Request request) async => await _useCase.efetuarLogin(request);

  Future<Response> salvarToken(Request request) async => await _useCase.salvarToken(request);
}
