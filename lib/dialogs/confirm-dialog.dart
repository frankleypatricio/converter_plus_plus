import 'package:flutter/material.dart';

Future<bool> showConfirmDialog(BuildContext context, String message) async {
  return await showDialog(context: context, builder: (context) => AlertDialog(
    title: const SizedBox(
      width: 110, height: 110,
      child: CircleAvatar(
        backgroundColor: Colors.blue,
        child: Icon(Icons.question_mark_rounded, color: Colors.white, size: 75,),
      ),
    ),
    content: Text(
      message, textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 22),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context, false),
        child: const Text('Não', style: TextStyle(color: Colors.red, fontSize: 18)),
      ),
      TextButton(
        onPressed: () => Navigator.pop(context, true),
        child: const Text('Sim', style: TextStyle(color: Colors.green, fontSize: 18)),
      ),
    ],
  ));
}