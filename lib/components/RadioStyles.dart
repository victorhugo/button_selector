import 'dart:ui';

import 'package:flutter/material.dart';

class RadioOptionStyle {
  RadioOptionStyle();

  Color selectedRadioColor = Colors.white;
  Color unselectedRadioColor = Colors.white;
  Color selectedBackgroundColor = Colors.transparent;
  Color unselectedBackgroundColor = Colors.transparent;
  Color selectedLabelColor = Colors.white;
  Color unselectedLabelColor = Colors.white;

  Color itemBorderColor = Colors.white;
  bool showBorder = false;

  RadioOptionStyle.colors({
    this.selectedRadioColor,
    this.unselectedRadioColor,
    this.selectedBackgroundColor,
    this.unselectedBackgroundColor,
    this.selectedLabelColor,
    this.unselectedLabelColor,
    this.itemBorderColor,
    this.showBorder,
  });
}
