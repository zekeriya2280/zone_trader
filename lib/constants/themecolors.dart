import 'package:flutter/material.dart';

class ThemeColors {
  final Color? appbar;
  final Color? bgcolor;
  ThemeColors(this.appbar, this.bgcolor);
  Map<String,dynamic> getThemeColors(){
    return {'appbar':appbar,'bgcolor':bgcolor};
  }
}