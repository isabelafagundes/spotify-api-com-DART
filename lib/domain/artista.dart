import 'package:spotify_api_repo/domain/imagem.dart';

class Artista {
  final String _nome;
  final List<String> _generos;
  final String _id;
  final List<Imagem> _imagens;

  Artista(
    this._nome,
    this._generos,
    this._id,
    this._imagens,
  );

  factory Artista.criar(
    String nome,
    List<String> generos,
    String id,
    List<Imagem> imagens,
  ) {
    return Artista(
      nome,
      generos,
      id,
      imagens,
    );
  }

  List<Imagem> get imagens => _imagens;

  String get id => _id;

  List<String> get generos => _generos;

  String get nome => _nome;

  Map<String, dynamic> paraMapa() {
    return {
      "id": _id,
      "generos": _generos,
      "nome": _nome,
      "imagens": _imagens.map((e) => e.paraMapa()),
    };
  }

  factory Artista.carregarDeMapa(Map<String, dynamic> artistaAsMap) {
    return Artista.criar(
      artistaAsMap['name'],
      artistaAsMap['genres'],
      artistaAsMap['id'],
      (artistaAsMap['images'] as List).map((e) => Imagem.carregarDeMapa(e)).toList(),
    );
  }
}
