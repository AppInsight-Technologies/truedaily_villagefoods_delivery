import 'package:shared_preferences/shared_preferences.dart';


class PrefUtils {
  //static PrefUtils _storageUtil;
  // static SharedPreferences _preferences;//=await SharedPreferences.getInstance();
  //static Future<SharedPreferences> get _instance async => _prefsInstance ??= await SharedPreferences.getInstance();
  static SharedPreferences prefs;

  // call this method from iniState() function of mainApp().
  /*static Future<SharedPreferences> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance;
  }*/

  /*static Future<PrefUtils> getInstance() async {
    if (_storageUtil == null) {
      // keep local instance till it is fully initialized.
      var secureStorage = PrefUtils._();
      await secureStorage._init();
      _storageUtil = secureStorage;

    }
    return _storageUtil;
  }*/

  PrefUtils._();

  static Future init() async {
    prefs = await SharedPreferences.getInstance();
  }

}
