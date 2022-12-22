import 'dart:io';

import 'package:converter_plus_plus/constants/constants.dart';
import 'package:converter_plus_plus/enums/media-type.dart';
import 'package:converter_plus_plus/exceptions/validate-exception.dart';
import 'package:converter_plus_plus/models/media-file.dart';
import 'package:file_picker/file_picker.dart';

class Validate {
  static void validateListMediaFile(List<MediaFile> list) {
    Map<String, List<String>> erros = {};
    List<String> tempList;

    for(var file in list) {
      if(file.output.checked) {
        tempList = validateMediaFile(file, true);
        if(tempList.isNotEmpty) {
          erros[file.fullName] = tempList;
        }
      }
    }

    if(erros.isNotEmpty) {
      throw ValidateException(erros: erros);
    }
  }

  static List<String> validateMediaFile(MediaFile file, [bool isList = false]) {
    List<String> erros = [];

    if(file.output.path.isEmpty) {
      erros.add('Informe a pasta de saída.');
    }

    if(file.output.name.isEmpty) {
      erros.add('Informe o nome de saída.');
    }

    if(file.output.format.extension.isEmpty) {
      erros.add('Informe a extensão de conversão.');
    }

    if([MediaType.image, MediaType.video].contains(file.output.type)) {
      if(file.output.size.width <= 0) {
        erros.add('A largura deve ser maior que 0.');
      }
      if(file.output.size.height <= 0) {
        erros.add('A altura deve ser maior que 0.');
      }
    }

    if(!isList && erros.isNotEmpty) {
      throw ValidateException(erros: {file.fullName: erros});
    }

    return erros;
  }

  static Future<String> fileExists(MediaFile file) async {
    if(await File.fromUri(Uri.parse(file.output.fullPath)).exists()) {
      int fileNumber = 0;
      String newFileName;
      String fullPath;

      while(fileNumber < 2147483647) {
        newFileName = '${file.output.name}_$fileNumber';
        fullPath = '${file.output.path}/$newFileName.${file.output.format.extension}';

        if(!await File.fromUri(Uri.parse(fullPath)).exists()) {
          return newFileName;
        }

        fileNumber++;
      }
    }

    return file.output.name;
  }

  static void validateFilePicked(PlatformFile file, Map stdout) {
    const genericMessage = 'Falha ao carregar arquivo. Verifique se o arquivo é uma mídia de vídeo, áudio ou imagem.';

    if(stdout.isEmpty || !stdout.containsKey('streams')) {
      throw ValidateException(erros: {file.name: [genericMessage]});
    } else {
      if(stdout['streams'].isEmpty) {
        throw ValidateException(erros: {file.name: [genericMessage]});
      } else if(!['video', 'audio'].contains(stdout['streams'][0]['codec_type'])) {
        throw ValidateException(erros: {file.name: [genericMessage]});
      }

      if(excludeFormats.contains(file.extension)) {
        throw ValidateException(erros: {file.name: ['Formato do arquivo não suportado.']});
      }
    }
  }
}