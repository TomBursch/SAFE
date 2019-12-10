import 'package:flutter/material.dart';
import 'package:safe/style/colors.dart';

class SafeTheme {
  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: SafeColors.darkCoral,
    accentColor: SafeColors.portlandOrange,
    backgroundColor: SafeColors.charcoal,
    scaffoldBackgroundColor: SafeColors.charcoal,
    canvasColor: SafeColors.darkCoral,
    inputDecorationTheme: defaultInputDecorationTheme,
    buttonTheme: defaultButtonTheme,
  );

  static ButtonThemeData defaultButtonTheme = ButtonThemeData(
    buttonColor: SafeColors.portlandOrange,
    height: 46,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
  );

  static InputDecorationTheme defaultInputDecorationTheme =
      InputDecorationTheme(
    contentPadding: EdgeInsets.fromLTRB(15, 15.0, 15, 15.0),
    hasFloatingPlaceholder: false,
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        gapPadding: 1,
        borderSide: BorderSide(color: SafeColors.portlandOrange, width: 2)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        gapPadding: 1,
        borderSide: BorderSide(color: SafeColors.portlandOrange, width: 3)),
  );
}
