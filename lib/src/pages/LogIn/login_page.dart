import 'package:flutter/material.dart';
import 'package:proyectounderway/src/bloc/provider.dart';
import 'package:proyectounderway/src/pages/LogIn/background_page.dart';
import 'package:proyectounderway/src/providers/usuario_provider.dart';
import 'package:proyectounderway/src/utils/utils.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool hidePassword = true;
  final usuarioProvider = new UsuarioProvider();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[CrearFondo(), _loginForm(context)],
    ));
  }

  Widget _crearBoton(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return RaisedButton(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
              child: Text('Ingresar'),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            elevation: 0.0,
            color: Color(0xff003FFF),
            textColor: Colors.white,
            onPressed: snapshot.hasData ? () => _login(bloc, context) : null);
      },
    );
  }

  _login(LoginBloc bloc, BuildContext context) async {
    Map info = await usuarioProvider.login(bloc.email, bloc.password);
    if (info['ok']) {
      Navigator.pushNamed(context, 'home');
    } else {
      mostrarAlerta(context, info['mensaje']);
    }
  }

  Widget _loginForm(BuildContext context) {
    final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(
            child: Container(
              height: 190.0,
            ),
          ),
          Container(
            width: size.width * 0.85,
            margin: EdgeInsets.symmetric(vertical: 30.0),
            padding: EdgeInsets.symmetric(vertical: 50.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3.0,
                      offset: Offset(0.0, 5.0),
                      spreadRadius: 3.0)
                ]),
            child: Column(
              children: <Widget>[
                Text('Iniciar Sesión',
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Color(0xff003FFF),
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 20.0),
                _crearEmail(bloc),
                SizedBox(height: 30.0),
                _crearPassword(bloc),
                SizedBox(height: 30.0),
                _crearBoton(bloc)
              ],
            ),
          ),
          TextButton(
              child: Text('Crear una nueva cuenta'),
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, 'registro')),
          SizedBox(height: 100.0)
        ],
      ),
    );
  }

  Widget _crearEmail(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                icon: Icon(Icons.mail_outline, color: Color(0xff003FFF)),
                hintText: 'ejemplo@correo.com',
                labelText: 'Correo electrónico',
                counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeEmail,
          ),
        );
      },
    );
  }

  Widget _crearPassword(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: hidePassword,
            decoration: InputDecoration(
              icon: Icon(Icons.lock_outline, color: Color(0xff003FFF)),
              labelText: 'Contraseña',
              counterText: snapshot.data,
              errorText: snapshot.error,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    hidePassword = !hidePassword;
                  });
                },
                icon: Icon(
                    hidePassword ? Icons.visibility_off : Icons.visibility),
              ),
            ),
            onChanged: bloc.changePassword,
          ),
        );
      },
    );
  }
}
