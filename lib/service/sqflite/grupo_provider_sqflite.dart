import 'base_provider_sqflite.dart';
import '../../schema/grupo.dart';
import '../grupo_provider.dart';

class GrupoProviderSqflite extends BaseProviderSqflite
    implements GrupoProvider {
  static final tbGrupo = 'grupo';

  @override
  Future<Grupo> save(Grupo grupo) async {
    Grupo? grupoDb = await getByDescricao(grupo.descricao);
    if (grupoDb != null) return grupoDb;
    if (grupo.id == null) {
      grupo.id = await (await db).insert(tbGrupo, grupo.toMap());
    } else {
      await (await db).update(
        tbGrupo,
        grupo.toMap(),
        where: 'id = ?',
        whereArgs: [grupo.id],
      );
    }
    return grupo;
  }

  @override
  Future<List<Grupo>> getAll() async {
    var lista = await (await db).query(tbGrupo);
    return lista.map((g) => Grupo.fromMap(g)).toList();
  }

  @override
  Future<Grupo> getOne(int id) async {
    var lista =
        await (await db).query(tbGrupo, where: 'id = ?', whereArgs: [id]);
    return lista.map((g) => Grupo.fromMap(g)).first;
  }

  @override
  Future<void> delete(int id) async {
    await (await db).delete(
      tbGrupo,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<Grupo?> getByDescricao(String descricao) async {
    var lista = await (await db).query(tbGrupo,
        where: 'lower(descricao) = ?', whereArgs: [descricao.toLowerCase()]);
    if (lista.isEmpty) return null;
    return lista.map((g) => Grupo.fromMap(g)).first;
  }
}
