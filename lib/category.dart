import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:flutter_hello_rectangle/converter_route.dart';
import 'package:flutter_hello_rectangle/Unit.dart';

final _rowHeight = 100.0;
final _borderRadius = BorderRadius.circular(_rowHeight / 2);

class Category extends StatelessWidget {
  final IconData icon;
  final ColorSwatch color;
  final String text;
  final List<Unit> units;

  final double widgetWidth = 100.0;
  final double widgetPadding = 8.0;
  final double radius = 50.0;
  final double iconSize = 60.0;
  final double iconPadding = 16.0;
  final double textSize = 24.0;

  const Category({
    Key key,
    @required this.text, 
    @required this.color, 
    @required this.icon,
    @required this.units,
  }) : assert(text != null),
       assert(color != null),
       assert(icon != null),
       assert(units != null),
       super(key: key);

  void _navigateToConverter(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<Null>(
      builder:(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            elevation: 1.0,
            title: Text(
              text,
              style: Theme.of(context).textTheme.display1,
            ),
            centerTitle: true,
          ),
          body: ConverterRoute(
              color: color,
              name: text,
              units: units,
          )
        );
      } 
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        height: _rowHeight,
        child: InkWell(
          borderRadius: _borderRadius,
          highlightColor: color,
          splashColor: color,
          onTap: () {
            _navigateToConverter(context);
          },
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(iconPadding),
                  child: Icon(
                    icon,
                    size: iconSize,
                  ),
                ),
                Center(
                    child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline,
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
