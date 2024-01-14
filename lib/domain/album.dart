import 'package:spotify_api_repo/domain/imagem.dart';

class Album {
  final String _nome;
  final String _id;
  final List<Imagem>? _imagens;

  Album(this._nome, this._id, this._imagens);

  factory Album.criar(String nome, String id, List<Imagem>? imagens) {
    return Album(nome, id, imagens);
  }

  List<Imagem>? get imagens => _imagens;

  String get id => _id;

  String get nome => _nome;

  Map<String, dynamic> paraMapa() {
    return {
      "id": _id,
      "nome": _nome,
      "imagens": _imagens != null ? _imagens!.map((e) => e.paraMapa()).toList() : null,
    };
  }

  factory Album.carregarDeMapa(Map<String, dynamic> albumAsMap) {
    return Album.criar(
      albumAsMap['name'],
      albumAsMap['id'],
      albumAsMap['images'] != null
          ? (albumAsMap['images'] as List).map((e) => Imagem.carregarDeMapa(e)).toList()
          : null,
    );
  }
}
