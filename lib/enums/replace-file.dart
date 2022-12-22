enum ReplaceFile {
  ask, replace, notReplace
}
extension ReplaceFileExtension on ReplaceFile {
  int get value {
    switch (this) {
      case ReplaceFile.ask:
        return 0;
      case ReplaceFile.replace:
        return 1;
      case ReplaceFile.notReplace:
        return 2;
    }
  }

  String get descricao {
    switch (this) {
      case ReplaceFile.ask:
        return 'Perguntar antes de substituir';
      case ReplaceFile.replace:
        return 'Substituir sem perguntar';
      case ReplaceFile.notReplace:
        return 'Manter os dois arquivos';
    }
  }

  List<String> get argument {
    switch (this) {
      case ReplaceFile.ask:
        return [];
      case ReplaceFile.replace:
        return ['-y'];
      case ReplaceFile.notReplace:
        return ['-n'];
    }
  }
}