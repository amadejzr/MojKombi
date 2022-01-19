import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

import 'package:mycombi/screens/components/services/user_model.dart';
import 'package:mycombi/screens/login/login_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mycombi/screens/user/rezervirajKombi.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mycombi/screens/user/sposojeni.dart';

import 'dodajkombi.dart';
import 'mojiKombiji.dart';

class UserScreen extends StatefulWidget {
  final String id;
  const UserScreen({Key? key, required this.id}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut().then((value) => Navigator.of(context)
        .pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen())));
  }

  final CollectionReference cart =
      FirebaseFirestore.instance.collection('kombiji');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            backgroundColor: Colors.red.withOpacity(0.9),
            title: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: const Image(
                image: AssetImage("assets/images/van.png"),
                height: 50.0,
                width: 50.0,
              ),
            )),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red.withOpacity(0.9),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VanInfo(),
                ));
          },
          child: const Icon(Icons.add),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.red,
                ),
                child: Image(
                  image: AssetImage('assets/images/van.png'),
                ),
              ),
              ListTile(
                title: const Text('Home'),
                selected: true,
                selectedColor: Colors.red,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Moji kombiji'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (builder) => MojiKombiji()));
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                title: const Text('Sposojeni kombiji'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (builder) => SposojeniKombiji(uid: user!.uid)));
                },
              ),
              Divider(),
              ListTile(
                title: Center(
                  child: const Text(
                    'Log out',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                onTap: () {
                  logout(context);
                },
              ),
            ],
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('kombiji')
              .where('approved', isEqualTo: true)
              .where('uid', isNotEqualTo: user!.uid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error?.toString());
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;

                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (builder) => Test(documentId: data['kid'])));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 20, top: 20, left: 30, right: 30),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(30)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5, bottom: 5, right: 5, left: 5),
                                  child: Image.network(
                                    data['slika 0'],
                                    height: 200,
                                    width: double.infinity,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.red),
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(data['znamka']),
                                        Text(data['model'] +
                                            " " +
                                            data['gorivo']),
                                        Text("Letnik: " + data['leto']),
                                        Text(data['opis']),
                                        Divider(),
                                        Center(
                                            child: Text(
                                          "Cena na dan: " + data['cena'] + "€",
                                          style: const TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        )),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ));
  }
}
