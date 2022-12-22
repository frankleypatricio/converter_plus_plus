// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list-files-store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ListFilesStore on _ListFilesStore, Store {
  late final _$selectedIndexAtom =
      Atom(name: '_ListFilesStore.selectedIndex', context: context);

  @override
  int get selectedIndex {
    _$selectedIndexAtom.reportRead();
    return super.selectedIndex;
  }

  @override
  set selectedIndex(int value) {
    _$selectedIndexAtom.reportWrite(value, super.selectedIndex, () {
      super.selectedIndex = value;
    });
  }

  late final _$_ListFilesStoreActionController =
      ActionController(name: '_ListFilesStore', context: context);

  @override
  void setSelectedIndex(int index) {
    final _$actionInfo = _$_ListFilesStoreActionController.startAction(
        name: '_ListFilesStore.setSelectedIndex');
    try {
      return super.setSelectedIndex(index);
    } finally {
      _$_ListFilesStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void remove(MediaFile element) {
    final _$actionInfo = _$_ListFilesStoreActionController.startAction(
        name: '_ListFilesStore.remove');
    try {
      return super.remove(element);
    } finally {
      _$_ListFilesStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void add(MediaFile element) {
    final _$actionInfo = _$_ListFilesStoreActionController.startAction(
        name: '_ListFilesStore.add');
    try {
      return super.add(element);
    } finally {
      _$_ListFilesStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addAll(List<MediaFile> list) {
    final _$actionInfo = _$_ListFilesStoreActionController.startAction(
        name: '_ListFilesStore.addAll');
    try {
      return super.addAll(list);
    } finally {
      _$_ListFilesStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clear() {
    final _$actionInfo = _$_ListFilesStoreActionController.startAction(
        name: '_ListFilesStore.clear');
    try {
      return super.clear();
    } finally {
      _$_ListFilesStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedIndex: ${selectedIndex}
    ''';
  }
}
