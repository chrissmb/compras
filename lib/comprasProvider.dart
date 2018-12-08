import 'package:sqflite/sqflite.dart';
import 'compra.dart';
import 'dart:async';

class ComprasProvider {
  Database db;

  final _tbCompras = 'compras';
  final _columnId = 'id';
  final _columnDescricao = 'descricao';
  final _columnStatus = 'status';

  Future open() async {
    String path = 'compras.db';
    try {
      db = await openDatabase(
        path,
        version: 1,
        onCreate: (Database dbase, int version) async {
          await dbase.execute('''
          create table $_tbCompras (
            $_columnId integer primary key,
            $_columnDescricao text not null,
            $_columnStatus integer not null
          )
        ''');
        },
      );
    } catch (e) {
      print('Erro ao acessar DB: $e');
    }
  }

  Future<Compra> save(Compra compra) async {
    if (compra == null) return null;
    if (compra.id == null) {
      compra.id = await db.insert(_tbCompras, compra.toMap());
    } else {
      compra.id = await db.update(
        _tbCompras,
        compra.toMap(),
        where: '$_columnId = ?',
        whereArgs: [compra.id],
      );
    }
    return compra;
  }

  Future<List<Compra>> getALl() async {
    var lista = await db.query(_tbCompras);
    return lista.map((c) => Compra.fromMap(c)).toList();
  }

  Future<Compra> getOne(int id) async {
    if (id == null || id < 1) return null;
    var lista = await db.query(
      _tbCompras,
      where: '$_columnId = ?',
      whereArgs: [id],
    );
    for (var c in lista) {
      return Compra.fromMap(c);
    }
    return null;
  }

  Future<bool> delete(int id) async {
    var idReturn = await db.delete(
      _tbCompras,
      where: '$_columnId = ?',
      whereArgs: [id],
    );
    if (idReturn == id) {
      return true;
    } else {
      return false;
    }
  }

  Future close() async => db.close();
}
