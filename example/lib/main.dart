import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SafeArea(
        child: Scaffold(
          body: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                EasyAutocomplete(
                  suggestions: ['Afeganistao', 'Albania', 'Algeria', 'Mocambique', 'Portugal', 'Madagascar', 'Alemanha', 'Dinamarca', 'Australia', 'Brasil', 'Gana'],
                  onChanged: (value) => print('')
                )
              ],
            )
          )
        ),
      )
    );
  }
}
