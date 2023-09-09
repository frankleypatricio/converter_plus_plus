import 'package:flutter/material.dart';

class AppTheme {
  static const colorScheme = ColorScheme.dark(
    primary: Color(0xff4FEDA9),
    secondary: Color(0xFF3D3F43),
    onPrimary: Color(0xFF3D3F43),
  );

  final disabled = Colors.grey;

  ThemeData get theme => ThemeData.dark().copyWith(
    primaryColor: colorScheme.primary,
    colorScheme: colorScheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: elevatedButtonStyle()
    ),
    appBarTheme: appBarTheme(),
    iconTheme: iconTheme(),
    textTheme: textTheme(),
    bottomAppBarTheme: bottomAppBarTheme(),
    inputDecorationTheme: inputDecorationTheme,
  );

  InputDecorationTheme get inputDecorationTheme => InputDecorationTheme(
    labelStyle: TextStyle(color: colorScheme.primary),
    iconColor: colorScheme.primary,
    prefixIconColor: colorScheme.primary,
    border: outlineInputFormBorder,
    enabledBorder: outlineInputFormBorder,
    focusedBorder: outlineInputFormBorder,
    suffixIconColor: colorScheme.primary,
  );
  OutlineInputBorder get outlineInputFormBorder => OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: colorScheme.primary),
  );

  ButtonStyle elevatedButtonStyle() => ButtonStyle(
    backgroundColor: MaterialStateProperty.all(colorScheme.primary),
    padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 18, horizontal: 8)),
    /*shape: MaterialStateProperty.all(RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    )),*/
    textStyle: MaterialStateProperty.all(const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
    )),
  );

  AppBarTheme appBarTheme() => AppBarTheme(
    backgroundColor: colorScheme.primary,
    titleTextStyle: TextStyle(
      color: colorScheme.onPrimary,
      fontWeight: FontWeight.w500,
      fontSize: 20
    ),
    iconTheme: IconThemeData(
      color: colorScheme.onPrimary,
      size: 20
    ),
  );

  IconThemeData iconTheme() => IconThemeData(
    color: colorScheme.primary,
  );

  TextTheme textTheme() => TextTheme(
    bodyLarge: TextStyle(color: colorScheme.onBackground, fontSize: 20, fontWeight: FontWeight.w600),
    bodyMedium: TextStyle(color: colorScheme.onBackground),
  );

  BottomAppBarTheme bottomAppBarTheme() => BottomAppBarTheme(
    color: colorScheme.secondary,
    elevation: 0,
    shape: const CircularNotchedRectangle(),
  );
}