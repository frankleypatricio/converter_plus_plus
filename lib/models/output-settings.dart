import 'package:converter_plus_plus/enums/media-quality.dart';
import 'package:mobx/mobx.dart';

part 'output-settings.g.dart';

class OutputSettings = _OutputSettings with _$OutputSettings;
abstract class _OutputSettings with Store {
  String path = '';
  String extension = '';
  String name= '';
  MediaSize? size;
  String subtitles = '';
}

class MediaSize {
  MediaQuality quality;
  int width;
  int height;

  MediaSize(this.quality, this.width, this.height);
}