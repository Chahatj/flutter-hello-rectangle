import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'api.dart';
import 'backdrop.dart';
import 'category.dart';
import 'category_tile.dart';
import 'unit.dart';
import 'unit_converter.dart';

class CategoryRoute extends StatefulWidget {
  const CategoryRoute();

  @override 
  _CategoryRouteState createState() => _CategoryRouteState();
}

class _CategoryRouteState extends State<CategoryRoute> {
  Category _defaultCategory;
  Category _currentCategory;
  final _categories = <Category>[];

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

  static const _icons = <String>[
    'assets/icons/length.png',
    'assets/icons/area.png',
    'assets/icons/length.png',
    'assets/icons/area.png',
    'assets/icons/length.png',
    'assets/icons/area.png',
    'assets/icons/length.png',
    'assets/icons/area.png',
];

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();

    if (_categories.isEmpty) {
      await _retrieveLocalCategories();
      await _retrieveApiCategories();
    }
  }

  Future<void> _retrieveLocalCategories() async {
    final json = DefaultAssetBundle
      .of(context)
      .loadString('assets/data/regular_units.json');
    final data = JsonDecoder().convert(await json);
    if (data is! Map) {
      throw ('Data retrieved from API is not a Map');
    }
    var categoryIndex = 0;
    data.keys.forEach((key) {
      final List<Unit> units = 
        data[key].map<Unit>((dynamic data) => Unit.fromJson(data)).toList();
      
      var category = Category(
        text: key,
        units: units,
        color: _baseColors[categoryIndex],
        icon: _icons[categoryIndex],
      );

      setState(() {
        if (categoryIndex == 0) {
          _defaultCategory = category;
        }
        _categories.add(category);
      });
      categoryIndex += 1;
    });
  }

  Future<void> _retrieveApiCategories() async {
    setState(() {
      _categories.add(
        Category(
          text: apiCategory['name'],
          units: [],
          color: _baseColors.last,
          icon: _icons.last,
        )
      );
    });
    final api = Api();
    final jsonUnits = await api.getUnits(apiCategory['route']);
    if (jsonUnits != null) {
      final units = <Unit>[];
      for (var unit in jsonUnits) {
        units.add(Unit.fromJson(unit));
      }
      setState(() {
        _categories.removeLast();
        _categories.add(
          Category(
            text: apiCategory['name'],
            units: units,
            color: _baseColors.last,
            icon: _icons.last,
          )
        );
      });
    }
  } 

  void _onCategoryTap(Category category) {
    setState(() {
      _currentCategory = category;
    });
  }

  Widget _buildCategoryWidget(Orientation deviceOrientation) {
    if (deviceOrientation == Orientation.portrait) {
      return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        var _category =_categories[index];
        return CategoryTile(
          category: _category,
          onTap: _category.text == apiCategory['name'] && _category.units.isEmpty
                    ? null: _onCategoryTap,
        );
      },
      itemCount: _categories.length,
      );
    } else {
      return GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 3.0,
        children: _categories.map((Category c) {
          return CategoryTile(
            category: c,
            onTap: _onCategoryTap,
          );
        }).toList()
      );
    }
    
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
    if (_categories.isEmpty) {
      return Center(
        child: Container(
          height: 180.0,
          width: 180.0,
          child: CircularProgressIndicator(),
        ),
      );
    }

    assert(debugCheckHasMediaQuery(context));
    final listView = Padding(
      padding: EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        bottom: 8.0,
      ),
      child: _buildCategoryWidget(MediaQuery.of(context).orientation),
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