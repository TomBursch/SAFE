import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:safe/utility/storage.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import './bloc.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final Storage storage;

  SettingsBloc({
    @required this.storage,
  }) : assert(storage != null);

  SettingsState get initialState => SettingsInitial();

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is SettingsUpdateAccount) {
      yield SettingsLoading();
      try {
        var user = await FirebaseAuth.instance.currentUser();
        if (user != null) {
          if (event.email.isNotEmpty) {
            await user.updateEmail(event.email);
            await storage.write(key: "email", value: event.email);
          }
          if (event.name.isNotEmpty) {
            //await user.updateProfile(UserUpdateInfo());
          }
          yield SettingsSuccess();
        } else {
          yield SettingsFailure(error: "not logged in");
        }
      } catch (error) {
        yield SettingsFailure(error: error.toString());
      }
    }
    if (event is SettingsUpdatePassword) {
      yield SettingsLoading();
      try {
        var user = await FirebaseAuth.instance.currentUser();
        if (user != null) {
          if (event.password.isNotEmpty) {
            await user.updatePassword(event.password);
            await storage.write(key: "pw", value: event.password);
          }
          yield SettingsSuccess();
        } else {
          yield SettingsFailure(error: "not logged in");
        }
      } catch (error) {
        yield SettingsFailure(error: error.toString());
      }
    }
  }
}
