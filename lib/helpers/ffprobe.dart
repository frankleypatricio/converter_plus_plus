import 'dart:convert' show jsonDecode;
import 'dart:io';

import 'package:converter_plus_plus/exceptions/validate-exception.dart';
import 'package:converter_plus_plus/helpers/ffmpeg.dart';
import 'package:converter_plus_plus/helpers/validate.dart';
import 'package:converter_plus_plus/models/media-file.dart';
import 'package:file_picker/file_picker.dart';

class FFprobe {
  final List<PlatformFile> files;
  final Map<String, List<String>> erros = {};

  FFprobe(this.files);

  Future<List<MediaFile>> getMediaFiles() async {
    final List<MediaFile> mediaFiles = [];
    Map<String, dynamic>? tempMedia;

    for(var file in files) {
      tempMedia = await getFileStreams(file.path!, file);
      if(tempMedia != null) {
        mediaFiles.add(MediaFile(file, tempMedia));
      }
    }

    return mediaFiles;
  }

  Future<Map<String, dynamic>?> getFileStreams(String filePath, PlatformFile file) async {
    final streams = await Process.run(
      FFmpegConfig.ffprobePath,
      ['-loglevel', '0', '-print_format', 'json', '-show_streams', '-count_frames', filePath],
    );

    final stdout = jsonDecode(streams.stdout);
    try {
      Validate.validateFilePicked(file, stdout);
    } on ValidateException catch(e) {
      erros.addAll(e.erros);
      return null;
    }

    return stdout['streams'][0];
  }

  void throwErrors() {
    if(erros.isNotEmpty) {
      throw ValidateException(erros: erros);
    }
  }
}