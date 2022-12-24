import 'package:mobx/mobx.dart';

part 'progress-controller.g.dart';

class ProgressController = _ProgressController with _$ProgressController;
abstract class _ProgressController with Store {
  @observable String message = '';
  @observable int progress = 0;
  @observable int total;

  _ProgressController(this.total);

  @computed
  double get progressBarValue {
    double retorno = double.tryParse((progress / total).toStringAsFixed(3)) ?? 0;
    if (retorno.isNaN || retorno.isInfinite) {
      return 0;
    }
    return retorno;
  }

  @action
  void setMessage(String value) => message = value;

  @action
  void incrementProgress() => progress++;

  @action
  void clear() {
    message = '';
    progress = 0;
  }
}