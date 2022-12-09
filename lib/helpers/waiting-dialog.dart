import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<void> showWaitingDialog(BuildContext context, {required AsyncCallback operation}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(.85),
    builder: (_) => WillPopScope(
      onWillPop: () => Future(() => false),
      child: Container(),
    ),
  );

  try {
    await operation();
  }catch(_){}
  Navigator.pop(context);
}