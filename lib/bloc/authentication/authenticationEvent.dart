import 'package:firebase_auth/firebase_auth.dart';
import 'package:safe/utility/storage.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  AuthenticationEvent([List props = const []]) : super(props);
}

class AppStarted extends AuthenticationEvent {
  @override
  String toString() => 'AppStarted';
}

class AuthenticationUpdated extends AuthenticationEvent {
  final FirebaseUser user;

  AuthenticationUpdated(this.user);

  @override
  String toString() => 'update';
}

class AuthenticationLogout extends AuthenticationEvent {}

class AuthenticationDelete extends AuthenticationLogout {}
