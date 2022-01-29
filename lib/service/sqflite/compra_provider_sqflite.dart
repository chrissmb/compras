import 'dart:async';
import '../../schema/compra.dart';
import 'base_provider_sqflite.dart';
import 'grupo_provider_sqflite.dart';
import '../compra_provider.dart';

class CompraProviderSqflite extends BaseProviderSqflite
    implements CompraProvider {
  static final tbCompra = 'compra';

  static final _sql = '''
      select c.*,
        g.descricao grupo_descricao
      from $tbCompra c
      left join ${GrupoProviderSqflite.tbGrupo} g
        on g.id = c.grupo_id
    ''';

  @override
  Future<Compra> save(Compra compra) async {
    if (compra.id == null) {
      compra.id = await (await db).insert(tbCompra, compra.toMap());
    } else {
      await (await db).update(
        tbCompra,
        compra.toMap(),
        where: 'id = ?',
        whereArgs: [compra.id],
      );
    }
    return compra;
  }

  @override
  Future<List<Compra>> getAll() async {
    var lista = await (await db).rawQuery(_sql);
    return lista.map((c) => Compra.fromMap(c)).toList();
  }

  @override
  Future<Compra> getOne(int id) async {
    var lista = await (await db).rawQuery(_sql + ' where c.id = ?', [id]);
    return lista.map((c) => Compra.fromMap(c)).first;
  }

  @override
  Future<void> delete(int id) async {
    return (await db).delete(
      tbCompra,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
