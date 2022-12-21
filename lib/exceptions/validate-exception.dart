import 'package:converter_plus_plus/theme.dart';
import 'package:flutter/material.dart';

class ValidateException implements Exception {
  final Map<String, List<String>> erros;

  ValidateException({required this.erros});

  Future<void> show(BuildContext context) async {
    final List<Widget> children = [];

    erros.forEach((key, value) {
      children.add(
        Column(
          children: [
            Text(
            key, style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          for(var v in value)
            Text('      • $v', style: const TextStyle(
              fontSize: 16,
            )),
          ],
        )
      );
    });

    return await showDialog(context: context, builder: (context) => AlertDialog(
      backgroundColor: AppTheme.colorScheme.background,
      title: Text('Falha ao converter arquivo(s)',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppTheme.colorScheme.primary,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),

      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: const Text('Ok'),
        ),
      ],
    ));
  }
}