import 'package:sqflite/sqflite.dart';
import 'dart:async';

abstract class BaseProviderSqflite {
  final _pathDatabase = 'compras.db';

  Database? _db;

  bool get isDbOpened => _db?.isOpen ?? false;

  Future<Database> get db async {
    if (!isDbOpened) {
      await open();
    } 
    // else {
    //   await _db!.close();
    //   deleteDatabase(_pathDatabase);
    // }
    return _db!;
  }

  final _sqlCreateGrupo = '''
    create table grupo (
      id integer primary key,
      descricao text not null
    )
  ''';
  
  final _sqlCreateCompra = '''
    create table compra (
      id integer primary key,
      descricao text not null,
      status integer not null,
      grupo_id integer,
      foreign key(grupo_id) references grupo(id)
    )
  ''';

  Future open() async {
    try {
      _db = await openDatabase(
        _pathDatabase,
        version: 1,
        onCreate: (Database dbase, int version) async {
          await dbase.execute(_sqlCreateGrupo);
          await dbase.execute(_sqlCreateCompra);
        },
      );
    } catch (e) {
      throw Exception('Erro ao acessar DB: $e');
    }
  }

  Future close() async {
    if (isDbOpened) {
      _db!.close();
    }
  }
}
