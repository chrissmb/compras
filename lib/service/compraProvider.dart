import 'dart:async';
import '../schema/compra.dart';
import 'defaultProvider.dart';
import 'grupoProvider.dart';

class CompraProvider extends DefaultProvider {

  static final tbCompra = 'compra';

  static final _sql = '''
      select c.*,
        g.descricao grupo_descricao
      from $tbCompra c
      left join ${GrupoProvider.tbGrupo} g
        on g.id = c.grupo_id
    ''';

  Future<Compra> save(Compra compra) async {
    if (compra == null) return null;
    if (compra.id == null) {
      compra.id = await db.insert(tbCompra, compra.toMap());
    } else {
      await db.update(
        tbCompra,
        compra.toMap(),
        where: 'id = ?',
        whereArgs: [compra.id],
      );
    }
    return compra;
  }

  Future<List<Compra>> getALl() async {
    var lista = await db.rawQuery(_sql);
    return lista.map((c) => Compra.fromMap(c)).toList();
  }

  Future<Compra> getOne(int id) async {
    if (id == null || id < 1) return null;
    var lista = await db.rawQuery(_sql + ' where c.id = ?', [id]);
    return lista.map((c) => Compra.fromMap(c)).first;
  }

  Future<bool> delete(int id) async {
    var idReturn = await db.delete(
      tbCompra,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (idReturn == id) {
      return true;
    } else {
      return false;
    }
  }
}
