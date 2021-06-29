import 'package:flutter/material.dart';
import 'package:formvalidation_app/src/bloc/login_bloc.dart';
export 'package:formvalidation_app/src/bloc/login_bloc.dart';

class Provider extends InheritedWidget {
  static Provider? _instancia;

  factory Provider({Key? key, required Widget child}) {
    if (_instancia == null) {
      _instancia = new Provider._internal(
        key: key,
        child: child,
      );
    }
    return _instancia!;
  }

  Provider._internal({Key? key, required child})
      : super(key: key, child: child);

  // Provider({Key? key, required Widget child})
  //     : super(
  //         key: key,
  //         child: child,
  //       );
  final loginBloc = LoginBloc();
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  static LoginBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>()!.loginBloc;
  }
}
