import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mycombi/screens/components/services/user_model.dart';

class UserData extends StatefulWidget {
  const UserData({Key? key}) : super(key: key);

  @override
  _UserDataState createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("uporabniki")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      loggedInUser.email.toString(),
      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
    ));
  }
}
