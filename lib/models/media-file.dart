import 'package:converter_plus_plus/enums/media-type.dart';
import 'package:converter_plus_plus/models/output-settings.dart';
import 'package:file_picker/file_picker.dart';

class MediaFile {
  late final String path;
  late final String name;
  late final String extension;
  late final MediaType type;
  OutputSettings output = OutputSettings();

  MediaFile(PlatformFile file, Map<String, dynamic> streams) {
    path = file.path!;
    name = file.name;
    extension = file.extension!;
    type = MediaType.video;
  }
}