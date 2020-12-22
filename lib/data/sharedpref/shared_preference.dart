import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  // shared pref instance

  // General Methods: ---------------------------------------------------------

  // Future<void> saveAuthToken(String authToken) async {
  //   return _sharedPreference.then((prefs) {
  //     prefs.setString('authToken', authToken);
  //   });
  // }
  static saveAuth(String _token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', _token);
  }

  static saveUsername(String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
    prefs.setString('password', password);
  }

  static get getAuth async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static get getUsername async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  static get getUserPassword async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('password');
  }

  static Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  // Future<void> removeAuthToken() async {
  //   return _sharedPreference.then((preference) {
  //     preference.remove(Preferences.auth_token);
  //   });
  // }

  // Future<bool> get isLoggedIn async {
  //   return _sharedPreference.then((preference) {
  //     return preference.getString(Preferences.auth_token) ?? false;
  //   });
  // }

  // // Theme:------------------------------------------------------
  // Future<bool> get isDarkMode {
  //   return _sharedPreference.then((prefs) {
  //     return prefs.getBool(Preferences.is_dark_mode) ?? false;
  //   });
  // }

  // Future<void> changeBrightnessToDark(bool value) {
  //   return _sharedPreference.then((prefs) {
  //     return prefs.setBool(Preferences.is_dark_mode, value);
  //   });
  // }

  // // Language:---------------------------------------------------
  // Future<String> get currentLanguage {
  //   return _sharedPreference.then((prefs) {
  //     return prefs.getString(Preferences.current_language);
  //   });
  // }

  // Future<void> changeLanguage(String language) {
  //   return _sharedPreference.then((prefs) {
  //     return prefs.setString(Preferences.current_language, language);
  //   });
  // }
}

// addUserToSF(String _token) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   prefs.setString('token', _token);
// }

// getUserValuesSF() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.getString('token');
// }
