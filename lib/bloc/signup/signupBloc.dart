import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:safe/utility/storage.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import './bloc.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final Storage storage;

  SignupBloc({
    @required this.storage,
  }) : assert(storage != null);

  SignupState get initialState => SignupInitial();

  @override
  Stream<SignupState> mapEventToState(SignupEvent event) async* {
    if (event is SignupButtonPressed) {
      yield SignupLoading();
      try {
        if (event.email.isNotEmpty &&
            event.password.isNotEmpty &&
            event.password == event.passwordRepeat &&
            event.name.isNotEmpty) {
          final FirebaseUser user =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: event.email,
            password: event.password,
          );
          if (user != null) {
            await storage.write(key: "email", value: event.email);
            await storage.write(key: "pw", value: event.password);
            var update = UserUpdateInfo();
            update.displayName = event.name;
            await user.updateProfile(update);
            yield SignupSuccess();
          } else {
            yield SignupFailure(error: "");
          }
        }
      } catch (error) {
        yield SignupFailure(error: error.toString());
      }
    }
  }
}
