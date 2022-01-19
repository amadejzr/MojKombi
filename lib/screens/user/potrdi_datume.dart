import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PotrdiDatum extends StatefulWidget {
  final String kombiId;
  const PotrdiDatum({Key? key, required this.kombiId}) : super(key: key);

  @override
  _PotrdiDatumState createState() => _PotrdiDatumState();
}

class _PotrdiDatumState extends State<PotrdiDatum> {
  List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }

  Future<void> postToFirestore(DateTime startDate, DateTime endDate) {
    return FirebaseFirestore.instance
        .collection('kombiji')
        .doc(widget.kombiId)
        .update({
      'arr': FieldValue.arrayUnion(getDaysInBetween(startDate, endDate))
    }).then((value) => {print("dodano")});
  }

  Future<void> deleteDoc(String id) {
    return FirebaseFirestore.instance
        .collection('kombiji')
        .doc(widget.kombiId)
        .collection('datumi')
        .doc(id)
        .delete()
        .then((value) {
      print("deleted");
    });
  }

  Future test(String id, String kid, DateTime zac, DateTime kon) {
    List<dynamic> l = [
      kid +
          " " +
          DateFormat('dd-MM-yyy').format(zac).toString() +
          " " +
          DateFormat('dd-MM-yyy').format(kon).toString()
    ];

    return FirebaseFirestore.instance
        .collection('uporabniki')
        .doc(id)
        .update({'sposojeniKombiji': FieldValue.arrayUnion(l)});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('kombiji')
                .doc(widget.kombiId)
                .collection('datumi')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              return Column(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return Column(
                    children: [
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(data['email']),
                            MaterialButton(
                              child: Icon(Icons.add),
                              onPressed: () {
                                data['kon'].toDate();
                                postToFirestore(data['zac'].toDate(),
                                        data['kon'].toDate())
                                    .then((value) {
                                  test(
                                      data['uid'],
                                      widget.kombiId,
                                      data['zac'].toDate(),
                                      data['kon'].toDate());
                                });
                                deleteDoc(document.id);
                              },
                              color: Colors.red,
                            ),
                            MaterialButton(
                              child: Icon(Icons.delete),
                              onPressed: () {
                                deleteDoc(document.id);
                              },
                              color: Colors.red,
                            )
                          ],
                        ),
                        subtitle: Text("Od: " +
                            DateFormat('dd-MM-yyy')
                                .format(data['zac'].toDate())
                                .toString() +
                            " Do: " +
                            DateFormat('dd-MM-yyy')
                                .format(data['kon'].toDate())
                                .toString()),
                      ),
                    ],
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
