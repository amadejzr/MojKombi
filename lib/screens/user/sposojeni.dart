import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SposojeniKombiji extends StatefulWidget {
  final String uid;
  const SposojeniKombiji({Key? key, required this.uid}) : super(key: key);

  @override
  _SposojeniKombijiState createState() => _SposojeniKombijiState();
}

User? user = FirebaseAuth.instance.currentUser;

class _SposojeniKombijiState extends State<SposojeniKombiji> {
  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('uporabniki');
    return Scaffold(
        appBar: AppBar(),
        body: FutureBuilder<DocumentSnapshot>(
          future: users.doc(widget.uid).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.hasData && !snapshot.data!.exists) {
              return Text("Document does not exist");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;

              List<dynamic> haha = data['sposojeniKombiji'];

              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: haha.length,
                  itemBuilder: (context, index) {
                    var a = haha[index].split(" ");
                    print(a);
                    return ListTile(
                      title: Text("Kombi je sposojen "),
                      subtitle: Text("Od: " + a[1] + " Do: " + a[2]),
                    );
                  },
                );
              }
            }

            return Text("loading");
          },
        ));
  }
}
