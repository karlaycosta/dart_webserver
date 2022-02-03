import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:path/path.dart' as path;
import 'models/alimentos.dart';

void main() async {

  const port = 8080;
  final ip = InternetAddress.anyIPv4;

  sqfliteFfiInit();
  final caminho = path.join(path.current, 'evo.db');
  final db = await databaseFactoryFfi.openDatabase(caminho);
  print(db.isOpen);

  final overrideHeaders = {
    ACCESS_CONTROL_ALLOW_ORIGIN: '*',
  };

  // INÍCIO DAS ROTAS
  final app = Router();

  app.get('/alimentos', (Request request) async {
    return Response.ok(
      await getAlimentos(db),
      headers: {'content-type': 'application/json'},
    );
  });

  app.get('/alimentosfiltrados/<predicado>', (Request request, String predicado) async {
    final pred = Uri.decodeFull(predicado);
    if (pred.length < 3) {
      return Response(204);
    }
    return Response.ok(
      await getAlimentosFiltrados(db, pred),
      headers: {'content-type': 'application/json'},
    );
  });

  // FIM DAS ROTAS

  final handlerStatic = createStaticHandler(
    'public',
    defaultDocument: 'index.html',
  );

  final mainHandler = Cascade().add(handlerStatic).add(app).handler;
  final pipe = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsHeaders(headers: overrideHeaders))
      .addHandler(mainHandler);
  final server = await serve(pipe, ip, port);
  server.autoCompress = true;
  print('Servidor rodando no $ip:$port');
}

Future<String> getAlimentos(Database db) async {
  final res = await db.rawQuery('select * from alimentos');
  return jsonEncode(res);
}

Future<String> getAlimentosFiltrados(Database db, String predicado) async {
  final res = await db.rawQuery('''SELECT * FROM alimentos WHERE replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(alimentos.nome, 'á','a'), 'ã','a'), 'â','a'), 'é','e'), 'ê','e'), 'í','i'),'ó','o') ,'õ','o') ,'ô','o'),'ú','u'), 'ç','c') LIKE '%$predicado%';''');
  return jsonEncode(res);
}