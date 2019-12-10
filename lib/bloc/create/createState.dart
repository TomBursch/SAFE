import 'package:equatable/equatable.dart';

abstract class CreateState extends Equatable {
  CreateState([List props = const []]) : super(props);
}

class CreateInitial extends CreateState {}

class CreateSuccess extends CreateState {}

class CreateFailure extends CreateState {
  final String errorMessage;

  CreateFailure(this.errorMessage) : super([errorMessage]);
}
