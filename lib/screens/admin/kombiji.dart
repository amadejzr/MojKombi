import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mycombi/screens/components/widgets/navigation_drawer_admin.dart';

class Combies extends StatefulWidget {
  const Combies({Key? key}) : super(key: key);

  @override
  _CombiesState createState() => _CombiesState();
}

class _CombiesState extends State<Combies> {
  final Stream<QuerySnapshot> _kombiStream = FirebaseFirestore.instance
      .collection('kombiji')
      .where('approved', isEqualTo: false)
      .snapshots();

  CollectionReference kombi = FirebaseFirestore.instance.collection('kombiji');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Kombiji"),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _kombiStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  title: Text(
                    data['znamka'] + " " + data['model'],
                  ),
                  trailing: Wrap(
                    children: <Widget>[
                      MaterialButton(
                          onPressed: () {
                            kombi
                                .doc(document.id)
                                .update({'approved': true})
                                .then((value) => print("uspesno"))
                                .catchError((error) => print(error));
                          },
                          child: const Icon(
                            Icons.add_circle,
                            color: Colors.green,
                          )),
                      MaterialButton(
                          onPressed: () {
                            kombi
                                .doc(document.id)
                                .delete()
                                .then((value) => print("uspesno"))
                                .catchError((error) => print(error));
                          },
                          child: const Icon(
                            Icons.remove_circle,
                            color: Colors.red,
                          )), // icon-1 // icon-1
                    ],
                  ),
                  subtitle: Row(
                    children: <Widget>[
                      Text(data['gorivo']),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
        drawer: const MyNavigationdrawer());
  }
}
