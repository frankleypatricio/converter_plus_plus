import 'package:converter_plus_plus/models/list-files-store.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:converter_plus_plus/theme.dart';
import 'package:flutter/material.dart';

class HomeMixin {
  final ListFilesStore listFiles = ListFilesStore();
  List<String> conversionFormats = [];
  bool convertAll = true;
  bool useSameSettings = false;
  final boxDecoration = BoxDecoration(
    border: Border.all(color: AppTheme.colorScheme.primary, width: 1),
    borderRadius: BorderRadius.circular(10),
  );


  // Controllers
  final widthController = TextEditingController();
  final heightController = TextEditingController();
  final extController = TextEditingController();
  final pathController = TextEditingController();
  final subtitleController = TextEditingController();
  final nomeController = TextEditingController();

  Widget emptyForm() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(FontAwesomeIcons.solidFileVideo, size: 200),
          const SizedBox(height: 24),
          Text(
            'Aqui aparecerão as configurações do arquivo selecionado na lista ao lado',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.colorScheme.primary, fontSize: 32),
          ),
        ],
      ),
    );
  }

  Widget emptyList() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.note_add_rounded, size: 240),
          const SizedBox(height: 24),
          Text(
            'Adicione arquivos clicando no botão abaixo',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.colorScheme.primary, fontSize: 32),
          ),
        ],
      ),
    );
  }
}