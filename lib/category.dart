import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'converter_route.dart';
import 'unit.dart';



final _rowHeight = 100.0;  // underscore -> private.
final _borderRadius = BorderRadius.circular(_rowHeight / 2);



/// from[category_route.dart]to[category.dart] ... custom [Category] widget.
class Category extends StatelessWidget {
  // 受け取るため
  final String name;
  final ColorSwatch color;
  final IconData iconLocation;
  final List<Unit> units;
  // 受け取る
  const Category({
    Key key,
    @required this.name,
    @required this.color,
    @required this.iconLocation,
    @required this.units,
  })  : assert(name != null),
        assert(color != null),
        assert(iconLocation != null),
        assert(units != null),
        super(key: key);


  /// [build] ++++++++++++++++++++++++++++++++++++++++++++++++
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        height: _rowHeight,
        child: InkWell(
          borderRadius: _borderRadius,
          // TODO: Use the highlight and splash colors from the ColorSwatch
          highlightColor: color,
          splashColor: color,
          // onTap: () {_navigateToConverter(context);},  // [1]どんな場合も可能
          onTap: () => _navigateToConverter(context),  // [2]1行の場合可能
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Icon(
                    iconLocation,
                    size: 60.0,
                  ),
                ),
                Center(
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  /// ++++[sub]+++++++++++++++++++++++++++++++++++
  /// Navigates to [ConverterRoute]
  void _navigateToConverter(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<Null>(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            elevation: 1.0,
            title: Text(
              name,
              style: Theme.of(context).textTheme.headline4,
            ),
            centerTitle: true,
            backgroundColor: color,
          ),
          body: ConverterRoute(  /// from[Category.dart]to[ConverterRoute.dart]
            color: color,
            units: units,
          ),
          // This prevents the attempt to resize the screen, when the keyboard is opened.
          resizeToAvoidBottomPadding: false,  // beat tigar
        );
      },
    ));
  }
}
