import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'AppBackground.dart';

class Top extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: Text("ねこタップ")),
        body: Stack(
            children: [
              AppBackground(),
              _buildBody(context),
            ]
        )
    );
  }

  Widget _buildBody(BuildContext context) {
    // TODO: get actual snapshot from Cloud Firestore
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildMain(context, data)).toList(),
    );
  }

  Widget _buildMain(BuildContext context, DocumentSnapshot data, ){
    final user_data = user_Record.fromSnapshot(data);
    final Size size = MediaQuery.of(context).size;
    return Container(
      //padding: EdgeInsets.only(top: size.height-600),
        padding: EdgeInsets.only(top: 200),
        //margin: EdgeInsets.only(bottom: 100.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              '健康スコア',
            ),
            Text(
                user_data.HealthScore.toString(),
                style: TextStyle(
                    fontSize: 70
                )
            ),
            ButtonTheme(
              minWidth: 350.0,
              height: 125.0,
              child: RaisedButton(
                  color: Colors.yellow[800],
                  shape: const StadiumBorder(),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/tap');
                  },
                  child: const Text('スタート！',
                      style: TextStyle(
                          fontSize: 40,
                          color: Colors.white)
                  )),
            ),
            ButtonTheme(
                minWidth: 350.0,
                height: 125.0,
                child: RaisedButton(
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/data');
                    },
                    child: const Text('データ',
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.white,))))
          ],
        ));
  }


}

class user_Record {
  final String name;
  final String uid;
  final int HealthScore;
  final DocumentReference reference;

  user_Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['uid'] != null),
        assert(map['HealthScore'] != null),
        name = map['name'],
        uid = map['uid'],
        HealthScore = map['HealthScore'];

  user_Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "user_Record<$name:$uid:$HealthScore>";
}