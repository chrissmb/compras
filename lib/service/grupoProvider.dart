import 'defaultProvider.dart';
import '../schema/grupo.dart';

class GrupoProvider extends DefaultProvider {

  static final tbGrupo = 'grupo';
  
  Future<Grupo> save(Grupo grupo) async {
    if (grupo == null) return null;
    if (grupo.id == null) {
      grupo.id = await db.insert(tbGrupo, grupo.toMap());
    } else {
      await db.update(
        tbGrupo,
        grupo.toMap(),
        where: 'id = ?',
        whereArgs: [grupo.id],
      );
    }
    return grupo;
  }

  Future<List<Grupo>> getALl() async {
    var lista = await db.query(tbGrupo);
    return lista.map((g) => Grupo.fromMap(g)).toList();
  }

  Future<Grupo> getOne(int id) async {
    if (id == null || id < 1) return null;
    var lista = await db.query(tbGrupo, where: 'id = ?', whereArgs: [id]);
    return lista.map((g) => Grupo.fromMap(g)).first;
  }

  Future<bool> delete(int id) async {
    var idReturn = await db.delete(
      tbGrupo,
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