import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:golekos_admin/widgets/card_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // final Stream<QuerySnapshot> _ordersStream =
    //     FirebaseFirestore.instance.collection('orders').snapshots();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    CollectionReference ordersReference = firestore.collection('orders');

    return Scaffold(
      appBar: AppBar(
        title: Text('Golekos Admin'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: ordersReference.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!(snapshot.hasData)) {
            return Center(
              child: Text('No data here'),
            );
          }

          return ListView(
            shrinkWrap: true,
            children: snapshot.data!.docs.map((e) {
              Map<String, dynamic> data = e.data() as Map<String, dynamic>;
              return CardTile(
                id: e.id,
                data: data,
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
