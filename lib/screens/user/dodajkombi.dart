import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mycombi/screens/components/services/kombi.dart';
import 'package:mycombi/screens/user/dodaj_kombi_o.dart';

class VanInfo extends StatefulWidget {
  const VanInfo({Key? key}) : super(key: key);

  @override
  _VanInfoState createState() => _VanInfoState();
}

class _VanInfoState extends State<VanInfo> {
  final _dropdownFormKey = GlobalKey<FormState>();
  List<DropdownMenuItem<String>> menuItems = [
    DropdownMenuItem(child: Text("Bencin"), value: "Bencin"),
    DropdownMenuItem(child: Text("Diesel"), value: "Diesel"),
    DropdownMenuItem(child: Text("Plin"), value: "Plin"),
    DropdownMenuItem(child: Text("Hibridni pogon"), value: "HibridniP"),
    DropdownMenuItem(child: Text("E-pogon"), value: "ElektricniP"),
  ];

  Kombi kombi = Kombi();
  String? selectedValue = null;
  final _auth = FirebaseAuth.instance;

  final ZnamkaEditingController = TextEditingController();
  final ModelEditingController = TextEditingController();
  final LetoEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.red),
      ),
      body: Form(
          key: _dropdownFormKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Znamka",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                      contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    ),
                    controller: ZnamkaEditingController,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Vnesi znamko";
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: "Model",
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30))),
                    controller: ModelEditingController,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Vnesi model";
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "Leto",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30))),
                    keyboardType: TextInputType.number,
                    controller: LetoEditingController,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Vnesti leto";
                      } else if (value.length != 4) {
                        return "Vnesi pravilno leto";
                      }
                    },
                    onChanged: (text) {
                      if (text.length == 4) {
                        FocusScope.of(context).unfocus();
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: DropdownButtonFormField(
                      validator: (value) =>
                          value == null ? "Izberi gorivo" : null,
                      dropdownColor: Colors.red[50],
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 15, 25, 10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      value: selectedValue,
                      hint: Text("Gorivo"),
                      onChanged: (String? newValue) {
                        selectedValue = newValue!;
                      },
                      items: menuItems),
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_dropdownFormKey.currentState!.validate()) {
                        postToFirestore();
                      }
                    },
                    child: const Icon(Icons.arrow_forward_ios_outlined))
              ],
            ),
          )),
    );
  }

  Future<void> postToFirestore() {
    CollectionReference dodajkombi =
        FirebaseFirestore.instance.collection('kombiji');

    User? user = _auth.currentUser;

    kombi.uid = user!.uid;
    kombi.znamka = ZnamkaEditingController.text;
    kombi.model = ModelEditingController.text;
    kombi.leto = LetoEditingController.text;
    kombi.gorivo = selectedValue;
    kombi.approved = false;

    return dodajkombi.add(kombi.toMap()).then((value) => {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (builder) =>
                      DodajKombiO(kombi: kombi, id: value.id)))
        });
  }
}
