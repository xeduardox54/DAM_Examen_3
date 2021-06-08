import 'package:flutter/material.dart';
import 'package:proyectounderway/src/bloc/provider.dart';
import 'package:proyectounderway/src/pages/LogIn/registro_page.dart';
import 'package:proyectounderway/src/pages/Map/map_page.dart';
import 'package:proyectounderway/src/pages/LogIn/login_page.dart';
import 'package:proyectounderway/src/pages/products/home_page.dart';
import 'package:proyectounderway/src/pages/products/product.dart';
import 'package:proyectounderway/src/preferencias_usuario/preferencias_usuario.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Google Maps',
        initialRoute: 'login_page',
        routes: {
          'map_page': (BuildContext context) => MapScreen(),
          'login_page': (BuildContext context) => LoginPage(),
          'producto': (BuildContext context) => ProductoPage(),
          'home': (BuildContext context) => HomePage(),
          'registro': (BuildContext context) => RegistroPage(),
        },
        theme: ThemeData(primaryColor: Color(0xff003FFF)),
      ),
    );
  }
}
