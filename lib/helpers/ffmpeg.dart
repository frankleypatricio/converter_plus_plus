import 'dart:convert' show jsonDecode;
import 'dart:io' show Process;

import 'package:converter_plus_plus/enums/media-quality.dart';
import 'package:converter_plus_plus/enums/media-type.dart';
import 'package:converter_plus_plus/enums/replace-file.dart';
import 'package:converter_plus_plus/exceptions/validate-exception.dart';
import 'package:converter_plus_plus/helpers/validate.dart';
import 'package:converter_plus_plus/models/media-file.dart';
import 'package:converter_plus_plus/models/output-settings.dart';
import 'package:file_picker/file_picker.dart';

class FFmpeg {
  late final bool single;

  late final MediaFile? file;
  final List<String> arguments = [];

  late final List<MediaFile>? files;
  final List<List<String>> argumentList = [];

  FFmpeg(this.file) {
    files = null;
    single = true;
  }
  FFmpeg.fromList(this.files) {
    file = null;
    single = false;
  }

  void prepareStatement(OutputSettings? output) {
    if(single) {
      _prepareStatement(file!, output);
    } else {
      for(var file in files!) {
        if(file.output.checked) {
          argumentList.add(_prepareStatement(file, output).toList());
        }
      }
    }
  }

  List<String> _prepareStatement(MediaFile file, OutputSettings? gOutput) {
    final output = gOutput ?? file.output;
    arguments.clear();

    // input file url
    arguments.addAll(['-i', file.fullPath]);

    // overwrite output
    arguments.addAll(output.replaceFile.argument);

    if([MediaType.image, MediaType.video].contains(output.type) && output.size.quality != MediaQuality.keep) {
      // output file scale
      arguments.addAll(['-vf', 'scale=${output.scale}']);
    }

    if(output.type == MediaType.video && output.subtitles.isNotEmpty) {
      if(!arguments.contains('-vf')) {
        arguments.add('-vf');
      }

      // output file subtitles
      if(output.subtitles.endsWith('srt')) {
        arguments.add('subtitles=${output.subtitles}');
      } else {
        arguments.add('ass=${output.subtitles}');
      }
    }

    // output file url
    arguments.add(output.fullPath);

    print('arguments: $arguments');
    return arguments;
  }

  Future<void> start() async {
    await Process.run(FFmpegConfig.ffmpegPath, arguments);
  }
}

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
      ['-loglevel', '0', '-print_format', 'json', '-show_streams', filePath],
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

class FFmpegConfig {
  static String ffmpegPath = 'C:/Projetos/_meus-projetos/converter_plus_plus/ffmpeg.exe';
  static String ffprobePath = 'C:/Projetos/_meus-projetos/converter_plus_plus/ffprobe.exe';
}