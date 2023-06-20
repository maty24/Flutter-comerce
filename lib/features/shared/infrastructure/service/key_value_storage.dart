



///////1
abstract class KeyValueStorageService {
  // el tipo T es para que sea generico osea que puede ser cualquier tipo de dato
  Future<void> setKetValue<T>(String key, T value);
  Future<T?> getValue<T>(String key);
  Future<bool> removeKey(String key);
}
