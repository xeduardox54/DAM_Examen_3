import 'dart:math';
import 'package:flutter/material.dart';

class  CrearFondo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
  final fondoModaro = Container(
    height: size.height * 1,
    width: double.infinity,
  );
  final circulo = Container(
    width: 100.0,
    height: 100.0,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, 0.3)),
  );
    final cuadrado = Container(
    width: 350.0,
    height: 350.0,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Color(0xff003FFF)),
  );
  return Stack(
    children: <Widget>[
      fondoModaro,
      Positioned(top: -180.0, left: 100.0, child: cuadrado),
      Positioned(top: -60.0, left: -100.0, child: Transform.rotate(angle: -pi/9 ,child: cuadrado)),
      Positioned(top: -25.0, right: -260.0, child: Transform.rotate(angle: -pi/3 ,child: cuadrado)),
      Positioned(top: 90.0, left: 30.0, child: circulo),
      Positioned(top: -10.0, right: -20.0, child: circulo),
      Positioned(top: 170.0, right: 75.0, child: circulo),
      Positioned(top: 260.0, left: -50.0, child: circulo),
      Positioned(top: -50.0, left: -20.0, child: circulo),
      Container(
        padding: EdgeInsets.only(top: 80.0),
        child: Column(
          children: <Widget>[
            Icon(Icons.supervised_user_circle_rounded, color: Colors.white, size: 100.0),
            SizedBox(height: 10.0, width: double.infinity),
            Text('¡Hola Transportista!',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold))
          ],
        ),
      )
    ],
  );
  }
}
