import 'package:flutter/material.dart';

class CommonException implements Exception {
  final String? title;
  final String message;
  final int messageType;

  /// @messageType Tipo da mensagem: 0: Toast | 1: Dialog
  CommonException({required this.message, this.title, this.messageType = 0});

  void show(BuildContext context) {
    /*if(messageType == 0) {
      BotToast.showText(
        text: message,
        contentColor: Colors.red,
        duration: const Duration(seconds: 3),
      );
    } else {
      showInfoDialog(context, title: title ?? 'Atenção!', message: message);
    }*/
  }
}