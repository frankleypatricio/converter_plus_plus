import 'package:flutter/material.dart';

class ConversionResults {
  final bool success;
  final String message;

  ConversionResults(this.success, this.message);

  Tooltip get tooltip => Tooltip(
    message: message,
    child: success
        ? const Icon(Icons.check_circle, color: Colors.green)
        : const Icon(Icons.warning_rounded, color: Colors.deepOrange)
  );

  void showDetails() {
    //todo: CRIAR UM ALERT COM DETALHES DA CONVERSÃO
  }
}