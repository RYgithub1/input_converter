import 'package:flutter/material.dart';
import 'category_route.dart';



void main() {
  runApp(UnitConverterApp());
}



class UnitConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Unit Converter',
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(  // ThemeData's textTheme have  ...
          bodyColor: Colors.black,  // [1]a body color of black, and ...
          displayColor: Colors.grey[600],  // [2]a display color of Colors.grey[600].
        ),
        // primarySwatch: Colors.grey[500],  // primarySwatch -> error:no Material this time
        primaryColor: Colors.grey[500],  // ThemeData's primaryColor is Colors.grey[500].
        // textSelectionHandleColor: Colors.green[500],
      ),
      home: CategoryRoute(),
    );
  }
}