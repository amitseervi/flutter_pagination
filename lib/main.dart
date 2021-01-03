import 'package:Beers/BeerListPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(BeerApp());
}

class BeerApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beer App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BeerListPage(),
    );
  }
}