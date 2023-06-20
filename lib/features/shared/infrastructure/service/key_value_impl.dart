import 'package:shared_preferences/shared_preferences.dart';
import 'package:teslo_shop/features/shared/infrastructure/service/key_value_storage.dart';

////2
class KeyValueStorageServiceImpl extends KeyValueStorageService {
  //esta liberia es para guardar datos en el dispositivo
  Future<SharedPreferences> getSharedPrefs() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Future<T?> getValue<T>(String key) async {
    final prefs = await getSharedPrefs();

    switch (T) {
      //si es entero lo guardo como entero
      case int:
        //me retorna un entero
        return prefs.getInt(key) as T?;

      //si es string lo guardo como string
      case String:
        return prefs.getString(key) as T?;

      default:
        throw Exception('Tipo de dato no soportado');
    }
  }

  @override
  Future<bool> removeKey(String key) async {
    final prefs = await getSharedPrefs();
    return await prefs.remove(key);
  }

  @override
  Future<void> setKetValue<T>(String key, T value) async {
    final prefs = await getSharedPrefs();

    switch (T) {
      //si es entero lo guardo como entero
      case int:
        prefs.setInt(key, value as int);
        break;

      //si es string lo guardo como string
      case String:
        prefs.setString(key, value as String);
        break;

      default:
        throw Exception('Tipo de dato no soportado');
    }
  }
}
