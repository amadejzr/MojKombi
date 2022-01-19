import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mycombi/screens/admin/admin_screen.dart';
import 'package:mycombi/screens/components/services/user_model.dart';
import 'package:mycombi/screens/login/login_screen.dart';
import 'package:mycombi/screens/user/banned.dart';
import 'package:mycombi/screens/user/disabled.dart';
import 'package:mycombi/screens/user/user_screen.dart';

class Roles extends StatefulWidget {
  const Roles({Key? key}) : super(key: key);

  @override
  _RolesState createState() => _RolesState();
}

class _RolesState extends State<Roles> {
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference users =
      FirebaseFirestore.instance.collection('uporabniki');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(user!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          if (data['state'] == 'Admin') {
            return Home();
          } else if (data['state'] == 'User') {
            return UserScreen(id: user!.uid);
          } else if (data['state'] == 'Banned') {
            return Banned();
          } else {
            return Disabled();
          }
        }

        return Container(
          color: Colors.white,
        );
      },
    );
  }
}
