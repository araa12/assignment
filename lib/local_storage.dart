import 'package:get_storage/get_storage.dart';

class LocalStorage {
  saveValue({required String key, required String value}) async {
    return await GetStorage().write(key, value);
  }

  String readValue({required String key}) {
    return GetStorage().read(key) ?? '';
  }
}
