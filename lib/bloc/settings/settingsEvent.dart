import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import './bloc.dart';

abstract class SettingsEvent extends Equatable {
  SettingsEvent([List props = const []]) : super(props);
}

class SettingsUpdateAccount extends SettingsEvent {
  final String email;
  final String name;

  SettingsUpdateAccount({
    this.email,
    this.name,
  }) : super([name, email]);

  @override
  String toString() =>
      'SettingsUpdateAccount { email: $email }';
}

class SettingsUpdatePassword extends SettingsEvent {
  final String password;

  SettingsUpdatePassword({
    @required this.password,
  }) : super([password]);

  @override
  String toString() =>
      'SettingsUpdatePassword';
}