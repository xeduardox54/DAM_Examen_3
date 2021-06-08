import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {
  static final PreferenciasUsuario _instancia = new PreferenciasUsuario._internal();
  factory PreferenciasUsuario() {
    return _instancia;
  }
  PreferenciasUsuario._internal();
  SharedPreferences _prefs;
  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }
  get token {
    return _prefs.getString('token') ?? '';
  }
  set token( String value ) {
    _prefs.setString('token', value);
  }
  get ultimaPagina {
    return _prefs.getString('ultimaPagina') ?? 'login';
  }
  set ultimaPagina( String value ) {
    _prefs.setString('ultimaPagina', value);
  }
}