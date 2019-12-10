import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safe/bloc/bloc.dart';
import 'package:safe/pages/home.dart';
import 'package:safe/style/theme.dart';

import 'pages/login.dart';
import 'pages/splashScreen.dart';
import 'utility/storage.dart';
import 'package:flutter/services.dart'
    show SystemChrome, SystemUiOverlayStyle, rootBundle;

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.dark,
  ));
  runApp(SafeApp());
}

class SafeApp extends StatefulWidget {
  static final Storage storage = Storage();
  static String mapStyle = "";
  static LatLng lastLocation = LatLng(37.43296265331129, -122.08832357078792);

  @override
  _SafeAppState createState() => _SafeAppState();
}

class _SafeAppState extends State<SafeApp> {
  AuthenticationBloc _authenticationBloc;
  SettingsBloc _settingsBloc;

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/mapStyle.txt').then((result) {
      SafeApp.mapStyle = result;
    });
    _authenticationBloc = AuthenticationBloc(storage: SafeApp.storage);
    _settingsBloc = SettingsBloc(storage: SafeApp.storage);

    _authenticationBloc.dispatch(AppStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProviderTree(
      blocProviders: [
        BlocProvider<SettingsBloc>(bloc: _settingsBloc),
        BlocProvider<AuthenticationBloc>(
          bloc: _authenticationBloc,
        )
      ],
      child: MaterialApp(
        title: 'S.A.F.E',
        theme: SafeTheme.dark,
        home: BlocBuilder<AuthenticationEvent, AuthenticationState>(
          bloc: _authenticationBloc,
          builder: (context, state) {
            if (state is AuthenticationAuthenticated) {
              return HomePage();
            } else if (state is AuthenticationUnauthenticated) {
              return LoginPage();
            }
            return SplashScreen();
          },
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  @override
  void dispose() {
    _authenticationBloc.dispose();
    _settingsBloc.dispose();
    super.dispose();
  }
}
