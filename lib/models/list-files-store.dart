import 'package:converter_plus_plus/models/media-file.dart';
import 'package:mobx/mobx.dart';

part 'list-files-store.g.dart';

class ListFilesStore = _ListFilesStore with _$ListFilesStore;
abstract class _ListFilesStore with Store {
  final ObservableList<MediaFile> files = ObservableList();
  @observable int selectedIndex = 0;

  MediaFile get selected => files[selectedIndex];

  @action
  void setSelectedIndex(int index) => selectedIndex = index;

  @action
  void remove(MediaFile element) {
    files.remove(element);
  }

  @action
  void add(MediaFile element) {
    files.add(element);
  }

  @action
  void clear() {
    files.clear();
  }
}