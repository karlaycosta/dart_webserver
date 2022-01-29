import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';

import 'models/alimentos.dart';

void main() async {
  const port = 8080;
  final ip = InternetAddress.anyIPv4;

  final overrideHeaders = {
    ACCESS_CONTROL_ALLOW_ORIGIN: '*',
  };

  // INÍCIO DAS ROTAS
  final app = Router();
  app.get('/alimentos', (Request request) {
    return Response.ok(
      getAlimentos(),
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

String getAlimentos() {
  return jsonEncode(<Alimento>[
    Alimento(id: 1, categoria: 1, nome: 'Banana', criacao: DateTime.now()),
    Alimento(id: 2, categoria: 1, nome: 'Maça', criacao: DateTime.now()),
    Alimento(id: 2, categoria: 1, nome: 'Uva', criacao: DateTime.now()),
  ]);
}
