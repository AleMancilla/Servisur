import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static final UserPreferences _instancia = UserPreferences._internal();

  factory UserPreferences() {
    return _instancia;
  }

  UserPreferences._internal();

  SharedPreferences _prefs;

  void initPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }
  ////////////////////////////////////////////
  
}