import 'package:flutter/material.dart';

import 'backdrop.dart';
import 'category.dart';
import 'category_tile.dart';
import 'unit.dart';
import 'unit_converter.dart';

final _backgroundColor = Colors.green[100];


class CategoryRoute extends StatefulWidget {
  const CategoryRoute();

  @override 
  _CategoryRouteState createState() => _CategoryRouteState();
}

class _CategoryRouteState extends State<CategoryRoute> {
  Category _defaultCategory;
  Category _currentCategory;
  final _categories = <Category>[];

  static const _categoryNames = <String>[
    'Length',
    'Area',
    'Volume',
    'Mass',
    'Time',
    'Digital Storage',
    'Energy',
    'Currency'
  ];

  static const _baseColors = <ColorSwatch>[
    Colors.teal,
    Colors.orange,
    Colors.pinkAccent,
    Colors.blueAccent,
    Colors.yellow,
    Colors.greenAccent,
    Colors.purpleAccent,
    Colors.red
  ];

  @override
  void initState() {
    super.initState();
    for (var i=0; i < _categoryNames.length; i++) {
      var category = Category(
          text: _categoryNames[i],
          color: _baseColors[i],
          icon: Icons.cake, 
          units: _retrieveUnitList(_categoryNames[i]),
        );
      if (i == 0) {
        _defaultCategory = category;
      }
      _categories.add(category);
    }
  }

  void _onCategoryTap(Category category) {
    setState(() {
      _currentCategory = category;
    });
  }

  Widget _buildCategoryWidget() {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return CategoryTile(
          category: _categories[index],
          onTap: _onCategoryTap,
        );
      },
      itemCount: _categories.length,
    );
  }

  List<Unit> _retrieveUnitList(String categoryName) {
    return List.generate(10, (int i) {
      i += 1;
      return Unit(
        name: '$categoryName Unit $i',
        conversion: i.toDouble(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final listView = Padding(
      padding: EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        bottom: 8.0,
      ),
      child: _buildCategoryWidget(),
    );

    return Backdrop(
      currentCategory: _currentCategory == null ? _defaultCategory :_currentCategory,
      frontPanel: _currentCategory == null
        ? UnitConverter(category: _defaultCategory)
        : UnitConverter(category: _currentCategory),
      backPanel: listView,
      frontTitle: Text('Unit Converter'),
      backTitle: Text('Select a Category'),
    );
  }
}