import 'package:flutter/material.dart';
import 'Tap.dart';
import 'Top.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neko Tap',
      initialRoute: '/',
      routes: {
        '/': (_) => new Top(),
        '/top': (_) => new Top(),
        '/tap': (_) => new Tap(),
        //'/record': (_) => new PastRecord(),
      },
    );
  }
}


