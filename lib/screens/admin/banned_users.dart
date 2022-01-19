import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:mycombi/screens/components/widgets/navigation_Drawer_Admin.dart';

class BannedUsers extends StatefulWidget {
  const BannedUsers({Key? key}) : super(key: key);

  @override
  _BannedUsersState createState() => _BannedUsersState();
}

class _BannedUsersState extends State<BannedUsers> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('uporabniki')
      .where('state', isEqualTo: 'Banned')
      .snapshots();

  CollectionReference users =
      FirebaseFirestore.instance.collection('uporabniki');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Banned users"),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _usersStream,
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
                    data['ime'] + " " + data['priimek'],
                  ),
                  trailing: Wrap(
                    children: <Widget>[
                      MaterialButton(
                          onPressed: () {
                            users
                                .doc(data['uid'])
                                .update({'state': 'User'})
                                .then((value) => print("uspesno"))
                                .catchError((error) => print(error));
                          },
                          child: const Icon(
                            Icons.add,
                            color: Colors.red,
                          )), // icon-1 // icon-1
                    ],
                  ),
                  subtitle: Row(
                    children: <Widget>[
                      Text(data['email']),
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
