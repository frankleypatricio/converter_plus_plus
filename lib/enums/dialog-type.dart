import 'package:flutter/material.dart';

enum DialogType{
  info, success, error;
}
extension DialogTypeExtension on DialogType {
  Color get color {
    switch (this) {
      case DialogType.success:
        return Colors.green;
      case DialogType.error:
        return Colors.redAccent;
      case DialogType.info:
        return Colors.blueAccent;
    }
  }

  IconData get iconData {
    switch (this) {
      case DialogType.success:
        return Icons.check_circle;
      case DialogType.error:
        return Icons.cancel_rounded;
      case DialogType.info:
        return Icons.info;
    }
  }
}