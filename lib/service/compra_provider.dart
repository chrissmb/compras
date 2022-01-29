import '../schema/compra.dart';
import 'default_provider.dart';

abstract class CompraProvider extends DefaultProvider<Compra, int> {
  Future<Compra> saveWithGrupo(Compra compra, String grupoDescricao);
}
