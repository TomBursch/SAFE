import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:safe/utility/storage.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import '../authentication/bloc.dart';
import './bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Storage storage;

  LoginBloc({
    @required this.storage,
  }) : assert(storage != null);

  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();
      try {
        if (await FirebaseAuth.instance.currentUser() == null &&
            event.email.isNotEmpty &&
            event.password.isNotEmpty) {
          final bool isLoggedin = await FirebaseAuth.instance
                  .signInWithEmailAndPassword(
                      email: event.email, password: event.password) !=
              null;
          if (isLoggedin) {
            await storage.write(key: "email", value: event.email);
            await storage.write(key: "pw", value: event.password);
            yield LoginSuccess();
          } else {
            yield LoginFailure(error: "");
          }
        } else {
          yield LoginFailure(error: "email or password cannot be blank");
        }
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
  }
}
