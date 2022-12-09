import 'package:flutter/material.dart' show IconData;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum MediaType {
  image, audio, video
}
extension MediaTypeExtension on MediaType {
  String get value {
    switch (this) {
      case MediaType.image:
        return 'image';
      case MediaType.audio:
        return 'audio';
      case MediaType.video:
        return 'vídeo';
    }
  }

  String get descricao {
    switch (this) {
      case MediaType.image:
        return 'imagem';
      case MediaType.audio:
        return 'áudio';
      case MediaType.video:
        return 'vídeo';
    }
  }

  IconData get icon {
    switch (this) {
      case MediaType.image:
        return FontAwesomeIcons.solidFileImage;
      case MediaType.audio:
        return FontAwesomeIcons.solidFileAudio;
      case MediaType.video:
        return FontAwesomeIcons.solidFileVideo;
    }
  }
}