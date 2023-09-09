import 'dart:convert' show jsonDecode, utf8;
import 'dart:io';

import 'package:converter_plus_plus/dialogs/confirm-dialog.dart';
import 'package:converter_plus_plus/enums/media-quality.dart';
import 'package:converter_plus_plus/enums/media-type.dart';
import 'package:converter_plus_plus/enums/replace-file.dart';
import 'package:converter_plus_plus/exceptions/validate-exception.dart';
import 'package:converter_plus_plus/helpers/validate.dart';
import 'package:converter_plus_plus/models/media-file.dart';
import 'package:converter_plus_plus/models/output-settings.dart';
import 'package:converter_plus_plus/models/progress-controller.dart';
import 'package:converter_plus_plus/theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class FFmpeg {
  final delay = const Duration(milliseconds: 500);

  late final bool single;
  late final ProgressController _progressController;
  Process? _process;
  String? _conversionFormat;

  late final MediaFile? file;
  final List<String> arguments = [];

  late final List<MediaFile>? files;
  final List<List<String>> argumentList = [];


  FFmpeg(this.file) {
    files = null;
    single = true;
    _progressController = ProgressController(1);
  }
  FFmpeg.fromList(this.files) {
    file = null;
    single = false;
    // _progressController = ProgressController(5);
    _progressController = ProgressController(files!.length);
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
    _conversionFormat = gOutput?.format.extension;
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

  Future<void> start(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () => Future(() => false),
        child: FutureBuilder(
          future: _start(context),
          builder: (context, _) {
            return Dialog(
              child: Container(
                width: 450,
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  children: [
                    const Text('Convertendo...', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
                    const Divider(),
                    const SizedBox(height: 36),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Positioned(
                              top: 30,
                              width: 96,
                              child: Column(
                                children: [
                                  Observer(
                                    builder: (_) {
                                      return Text(
                                        '${_progressController.progress}/${_progressController.total}',
                                        style: const TextStyle(fontSize: 22),
                                        textAlign: TextAlign.center,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 96,
                              width: 96,
                              child: Observer(
                                builder: (_) {
                                  return CircularProgressIndicator(
                                    value: _progressController.progressBarValue,
                                    strokeWidth: 6,
                                    backgroundColor: Colors.grey,
                                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.colorScheme.primary),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          Observer(
                            builder: (_) {
                              return Text(
                                'Convertendo o arquivo ${_progressController.message}...',
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              );
                            },
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: LinearProgressIndicator(),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () async {
                                if(await showConfirmDialog(context, 'Cancelar todo o processo de conversão?')) {
                                  _process!.kill();
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text('Cancelar', style: TextStyle(color: Colors.red, fontSize: 18)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        ),
      ),
    );
  }

  Future<void> _start(BuildContext context) async {
    /*while(_progressController.progress < 5) {
      _progressController.setMessage('file${_progressController.progress}.png');
      await Future.delayed(const Duration(seconds: 5));
      _progressController.incrementProgress();
    }*/

    //TODO: Depois, melhorar essa lógica
    int exitCode;
    if(single) {
      exitCode = await _run(arguments);

      if(exitCode == 0) {
        file!.output.setConversionResults(true);

      } else if(exitCode == 1) {
        file!.output.setConversionResults(false,
          'Não foi possível converter o formato ${file!.extension}'
          'para ${_conversionFormat ?? file!.output.format.extension}.',
        );

      } else { // -1
        file!.output.setConversionResults(false,
          'Conversão cancelada antes da conclusão.',
        );
        //TODO: Deletar aquivo que ficou de lixo ao cancelar conversão
      }

    } else {
      for(var args in argumentList) {
        exitCode = await _run(args);

        if(exitCode == 0) {
          file!.output.setConversionResults(true);

        } else if(exitCode == 1) {
          file!.output.setConversionResults(false,
            'Não foi possível converter o formato ${file!.extension}'
            'para ${_conversionFormat ?? file!.output.format.extension}.',
          );

        } else { // -1
          file!.output.setConversionResults(false,
            'Conversão cancelada antes da conclusão.',
          );
          break;
        }

        await Future.delayed(delay);
      }
    }

    await Future.delayed(delay);
    print('saindo _start...');
    Navigator.pop(context);
  }

  Future<int> _run(List<String> arguments) async {
    _process = await Process.start(
      FFmpegConfig.ffmpegPath, arguments,
      mode: ProcessStartMode.inheritStdio,
    );

    final exitCode = await _process!.exitCode;
    stdout.flush();

    print('saindo _run...');
    return exitCode;
  }

  Future<void> test() async {
    print('Running...');
    /*final result = Process.runSync(FFmpegConfig.ffmpegPath, ['-i', 'D:\\Videos\\Captures\\teste.mp4', '-y', 'D:\\Videos\\Captures\\cc.mkv']);
    result.pid
    print('result: ${result.stdout}');*/
    _process = await Process.start(
      FFmpegConfig.ffmpegPath, ['-i', 'D:\\Videos\\Captures\\teste.mp4', '-y', 'D:\\Videos\\Captures\\cc.mkv'],
      mode: ProcessStartMode.inheritStdio,
    );

    Future.delayed(const Duration(seconds: 5)).then((value) {
      _process!.kill();
      print('killed');
    });

    print('exit code: ${await _process!.exitCode}');
    stdout.flush();
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
  static String ffmpegPath = 'D:/htdocs/Flutter Projects/converter_plus_plus/ffmpeg.exe';
  static String ffprobePath = 'D:/htdocs/Flutter Projects/converter_plus_plus/ffprobe.exe';
}