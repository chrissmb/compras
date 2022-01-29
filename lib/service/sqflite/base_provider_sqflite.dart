import 'package:sqflite/sqflite.dart';
import 'dart:async';

abstract class BaseProviderSqflite {
  Database? _db;

  bool get isDbOpened => _db?.isOpen ?? false;

  Future<Database> get db async {
    if (!isDbOpened) {
      await open();
    }
    return _db!;
  }

  final _sqlCreate = '''

    create table grupo (
      id integer primary key,
      descricao text not null
    )

    create table compra (
      id integer primary key,
      descricao text not null,
      status integer not null,
      grupo_id integer,
      foreign key(grupo_id) references grupo(id)
    )
  ''';

  Future open() async {
    String path = 'compras.db';
    try {
      _db = await openDatabase(
        path,
        version: 1,
        onCreate: (Database dbase, int version) async {
          await dbase.execute(_sqlCreate);
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
