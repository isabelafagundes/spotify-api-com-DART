import 'package:shelf/shelf.dart';
import 'package:spotify_api_repo/application/service/usuario.service.dart';
import 'package:spotify_api_repo/application/use_case/usuario.usecase.dart';
import 'package:spotify_api_repo/domain/faixa.dart';
import 'package:spotify_api_repo/domain/usuario.dart';

class UsuarioComponent {
  late UsuarioUseCase _useCase;

  void inicializar(UsuarioService service) => _useCase = UsuarioUseCase(service);

  Future<Usuario> obterPerfil(Request request) async => await _useCase.obterPerfil(request);

  Future<List<Faixa>> obterPrincipaisFaixas(Request request) async => await _useCase.obterPrincipaisFaixas(request);
}
