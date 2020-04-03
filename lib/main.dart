import 'package:flutter/material.dart';
import 'home.dart';

//const request = "https://api.hgbrasil.com/finance?format=json&key=24d7a889";

void main() async {

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.amber
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white
          )
        ),
        hintStyle: TextStyle(
          color: Colors.amber
        )
      )
    ),
    home: Home(),
  ));
}

