import 'dart:convert';
import 'dart:math';

import 'package:spotify_api_repo/environment.dart';

class TextoUtil {
  static String get obterCredenciaisEmBase64 {
    List<int> utf8Texto = utf8.encode("${Environment.CLIENT_ID}:${Environment.CLIENT_SECRET}");
    return base64.encode(utf8Texto);
  }

  static String obterTextoAleatorio(int tamanho) {
    const charset = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    var random = Random.secure();
    return String.fromCharCodes(
      Iterable.generate(
        tamanho,
        (_) => charset.codeUnitAt(
          random.nextInt(charset.length),
        ),
      ),
    );
  }

  static String get logoSpollete {
    return '''
   _____             _ _      _       
  / ____|           | | |    | |      
 | (___  _ __   ___ | | | ___| |_ ___ 
  \\___ \\| '_ \\ / _ \\| | |/ _ \\ __/ _ \\
  ____) | |_) | (_) | | |  __/ ||  __/
 |_____/| .__/ \\___/|_|_|\\___|\\__\\___|
        | |                           
        |_|                           
    ''';
  }
}
