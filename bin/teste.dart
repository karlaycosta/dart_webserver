import 'dart:convert';

import 'package:diacritic/diacritic.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart' as path;

void main() async {
  print(removeDiacritics('maçã'));
  // sqfliteFfiInit();
  // final caminho = path.join(path.current, 'evo.db');
  // final db = await databaseFactoryFfi.openDatabase(caminho);
  // final predicado = 'macarrao';
  // final res = await db.rawQuery(
  //   '''SELECT * FROM alimentos WHERE replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(alimentos.nome, 'á','a'), 'ã','a'), 'â','a'), 'é','e'), 'ê','e'), 'í','i'),'ó','o') ,'õ','o') ,'ô','o'),'ú','u'), 'ç','c') LIKE '%$predicado%';''');
  // print(res.length);
  // // for (final item in res) {
  // //   print(item);
  // // }
  // await db.close();
}