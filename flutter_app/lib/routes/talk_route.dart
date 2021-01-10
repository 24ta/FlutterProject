import 'package:flutter/material.dart';
import 'package:flutter_app/tile.dart';

class Talk extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
          title: Text("トーク")
      ),
      body: ListView(
        //padding: const EdgeInsets.all(8),
        children: <Widget>[
          Tile(icon: Icons.person, username: "藤田隆司", message: "ふぇじたです。"),
          Tile(icon: Icons.person, username: "福島康太郎", message: "福島です。"),
          Tile(icon: Icons.person, username: "よっしー", message: "よっしーです。"),
        ]
      ),
    );
  }
}