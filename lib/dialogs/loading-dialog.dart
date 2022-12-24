import 'package:converter_plus_plus/exceptions/validate-exception.dart';
import 'package:converter_plus_plus/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<void> showLoadingDialog(BuildContext context, {required AsyncCallback operation, double? size}) async {
  FocusScope.of(context).unfocus();
  showDialog(
    barrierDismissible: false,
    context: context,
    barrierColor: Colors.black.withOpacity(.85),
    builder: (_) => WillPopScope( //Previnir que o Dialog feche ao aperter botão de Back
      onWillPop: () => Future(() => false),
      child: Dialog(
        elevation: 0,
        child: Container(
          width: 350,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 35),
          child: Row(
            children: [
              CircularProgressIndicator(color: AppTheme.colorScheme.primary),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Text('Aguarde...', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  try {
    await operation();
    Navigator.pop(context);
  } on ValidateException catch (e,s) {
    print('Erro: $s');
    Navigator.pop(context); // Fechando showDialog
    e.show(context);
  } catch (e,s) {
    print('Erro: $e\n$s');
    /*final appError = AppError.withMessage(e.toString().replaceAll('Exception: ', ''));
    Navigator.pop(context); // Fechando showDialog
    errorScreen(context, appError: appError);*/
  }
}