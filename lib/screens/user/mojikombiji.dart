import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mycombi/screens/components/services/user_model.dart';
import 'package:mycombi/screens/user/potrdi_datume.dart';

class MojiKombiji extends StatefulWidget {
  const MojiKombiji({Key? key}) : super(key: key);
  @override
  _MojiKombijiState createState() => _MojiKombijiState();
}

class _MojiKombijiState extends State<MojiKombiji> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('uporabniki')
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  Future delete(String kid) {
    return FirebaseFirestore.instance
        .collection('kombiji')
        .doc(kid)
        .delete()
        .then((value) => print("deleted"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('kombiji')
              .where('uid', isEqualTo: user!.uid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (builder) => PotrdiDatum(
                                kombiId: data['kid'],
                              )));
                    },
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(data['model'] + " " + data['model']),
                          MaterialButton(
                            onPressed: () {
                              delete(data['kid']);
                            },
                            color: Colors.red,
                            child: Text("Izbriši"),
                          )
                        ],
                      ),
                      leading: Text("Approved: " + data['approved'].toString()),
                    ));
              }).toList(),
            );
          },
        ));
  }
}
