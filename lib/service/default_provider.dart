abstract class DefaultProvider<T, P> {
  Future<T> save(T compra);

  Future<List<T>> getAll();

  Future<T> getOne(P id);

  Future<void> delete(P id);

  Future close();
}
