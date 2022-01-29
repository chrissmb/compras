import '../service/compra_provider.dart';
import '../service/sqflite/compra_provider_sqflite.dart';
import '../service/grupo_provider.dart';
import '../service/sqflite/grupo_provider_sqflite.dart';

class Injetor {
  static final _registros = <Type, InjetorRegistro>{
    CompraProvider:
        InjetorRegistro<CompraProvider>(() => CompraProviderSqflite(), true),
    GrupoProvider:
        InjetorRegistro<GrupoProvider>(() => GrupoProviderSqflite(), true),
  };

  static T instance<T>() {
    var registro = _registros[T];
    if (registro == null) throw Exception('Classe não declarada no Injetor.');
    if (registro.instance == null || !registro.singleton) {
      registro.instance = registro.instantiate();
    }
    return registro.instance;
  }
}

class InjetorRegistro<T> {
  T Function() instantiate;
  bool singleton;
  T? instance;

  InjetorRegistro(this.instantiate, this.singleton);
}
