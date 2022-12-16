import 'package:flutter/material.dart' show IconData;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum MediaType {
  image, audio, video, icon
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
      case MediaType.icon:
        return 'icon';
    }
  }

  String get descricao {
    switch (this) {
      case MediaType.image:
        return 'Imagem';
      case MediaType.audio:
        return 'Áudio';
      case MediaType.video:
        return 'Vídeo';
      case MediaType.icon:
        return 'Ícone';
    }
  }

  IconData get icon {
    switch (this) {
      case MediaType.video:
        return FontAwesomeIcons.solidFileVideo;
      case MediaType.icon:
      case MediaType.image:
        return FontAwesomeIcons.solidFileImage;
      case MediaType.audio:
        return FontAwesomeIcons.solidFileAudio;
    }
  }
}