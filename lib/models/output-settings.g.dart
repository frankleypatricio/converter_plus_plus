// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'output-settings.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$OutputSettings on _OutputSettings, Store {
  late final _$typeAtom = Atom(name: '_OutputSettings.type', context: context);

  @override
  MediaType get type {
    _$typeAtom.reportRead();
    return super.type;
  }

  @override
  set type(MediaType value) {
    _$typeAtom.reportWrite(value, super.type, () {
      super.type = value;
    });
  }

  late final _$formatAtom =
      Atom(name: '_OutputSettings.format', context: context);

  @override
  MediaFormat get format {
    _$formatAtom.reportRead();
    return super.format;
  }

  @override
  set format(MediaFormat value) {
    _$formatAtom.reportWrite(value, super.format, () {
      super.format = value;
    });
  }

  late final _$sizeAtom = Atom(name: '_OutputSettings.size', context: context);

  @override
  MediaSize get size {
    _$sizeAtom.reportRead();
    return super.size;
  }

  @override
  set size(MediaSize value) {
    _$sizeAtom.reportWrite(value, super.size, () {
      super.size = value;
    });
  }

  late final _$checkedAtom =
      Atom(name: '_OutputSettings.checked', context: context);

  @override
  bool get checked {
    _$checkedAtom.reportRead();
    return super.checked;
  }

  @override
  set checked(bool value) {
    _$checkedAtom.reportWrite(value, super.checked, () {
      super.checked = value;
    });
  }

  late final _$conversionResultsAtom =
      Atom(name: '_OutputSettings.conversionResults', context: context);

  @override
  ConversionResults? get conversionResults {
    _$conversionResultsAtom.reportRead();
    return super.conversionResults;
  }

  @override
  set conversionResults(ConversionResults? value) {
    _$conversionResultsAtom.reportWrite(value, super.conversionResults, () {
      super.conversionResults = value;
    });
  }

  late final _$_OutputSettingsActionController =
      ActionController(name: '_OutputSettings', context: context);

  @override
  void setChecked(bool value) {
    final _$actionInfo = _$_OutputSettingsActionController.startAction(
        name: '_OutputSettings.setChecked');
    try {
      return super.setChecked(value);
    } finally {
      _$_OutputSettingsActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setConversionResults(bool success,
      [String message = 'Conversão concluída com sucesso.']) {
    final _$actionInfo = _$_OutputSettingsActionController.startAction(
        name: '_OutputSettings.setConversionResults');
    try {
      return super.setConversionResults(success, message);
    } finally {
      _$_OutputSettingsActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSize(MediaQuality quality, int width, int height) {
    final _$actionInfo = _$_OutputSettingsActionController.startAction(
        name: '_OutputSettings.setSize');
    try {
      return super.setSize(quality, width, height);
    } finally {
      _$_OutputSettingsActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFormat(String key, String extension) {
    final _$actionInfo = _$_OutputSettingsActionController.startAction(
        name: '_OutputSettings.setFormat');
    try {
      return super.setFormat(key, extension);
    } finally {
      _$_OutputSettingsActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setType(MediaType value) {
    final _$actionInfo = _$_OutputSettingsActionController.startAction(
        name: '_OutputSettings.setType');
    try {
      return super.setType(value);
    } finally {
      _$_OutputSettingsActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
type: ${type},
format: ${format},
size: ${size},
checked: ${checked},
conversionResults: ${conversionResults}
    ''';
  }
}
