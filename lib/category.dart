import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'unit.dart';

class Category {
  final String icon;
  final ColorSwatch color;
  final String text;
  final List<Unit> units;

  const Category({
    Key key,
    @required this.text, 
    @required this.color, 
    @required this.icon,
    @required this.units,
  }) : assert(text != null),
       assert(color != null),
       assert(icon != null),
       assert(units != null);
}
