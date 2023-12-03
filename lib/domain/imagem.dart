class Imagem {
  final String _url;
  final int _altura;
  final int _largura;

  Imagem(this._url, this._altura, this._largura);

  factory Imagem.criar(String url, int altura, int largura) => Imagem(url, altura, largura);

  get largura => _largura;

  get altura => _altura;

  get url => _url;

  Map<String, dynamic> paraMapa() {
    return {
      "url": _url,
      "altura": _altura,
      "largura": _largura,
    };
  }

  static Imagem carregarDeMapa(Map<String, dynamic> imagemAsMap) {
    return Imagem.criar(
      imagemAsMap['url'],
      imagemAsMap['height'],
      imagemAsMap['width'],
    );
  }
}
