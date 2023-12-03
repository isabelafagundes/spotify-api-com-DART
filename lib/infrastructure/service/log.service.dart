import 'package:logging/logging.dart';

class LogService {
  final String origem;

  LogService({required this.origem});

  void inicializar() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((event) {
      print('${event.level.name} - ${event.loggerName}: ${event.time}: ${event.message}');
      if (event.error != null) print("Erro: ${event.error}");
      if (event.stackTrace != null) print('StackTrace: ${event.stackTrace}');
    });
  }

  void exibirSucesso(String mensagem) => logger.log(Level.FINE, "$mensagem !");

  void exibirInfo(String mensagem) => logger.log(Level.INFO, "$mensagem ...");

  void exibirErro(String mensagem, Object? erro) => logger.log(Level.SEVERE, "$mensagem !!", erro);

  Logger get logger => Logger(this.origem);
}
