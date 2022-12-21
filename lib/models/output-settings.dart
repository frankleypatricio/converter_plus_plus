import 'dart:convert';

import 'package:converter_plus_plus/enums/media-quality.dart';
import 'package:converter_plus_plus/enums/media-type.dart';
import 'package:converter_plus_plus/enums/replace-file.dart';
import 'package:mobx/mobx.dart';

part 'output-settings.g.dart';

class OutputSettings = _OutputSettings with _$OutputSettings;
abstract class _OutputSettings with Store {
  String path = '';
  String name= '';
  @observable MediaType type;
  @observable MediaFormat format = MediaFormat('Manter', '');
  @observable MediaSize size = MediaSize(MediaQuality.keep, 0, 0);
  String subtitles = '';
  ReplaceFile replaceFile = ReplaceFile.ask;
  @observable bool checked = true;

  String get fullPath => '$path/$name.${format.extension}';

  _OutputSettings({
    required this.type,
    required this.name,
    required this.path,
    required int defaultWidth,
    required int defaultHeight,
    required String defaultExtension,
  }) {
    size.width = defaultWidth;
    size.height = defaultHeight;
    format.extension = defaultExtension;
  }

  @action void setChecked(bool value) => checked = value;

  @action
  void setSize(MediaQuality quality, int width, int height) {
    size = MediaSize(quality, width, height);
  }

  @action
  void setFormat(String key, String extension) {
    format = MediaFormat(key, extension);
  }

  @action
  void setType(MediaType value) => type = value;

  Map toMap() {
    return {
      'path': path,
      'name': name,
      'type': type.descricao,
      'format': {
        'key': format.key,
        'extension': format.extension,
      },
      'size': {
        'quality': size.quality.descricao,
        'width': size.width,
        'height': size.height,
      },
      'checked': checked,
    };
  }
}

class MediaSize {
  MediaQuality quality;
  int width;
  int height;

  MediaSize(this.quality, this.width, this.height);
}

class MediaFormat {
  String key;
  String extension;

  MediaFormat(this.key, this.extension);
}