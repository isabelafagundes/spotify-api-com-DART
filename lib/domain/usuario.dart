import 'package:spotify_api_repo/domain/imagem.dart';

class Usuario {
  final String? _nome;
  final String _id;
  final List<Imagem> _imagens;

  Usuario(this._nome, this._id, this._imagens);

  factory Usuario.criar(String nome, String id, List<Imagem> imagens) => Usuario(nome, id, imagens);

  List<Imagem> get imagens => _imagens;

  String get id => _id;

  String? get nome => _nome;

  Map<String, dynamic> paraMapa() {
    return {
      "id": _id,
      "nome": _nome,
      "imagens": _imagens.map((e) => e.paraMapa()).toList(),
    };
  }

  factory Usuario.obterUsuarioDeMapa(Map<String, dynamic> usuarioAsMap) {
    return Usuario.criar(
      usuarioAsMap['display_name'],
      usuarioAsMap['id'],
      (usuarioAsMap['images'] as List).map((e) => Imagem.carregarDeMapa(e)).toList(),
    );
  }
}
