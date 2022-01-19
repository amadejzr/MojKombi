import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:mycombi/screens/components/services/user_model.dart';
import 'package:mycombi/screens/components/widgets/navigation_Drawer_Admin.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('uporabniki')
      .where('state', isEqualTo: 'Disabled')
      .snapshots();

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  CollectionReference users =
      FirebaseFirestore.instance.collection('uporabniki');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Disabled users"),
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
                            Icons.add_circle,
                            color: Colors.green,
                          )),
                      MaterialButton(
                          onPressed: () {
                            users
                                .doc(data['uid'])
                                .update({'state': 'Banned'})
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
