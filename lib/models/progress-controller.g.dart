// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress-controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProgressController on _ProgressController, Store {
  Computed<double>? _$progressBarValueComputed;

  @override
  double get progressBarValue => (_$progressBarValueComputed ??=
          Computed<double>(() => super.progressBarValue,
              name: '_ProgressController.progressBarValue'))
      .value;

  late final _$messageAtom =
      Atom(name: '_ProgressController.message', context: context);

  @override
  String get message {
    _$messageAtom.reportRead();
    return super.message;
  }

  @override
  set message(String value) {
    _$messageAtom.reportWrite(value, super.message, () {
      super.message = value;
    });
  }

  late final _$progressAtom =
      Atom(name: '_ProgressController.progress', context: context);

  @override
  int get progress {
    _$progressAtom.reportRead();
    return super.progress;
  }

  @override
  set progress(int value) {
    _$progressAtom.reportWrite(value, super.progress, () {
      super.progress = value;
    });
  }

  late final _$totalAtom =
      Atom(name: '_ProgressController.total', context: context);

  @override
  int get total {
    _$totalAtom.reportRead();
    return super.total;
  }

  @override
  set total(int value) {
    _$totalAtom.reportWrite(value, super.total, () {
      super.total = value;
    });
  }

  late final _$_ProgressControllerActionController =
      ActionController(name: '_ProgressController', context: context);

  @override
  void setMessage(String value) {
    final _$actionInfo = _$_ProgressControllerActionController.startAction(
        name: '_ProgressController.setMessage');
    try {
      return super.setMessage(value);
    } finally {
      _$_ProgressControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void incrementProgress() {
    final _$actionInfo = _$_ProgressControllerActionController.startAction(
        name: '_ProgressController.incrementProgress');
    try {
      return super.incrementProgress();
    } finally {
      _$_ProgressControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clear() {
    final _$actionInfo = _$_ProgressControllerActionController.startAction(
        name: '_ProgressController.clear');
    try {
      return super.clear();
    } finally {
      _$_ProgressControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
message: ${message},
progress: ${progress},
total: ${total},
progressBarValue: ${progressBarValue}
    ''';
  }
}
