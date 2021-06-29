import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {
  static final PreferenciasUsuario _instancia =
      new PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }
  PreferenciasUsuario._internal();
  SharedPreferences? _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  var setgenero;
  // GET y SET del genero
  get genero {
    //setgenero= _prefs?.getInt('genero') ?? 1;
    //return setgenero;
    return _prefs?.getInt('genero') ?? 1;
  }

  set genero(var value) {
    _prefs?.setInt('genero', value);
  }

  // GET y SET del colorSecundario
  get colorSecundario {
    return _prefs?.getBool('colorSecundario') ?? false;
  }

  set colorSecundario(var value) {
    _prefs?.setBool('colorSecundario', value);
  }

  // GET y SET del nombreUsuario
  get token {
    return _prefs?.getString('token') ?? 'Pedro';
  }

  set token(var value) {
    _prefs?.setString('token', value);
  }

  // GET y SET de la ultima pagina
  get ultimaPagina {
    return _prefs?.getString('ultimaPagina') ?? 'home';
  }

  set ultimaPagina(var value) {
    _prefs?.setString('ultimaPagina', value);
  }
}
