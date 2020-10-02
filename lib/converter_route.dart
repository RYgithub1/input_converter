import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'unit.dart';

const _padding = EdgeInsets.all(16.0);



/// from[Category.dart]to[ConverterRoute.dart]
class ConverterRoute extends StatefulWidget {
  /// +++[Argument Passing]++++++++++++++++++++++++++
  final Color color;  // Color for this [Category].
  final List<Unit> units;  // Units for this [Category].
  const ConverterRoute({  // requires the color and units not to be null.
    @required this.color,
    @required this.units,
  })  : assert(color != null),
        assert(units != null);
  @override
  _ConverterRouteState createState() => _ConverterRouteState();
}



class _ConverterRouteState extends State<ConverterRoute> {
  /// ++++[globalString]+++++++++++++++++++++++++++++++
  Unit _fromValue;  ///[Unit type]
  Unit _toValue;
  double _inputValue;
  String _convertedValue = '';
  List<DropdownMenuItem> _unitMenuItems;
  bool _showValidationError = false;  // error判別用変数

  /// +++++[initState()]++++++++++++++++++++++++++++++
  @override
  void initState() {
    super.initState();
    _createDropdownMenuItems();
    _setDefaults();
  }
  /// [initState() widgets], given a list of [Unit]s.
  void _createDropdownMenuItems() {
    var newItems = <DropdownMenuItem>[];  // localString
    for (var unit in widget.units) {
      newItems.add(DropdownMenuItem(  // add keyValues to [list]
        value: unit.name,
        child: Container(
          child: Text(
            unit.name,
            softWrap: true,
          ),
        ),
      ));
    }
    setState(() {
      _unitMenuItems = newItems;  // localString->globalString
    });
  }
  /// [initState() widgets], Sets the default values for the 'from' and 'to' [Dropdown]s.
  void _setDefaults() {
    setState(() {
      _fromValue = widget.units[0];
      _toValue = widget.units[1];
    });
  }
  // ++++[initState()] part+++++++++++++++++++++++++++++++


  // =====[conversion part]=====================================================
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

  void _updateConversion() {  /// for common snipet [setState()]
    setState(() {
      _convertedValue = _format(_inputValue * (_toValue.conversion / _fromValue.conversion));
    });
  }

  void _updateInputValue(String input) {   /// from[build()]
    setState(() {
      if (input == null || input.isEmpty) {
        _convertedValue = '';
      } else {
        try {
          final inputDouble = double.parse(input);
          _showValidationError = false;
          _inputValue = inputDouble;
          _updateConversion();   /// to[_updateConversion]
        } on Exception catch (e) {
          print('Error: $e');
          _showValidationError = true;
        } finally  {
          print("finally message haha");
        }
      }
    });
  }

  Unit _getUnit(String unitName) {  /// define localString [_getUnit] for [_updateFromConversion] and [_updateToConversion]
    return widget.units.firstWhere(
      (Unit unit) {
        return unit.name == unitName;
      },
      orElse: null,
    );
  }

  void _updateFromConversion(dynamic unitName) {  /// [from]
    setState(() {
      _fromValue = _getUnit(unitName);
    });
    if (_inputValue != null) {
      _updateConversion();   /// to[_updateConversion]
    }
  }

  void _updateToConversion(dynamic unitName) {   /// [to]
    setState(() {
      _toValue = _getUnit(unitName);
    });
    if (_inputValue != null) {
      _updateConversion();   /// to[_updateConversion]
    }
  }
  // ==========================================================

  /// [local variableとしてbuild()事前にに宣言が必要]
  Widget _createDropdown(String currentValue, ValueChanged<dynamic> onChanged) {
    return Container(   // Containerしいて、共用DropdownBoxのデザインしているだけ
      margin: EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(  // decoration: BoxDecoration ... 使わなくても良いが伝えやすい
        color: Colors.grey[50],  // color of Dropdown'Button' itself
        border: Border.all(
          color: Colors.grey[400],
          width: 1.0,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 8.0),  // vertical 8.0 Padding
      child: Theme(
        data: Theme.of(context).copyWith(  // color of Dropdown'MenuItem'
          canvasColor: Colors.grey[50],
        ),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(  /// 要は[DropdownButton]を[MAKE HERE FIRST]
              value: currentValue,
              items: _unitMenuItems,
              onChanged: onChanged,  // @required: いつものonChamgedでvalue渡すやつ
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ),
      ),
    );
  }


  /// +++[build]++++++++++++++++++++++++++++++++++++++++++++++++++++++
  @override
  Widget build(BuildContext context) {

    /// --[localVariable: input group]--
    final input = Padding(
      padding: _padding, // Padding of 16.0.
      child: Column(  /// [MAKE HERE FIRST for INPUT area] ... 'input' group is composed of a TextField and a Dropdown
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(  /// [get inputText]
            style: Theme.of(context).textTheme.headline4,
            decoration: InputDecoration(
              labelStyle: Theme.of(context).textTheme.headline4,
              errorText: _showValidationError ? 'Invalid number entered' : null,  // when invalid values are entered
              labelText: 'Input',
              border: OutlineInputBorder( // to see border screenshot.
                borderRadius: BorderRadius.circular(0.0),
              ),
            ),
            keyboardType: TextInputType.number,  // to enter numbers only.
            onChanged: _updateInputValue,  /// from [_updateInputValue]
          ),
          _createDropdown(_fromValue.name, _updateFromConversion),  // Dropdown for the 'From' unit.
        ],
      ),
    );

    /// --[localVariable: arrows group]--
    final arrows = RotatedBox(
      quarterTurns: 1,
      child: Icon(  /// [MAKE HERE FIRST for ARROWS area]
        Icons.compare_arrows,  // 'Compare Arrows' icon between the dropdowns.
        size: 40.0,
      ),
    );

    /// --[localVariable: output group]--
    final output = Padding(
      padding: _padding,  // Padding of 16.0
      child: Column(  /// [MAKE HERE FIRST for OUTPUT area]
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InputDecorator(  // output Text with the conversion result
            child: Text(
              _convertedValue,
              style: Theme.of(context).textTheme.headline4,
            ),
            decoration: InputDecoration(
              labelText: 'Output',
              labelStyle: Theme.of(context).textTheme.headline4,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
            ),
          ),
          _createDropdown(_toValue.name, _updateToConversion),  // dropdown for the 'To' unit
        ],
      ),
    );

    /// --[localVariable group SUM: input,arrows,output]--
    // final converter = Column(
    //   crossAxisAlignment: CrossAxisAlignment.stretch,
    //   children: [
    //     input,
    //     arrows,
    //     output,
    //   ],
    // );

    return Padding(
      padding: _padding,  // entire user input section is wrapped in 16.0 Padding.
      // child: converter,  /// --[localVariable group SUM]--
      child: Column(  /// [Most: MAKE HERE FIRST -> return Column]
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          input,
          arrows,
          output,
        ],
      ),
    );
  }
}
