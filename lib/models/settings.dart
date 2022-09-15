import 'package:flutter/material.dart';

class Settings {
  static Settings _settings;
  String password;
  Color currentColor;
  String sort;
  int visibility;
  factory Settings() {
    if (_settings == null) {
      _settings = Settings.internal();
      return _settings;
    } else {
      return _settings;
    }
  }
  Settings.internal();
  Color switchBackgroundColor() {
    switch (currentColor.hashCode) {
      //siyah
      case 4078190080:
        return Colors.grey.shade600;
      default:
        return Colors.white;
    }
  }
}
