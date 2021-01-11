import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

class AppBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, contraint) {
      final height = contraint.maxHeight;
      final width = contraint.maxWidth;

      return Stack(
        children: <Widget>[
          Container(
            color: Color(0xFFE4E6F1),
          ),
          Positioned(
            top: height * 0.20,
            left: height * 0.35,
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white.withOpacity(0.4)),
            ),
          ),
          Positioned(
            top: -height * 0.10,
            left: -height * 0.39,
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white.withOpacity(0.2)),
            ),
          ),
        ],
      );
    });
  }
}

class Tap extends StatefulWidget {
  @override
  _TapState createState() {
    return _TapState();
  }
}

class _TapState extends State<Tap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Neko Tap!')),
      body: Stack(
        children: [
          AppBackground(),
          _buildBody(context),
        ],
      )

    );
  }

  Widget _buildBody(BuildContext context) {
    // TODO: get actual snapshot from Cloud Firestore
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('food').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);

    return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(record.name),
          trailing: Text(record.tap_count.toString()),
          onTap: () => record.reference
              .updateData({'tap_count': FieldValue.increment(1)}),
        ),
      ),
    );
  }
}

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
                      Navigator.of(context).pushNamed('/record');
                    },
                    child: const Text('データ',
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.white,))))
          ],
        ));
  }


}

class Record {
  final String name;
  final int tap_count;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['tap_count'] != null),
        name = map['name'],
        tap_count = map['tap_count'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$tap_count>";
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


