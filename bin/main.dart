import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart' as path;
import 'models/alimentos.dart';

void main() async {

  const port = 8080;
  final ip = InternetAddress.anyIPv4;

  final overrideHeaders = {
    ACCESS_CONTROL_ALLOW_ORIGIN: '*',
  };

  // INÍCIO DAS ROTAS
  final app = Router();
  app.get('/alimentos', (Request request) async {
    return Response.ok(
      await getAlimentos(),
      headers: {'content-type': 'application/json'},
    );
  });

  app.get('/alimentosfiltrados/<predicado>', (Request request, String predicado) async {
    return Response.ok(
      await getAlimentosFiltrados(predicado),
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

Future<String> getAlimentos() async {
  sqfliteFfiInit();
  final caminho = path.join(path.current, 'evo.db');
  final db = await databaseFactoryFfi.openDatabase(caminho);
  final res = await db.rawQuery('select * from alimentos');
  await db.close();
  return jsonEncode(res);
}

Future<String> getAlimentosFiltrados(String predicado) async {
  sqfliteFfiInit();
  final caminho = path.join(path.current, 'evo.db');
  final db = await databaseFactoryFfi.openDatabase(caminho);
  final res = await db.rawQuery('''SELECT * FROM alimentos WHERE replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(alimentos.nome, 'á','a'), 'ã','a'), 'â','a'), 'é','e'), 'ê','e'), 'í','i'),'ó','o') ,'õ','o') ,'ô','o'),'ú','u'), 'ç','c') LIKE '%$predicado%';''');
  await db.close();
  return jsonEncode(res);
}