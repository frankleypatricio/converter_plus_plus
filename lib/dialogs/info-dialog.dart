import 'package:converter_plus_plus/enums/dialog-type.dart';
import 'package:converter_plus_plus/theme.dart';
import 'package:flutter/material.dart';

Future<bool> showInfoDialog(BuildContext context, String title, String message, DialogType type) async {
  return await showDialog(context: context, builder: (context) => AlertDialog(
    title: Column(
      children: [
        Icon(type.iconData, color: type.color, size: 110,),
        Text(
          title, textAlign: TextAlign.center,
          style: TextStyle(fontSize: 28, color: type.color),
        ),
      ],
    ),
    content: Text(
      message, textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 18),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context, true),
        child: Text('Ok', style: TextStyle(color: AppTheme.colorScheme.primary, fontSize: 18)),
      ),
    ],
  ));
}