import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'unit.dart';


const _padding = EdgeInsets.all(16.0);



/// [ConverterRoute] is ConverterScreen : retrieve one and another [Unit]s.
class ConverterRoute extends StatefulWidget {
  final Color color;  /// Color for [Category].
  final List<Unit> units;  /// Units for [Category].
  const ConverterRoute({  /// [not be null]
    @required this.color,
    @required this.units,
  })  : assert(color != null),
        assert(units != null);
  @override
  _ConverterRouteState createState() => _ConverterRouteState();
}



class _ConverterRouteState extends State<ConverterRoute> {
  // TODO: Set some variables, such as for keeping track of the user's input
  // value and units

  // TODO: Determine whether you need to override anything, such as initState()

  // TODO: Add other helper functions. We've given you one, _format()

  /// Clean up conversion; trim trailing zeros, e.g. 5.500 -> 5.5, 10.0 -> 10
  String _format(double conversion) {
    var outputNum = conversion.toStringAsPrecision(7);
    if (outputNum.contains('.') && outputNum.endsWith('0')) {
      var i = outputNum.length - 1;
      while (outputNum[i] == '0') {
        i -= 1;
      }
      outputNum = outputNum.substring(0, i + 1);
    }
    if (outputNum.endsWith('.')) {
      return outputNum.substring(0, outputNum.length - 1);
    }
    return outputNum;
  }


  // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  @override
  Widget build(BuildContext context) {
    // TODO: Create the 'input' group of widgets. This is a Column that
    // includes the input value, and 'from' unit [Dropdown].

    // TODO: Create a compare arrows icon.

    // TODO: Create the 'output' group of widgets. This is a Column that
    // includes the output value, and 'to' unit [Dropdown].

    // TODO: Return the input, arrows, and output widgets, wrapped in a Column.

    // TODO: Delete the below placeholder code.
    final unitWidgets = widget.units.map((Unit unit) {
      return Container(
        color: widget.color,
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              unit.name,
              style: Theme.of(context).textTheme.headline5,
            ),
            Text(
              'Conversion: ${unit.conversion}',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
      );
    }).toList();

    return ListView(
      children: unitWidgets,
    );
  }
}
