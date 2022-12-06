import 'package:converter_plus_plus/theme.dart';
import 'package:flutter/material.dart';

class Styles {
  static OutlineInputBorder get outlineInputFormBorder => OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: BorderSide(color: AppTheme.colorScheme.primary),
  );

  static InputDecoration inputFormDecoration(String label, IconData? icon, {VoidCallback? onCopy}) => InputDecoration(
    labelText: label,
    prefixIcon: icon != null ? Icon(icon, color: AppTheme.colorScheme.primary) : null,
    suffixIcon: onCopy != null ? IconButton(
      onPressed: onCopy,
      icon: const Icon(Icons.copy_rounded, color: Colors.blue),
    ) : null
  );

  static TextStyle get textFormStyle => TextStyle(
    color: AppTheme.colorScheme.primary,
  );

  static TextStyle get textOnPrimaryStyle => TextStyle(
    color: AppTheme.colorScheme.onPrimary,
  );

  static TextStyle get textOnBackgroundStyle => TextStyle(
    color: AppTheme.colorScheme.onBackground,
  );

  static BoxDecoration get roundedBoxDecoration => BoxDecoration(
    border: Border.all(color: AppTheme.colorScheme.primary, width: 2),
    borderRadius: BorderRadius.circular(30)
  );

  static ButtonStyle roundedOutlinedButtonStyle([Color? color]) => OutlinedButton.styleFrom(
    side: BorderSide(width: 2, color: color ?? AppTheme.colorScheme.primary),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
  );

  static TextStyle dialogButtonTextStyle([Color? color]) => TextStyle(
    fontSize: 16,
    color: color ?? AppTheme.colorScheme.primary
  );
}