import 'package:spotify_api_repo/domain/album.dart';
import 'package:spotify_api_repo/domain/artista.dart';
import 'package:spotify_api_repo/domain/imagem.dart';

class Faixa {
  final String _nome;
  final Album _album;
  final List<Artista> _artistas;
  final String _id;
  final List<Imagem> _imagens;
  final String? _uri;

  Faixa(
    this._nome,
    this._album,
    this._artistas,
    this._id,
    this._imagens,
    this._uri,
  );

  factory Faixa.criar(
    String nome,
    Album album,
    List<Artista> artistas,
    String id,
    List<Imagem> imagens,
    String? uri,
  ) {
    return Faixa(
      nome,
      album,
      artistas,
      id,
      imagens,
      uri,
    );
  }

  String? get uri => _uri;

  List<Imagem> get imagens => _imagens;

  String get id => _id;

  List<Artista> get artistas => _artistas;

  Album get album => _album;

  String get nome => _nome;

  Map<String, dynamic> paraMapa() {
    return {
      "id": _id,
      "nome": _nome,
      "imagens": _imagens.map((e) => e.paraMapa()),
      "album": _album.paraMapa(),
      "uri": _uri,
      "artistas": _artistas.map((e) => e.paraMapa()),
    };
  }

  factory Faixa.carregarDeMapa(Map<String, dynamic> faixaAsMap) {
    return Faixa.criar(
      faixaAsMap['name'],
      Album.carregarDeMapa(faixaAsMap['album']),
      (faixaAsMap['artists'] as List).map((e) => Artista.carregarDeMapa(e)).toList(),
      faixaAsMap['id'],
      (faixaAsMap['images'] as List).map((e) => Imagem.carregarDeMapa(e)).toList(),
      faixaAsMap['uri'],
    );
  }
}
