import 'package:cookie_jar/cookie_jar.dart';

class CookieJarService {
  static CookieJarService? _instancia;

  CookieJarService._();

  static get instancia {
    _instancia ??= CookieJarService._();
    return _instancia;
  }

  CookieJar cookieJar = CookieJar();

  void adicionar(List<Cookie> cookies, String url) async {
    await cookieJar.saveFromResponse(Uri.parse(url), cookies);
  }

  Future<String?> obter(String url, String chave) async {
    List<Cookie> cookies = await cookieJar.loadForRequest(Uri.parse(url));
    for (Cookie cookie in cookies) {
      if (cookie.name == chave) return cookie.value;
    }
  }
}
