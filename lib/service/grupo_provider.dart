import '../schema/grupo.dart';
import 'default_provider.dart';

abstract class GrupoProvider extends DefaultProvider<Grupo, int> {
  Future<List<Grupo>> getByDescricao(String descricao);
}
