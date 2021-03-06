import 'package:flutter/material.dart';
import 'package:formvalidation_app/src/bloc/provider.dart';
import 'package:formvalidation_app/src/providers/usuario_provider.dart';
import 'package:formvalidation_app/src/utils/utlis.dart';

class RegistroPage extends StatelessWidget {
  final usuarioProvider = new UsuarioProvider();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        _crearFondo(context),
        _loginForm(context),
      ],
    ));
  }

  Widget _crearFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final fondomorado = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: <Color>[
        Color.fromRGBO(63, 63, 156, 1.0),
        Color.fromRGBO(90, 70, 178, 1.0)
      ])),
    );

    final circulo = Container(
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Color.fromRGBO(255, 255, 255, 0.05),
        ));

    return Stack(
      children: <Widget>[
        fondomorado,
        Positioned(
          child: circulo,
          top: 10.0,
          left: 300.0,
        ),
        Positioned(
          child: circulo,
          top: 60.0,
          left: 60.0,
        ),
        Positioned(
          child: circulo,
          top: 200.0,
          left: 50.0,
        ),
        Positioned(
          child: circulo,
          top: 220.0,
          right: -10.0,
        ),
        Container(
          padding: EdgeInsets.only(top: 60.0),
          child: Column(children: <Widget>[
            Icon(
              Icons.person_pin_circle,
              color: Colors.white,
              size: 100.0,
            ),
            SizedBox(
              height: 10.0,
              width: double.infinity,
            ),
            Text('Ezequiel Rodriguez',
                style: TextStyle(color: Colors.white, fontSize: 25.0))
          ]),
        )
      ],
    );
  }

  Widget _loginForm(BuildContext context) {
    final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(
              child: Container(
            height: 180.0,
          )),
          Container(
            margin: EdgeInsets.symmetric(vertical: 30.0),
            padding: EdgeInsets.symmetric(vertical: 50.0),
            width: size.width * 0.85,
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
                Text(
                  'Regitrarse',
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(
                  height: 60.0,
                ),
                _crearEmail(bloc),
                SizedBox(
                  height: 30.0,
                ),
                _crearPassword(bloc),
                SizedBox(
                  height: 30.0,
                ),
                _crearBoton(bloc),
              ],
            ),
          ),
          TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
              child: Text('?? Ya tienes cuenta ? Login')),
          SizedBox(
            height: 100.0,
          )
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
                  icon: Icon(
                    Icons.alternate_email,
                    color: Colors.deepPurple,
                  ),
                  hintText: 'ejemplo@correo.com',
                  labelText: 'Correo electronico',
                  counterText: snapshot.data,
                  errorText: snapshot.error != null
                      ? snapshot.error.toString()
                      : null),
              onChanged: bloc.changeEmail,
            ),
          );
        });
  }

  Widget _crearPassword(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon(
                Icons.lock_outline,
                color: Colors.deepPurple,
              ),
              labelText: 'Contrase??a',
              counterText: snapshot.data,
              errorText:
                  snapshot.error != null ? snapshot.error.toString() : null,
            ),
            onChanged: bloc.changePassword,
          ),
        );
      },
    );
  }

  Widget _crearBoton(LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.formValidStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return ElevatedButton(
            onPressed: snapshot.hasData ? () => _register(context, bloc) : null,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
                child: Text(
                  'Registrar',
                  style: TextStyle(color: Colors.white),
                )),
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                elevation: 0.0,
                primary: Colors.deepPurple),
          );
        });
  }

  _register(BuildContext context, LoginBloc bloc) async {
    final info = await usuarioProvider.nuevoUsuario(bloc.email, bloc.password);

    if (info['ok']) {
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      mostrarAlerta(context, info['mensaje']);
    }
  }
}
