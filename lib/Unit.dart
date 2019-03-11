import 'package:meta/meta.dart';

class Unit {
  final String name;
  final double conversion;

  const Unit({
    @required this.name,
    @required this.conversion,
  }) : assert(name != null),
       assert(conversion != null);

  Unit.fromJson(Map mapJson) 
    : assert(mapJson['name'] != null),
      assert(mapJson['conversion'] != null),
      name = mapJson['name'],
      conversion = mapJson['conversion'].toDouble();
}
