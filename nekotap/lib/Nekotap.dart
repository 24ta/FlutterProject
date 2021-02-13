import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'AppBackground.dart';

class Nekotap extends StatefulWidget {
  @override
  _NekotapState createState() {
    return _NekotapState();
  }
}

class _NekotapState extends State<Nekotap> {
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
            image: DecorationImage(
                image: AssetImage('assets/food.png'),
                fit: BoxFit.scaleDown)
        ),
        // child:RaisedButton(
        //     color: Colors.blue[200],
        //     shape: const StadiumBorder(),
        //     onPressed: () => record.reference.updateData({'tap_count': FieldValue.increment(1)}),
        //     child: Text("\n\n" + record.name + " " + record.tap_count.toString() + "\n\n",
        //         style: TextStyle(
        //             fontSize: 60,)
        //     ),
        child:RaisedButton(
          color: Colors.blue[200],
          shape: const StadiumBorder(),
          onPressed: () => record.reference.updateData({'tap_count': FieldValue.increment(1)}),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/food.png'),
                fit: BoxFit.scaleDown
              )
            ),
            child: Text("\n\n" + record.name + " " + record.tap_count.toString() + "\n\n",
                style: TextStyle(
                  fontSize: 60,)
            ),
          )
      ),)
    );
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