enum MediaQuality {
  keep, q144, q240, q360, q480, q720, q1080, custom
}
extension MediaQualityExtension on MediaQuality {
  String get descricao {
    switch (this) {
      case MediaQuality.keep:
      return 'Manter';
      case MediaQuality.q144:
        return '144p';
      case MediaQuality.q240:
        return '240p';
      case MediaQuality.q360:
        return '360p';
      case MediaQuality.q480:
        return '480p';
      case MediaQuality.q720:
        return '720p';
      case MediaQuality.q1080:
        return '1080p';
      case MediaQuality.custom:
        return 'Customizado';
    }
  }

  int get valor {
    switch (this) {
      case MediaQuality.q144:
        return 144;
      case MediaQuality.q240:
        return 240;
      case MediaQuality.q360:
        return 360;
      case MediaQuality.q480:
        return 480;
      case MediaQuality.q720:
        return 720;
      case MediaQuality.q1080:
        return 1080;
      default:
        return 0;
    }
  }
}