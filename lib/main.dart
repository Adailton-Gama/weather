import 'package:flutter/material.dart';
import 'package:weather/pages/searchPage.dart';
import 'package:weather/pages/weather.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: searchPage(),
  ));
}
