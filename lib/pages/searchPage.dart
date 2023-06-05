import 'dart:ui';

import 'package:diacritic/diacritic.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:weather/pages/weather.dart';

var url = "https://www.cptec.inpe.br/previsao-tempo/";
var pos = 'https://nominatim.openstreetmap.org/search.php?city=';
var requests = '';
bool a = true;
var estado;
var parseCity;

class searchPage extends StatefulWidget {
  const searchPage({Key? key}) : super(key: key);

  @override
  State<searchPage> createState() => _searchPageState();
}

class _searchPageState extends State<searchPage> {
  final cidade = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(89, 175, 192, 1),
        centerTitle: true,
        actions: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                onPrimary: Color.fromRGBO(89, 175, 192, 1),
                primary: Color.fromRGBO(89, 175, 192, 1),
                shadowColor: Colors.transparent,
              ),
              onPressed: () {
                var city = cidade.text;
                print(removeDiacritics(city));
                city = removeDiacritics(city);
                parseCity = city;
                city = city.replaceAll(' ', '%20').toLowerCase();
                requests = '$url$estado/${city}';
                setState(() {
                  if (a == true) {
                    a = false;
                  } else {
                    a = true;
                  }
                });
              },
              child: Icon(
                Icons.search,
                color: Colors.white,
              )),
        ],
        title: Row(
          children: [
            Expanded(
              child: TextField(
                style: TextStyle(color: Colors.white),
                controller: cidade,
                decoration: InputDecoration(
                  label: Text(
                    "Cidade",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton(
                  style: TextStyle(color: Colors.white),
                  hint: Text(
                    'UF',
                    style: TextStyle(color: Colors.white),
                  ),
                  dropdownColor: Color.fromRGBO(50, 148, 167, 1),
                  iconEnabledColor: Colors.white,
                  menuMaxHeight: 150,
                  value: estado,
                  items: estados.map(buildMenuItem).toList(),
                  onChanged: (value) {
                    setState(() {
                      estado = value.toString();
                    });
                  }),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height -
              AppBar().preferredSize.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/lightapp.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              a
                  ? Container(
                      height: MediaQuery.of(context).size.height -
                          AppBar().preferredSize.height -
                          MediaQuery.of(context).padding.top -
                          MediaQuery.of(context).padding.bottom,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/lightapp.png'),
                          fit: BoxFit.fill,
                        ),
                      ))
                  : WeatherPage(
                      requests: requests,
                      cidade: parseCity,
                      estado: estado.toString(),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  final estados = [
    "ac",
    "al",
    "am",
    "ap",
    "ba",
    "ce",
    "df",
    "es",
    "go",
    "ma",
    "mg",
    "ms",
    "mt",
    "pa",
    "pb",
    "pe",
    "pi",
    "pr",
    "rj",
    "rn",
    "rr",
    "rs",
    "sc",
    "se",
    "sp",
    "to",
    "ro",
  ];
  DropdownMenuItem<String> buildMenuItem(String item) =>
      DropdownMenuItem(value: item, child: Text(item));
}
