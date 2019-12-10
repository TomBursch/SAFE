import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class SettingsState extends Equatable {
  SettingsState([List props = const []]) : super(props);
}

class SettingsInitial extends SettingsState {
  @override
  String toString() => 'SettingsInitial';
}

class SettingsLoading extends SettingsState {
  @override
  String toString() => 'SettingsLoading';
}

class SettingsFailure extends SettingsState {
  final String error;

  SettingsFailure({@required this.error}) : super([error]);

  @override
  String toString() => 'SettingsFailure { error: $error }';
}

class SettingsSuccess extends SettingsState {
  @override
  String toString() => 'SettingsSuccess';
}