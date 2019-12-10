import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  SignupEvent([List props = const []]) : super(props);
}

class SignupButtonPressed extends SignupEvent {
  final String name;
  final String email;
  final String password;
  final String passwordRepeat;

  SignupButtonPressed({
    @required this.name,
    @required this.email,
    @required this.password,
    @required this.passwordRepeat,
  }) : super([name, email, password, passwordRepeat]);

  @override
  String toString() =>
      'SignupButtonPressed { username: $email, password: $password }';
}