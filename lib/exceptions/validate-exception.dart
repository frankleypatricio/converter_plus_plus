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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              key, style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            for(var v in value)
              Text('    • $v', style: const TextStyle(
                fontSize: 16,
              )),
          ],
        )
      );
    });

    return await showDialog(context: context, builder: (context) => Dialog(
      backgroundColor: AppTheme.colorScheme.background,
      child: Container(
        width: 700,
        height: 500,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              children: [
                Text('Falha ao converter arquivo(s)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.colorScheme.primary,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Divider(color: AppTheme.colorScheme.primary.withOpacity(.6)),

                Align(
                  alignment: Alignment.centerLeft,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: children,
                    ),
                  ),
                ),
              ],
            ),

            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Ok', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    ));
  }
}