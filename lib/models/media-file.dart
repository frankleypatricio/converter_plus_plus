import 'dart:convert';

import 'package:converter_plus_plus/constants/constants.dart';
import 'package:converter_plus_plus/enums/media-type.dart';
import 'package:converter_plus_plus/models/output-settings.dart';
import 'package:file_picker/file_picker.dart';

class MediaFile {
  late final String path;
  late final String name;
  late final String extension;
  late final double aspectRatio;
  late final MediaType type;
  late final OutputSettings output;
  late final int width;
  late final int height;

  String get fullName => '$name.$extension';

  MediaFile.teste() {
    path = 'D:\\Pictures\\Airship.jpg';
    name = 'Airship';
    extension = 'jpg';
    type = MediaType.image;
    aspectRatio = 16/9;
    width = 1920;
    height = 1080;

    output = OutputSettings(
      type: type,
      name: name,
      path: path,
      defaultWidth: width,
      defaultHeight: height,
      defaultExtension: extension,
    );
  }
  MediaFile(PlatformFile file, Map<String, dynamic> streams) {
    path = file.path!;
    extension = file.extension!;
    name = file.name.replaceAll('.$extension', '');
    width = streams['width'];
    height = streams['height'];

    if(streams['codec_type'] == 'audio') {
      type = MediaType.audio;
    } else {
      type = streams.containsKey('nb_frames') ? MediaType.video : MediaType.image;
      aspectRatio = width/height;
    }

    output = OutputSettings(
      type: type,
      name: name,
      path: path,
      defaultWidth: width,
      defaultHeight: height,
      defaultExtension: extension,
    );
  }

  List<MediaType> getConversionTypes() {
    switch(type) {
      case MediaType.video:
        return [MediaType.video, MediaType.audio];
      case MediaType.icon:
      case MediaType.image:
        return [MediaType.image, MediaType.icon];
      case MediaType.audio:
        return [MediaType.audio];
    }
  }

  List<String> getConversionFormats() {
    final list = extensions[output.type.value]!.toList();
    if(type == output.type) {
      list.insert(0, 'Manter');
    }
    if(output.type != MediaType.icon) {
      list.add('Customizado');
    }
    return list;
  }

  @override
  String toString() {
    return jsonEncode({
      'path': path,
      'name': name,
      'extension': extension,
      'aspectRatio': aspectRatio,
      'type': type.descricao,
      'size': '$width / $height',
      'output': output.toMap(),
    });
  }
}