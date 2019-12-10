import 'dart:async';

import 'package:safe/models/models.dart';
import 'package:safe/utility/storage.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './bloc.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final Storage storage;
  StreamSubscription<FirebaseUser> _subscription;

  AuthenticationBloc({@required this.storage}) : assert(storage != null) {
    _subscription = FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      dispatch(AuthenticationUpdated(user));
    });
  }

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      String email = await storage.read(key: "email");
      String pw = await storage.read(key: "pw");
      if (email != null && pw != null)
        FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: pw,
        );
    }

    if (event is AuthenticationUpdated) {
      if (event.user != null) {
        yield AuthenticationAuthenticated(
          user: User(
            email: event.user.email ?? "No email found",
            name: event.user.displayName ?? "No display name set",
            picture: event.user.photoUrl ??
                "http://blog.tofte-it.dk/wp-content/uploads/2018/12/profile-picture.png",
            id: event.user.uid,
          ),
        );
      } else {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is AuthenticationLogout) {
      if (event is AuthenticationDelete) {
        (await FirebaseAuth.instance.currentUser()).delete();
      } else
        FirebaseAuth.instance.signOut();
      await storage.delete(key: "email");
      await storage.delete(key: "pw");
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
