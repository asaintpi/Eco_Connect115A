import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blank Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlankPage(),
    );
  }
}

class BlankPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blank Page'),
      ),
      body: Center(
        child: Text(''),
      ),
    );
  }
}
