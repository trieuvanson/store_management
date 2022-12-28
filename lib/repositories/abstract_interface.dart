
abstract class AbstractInterface<K, E> {
  Future<List<E>> getAll();
  Future<E> getOne(K id);
  Future<E> create(E storeDto);
  Future<E> update(E storeDto);
  Future<void> delete(E storeDto);
}
