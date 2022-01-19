import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:images_picker/images_picker.dart';
import 'package:mycombi/screens/components/services/kombi.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:mycombi/screens/user/user_screen.dart';

class DodajKombiO extends StatefulWidget {
  final Kombi kombi;
  final String id;

  DodajKombiO({Key? key, required this.kombi, required this.id})
      : super(key: key);

  @override
  _DodajKombiOState createState() => _DodajKombiOState();
}

class _DodajKombiOState extends State<DodajKombiO> {
  CollectionReference vsikombiji =
      FirebaseFirestore.instance.collection('kombiji');
  final _FormKey = GlobalKey<FormState>();
  FirebaseStorage _storageRef = FirebaseStorage.instance;

  List<Media>? slike;
  List<String>? potSlik = [];
  final opisEditingController = TextEditingController();
  final cenaEditingController = TextEditingController();

  Future getImage() async {
    slike = await ImagesPicker.pick(count: 3, pickType: PickType.image);

    setState(() {
      potSlik = [];
      for (var item in slike!) {
        potSlik!.add(item.path);
      }
    });
  }

  void uploadFunction(List<Media> Slike) {
    if (slike!.isEmpty) return;
    for (int i = 0; i < slike!.length; i++) {
      uploadImage(slike![i], i);
    }
  }

  Future uploadImage(Media Slika, int i) async {
    Reference reference =
        _storageRef.ref().child(widget.id.toString()).child(i.toString());
    UploadTask uploadTask = reference.putFile(File(Slika.path));
    await uploadTask.whenComplete(() async {
      String download = await _storageRef
          .ref()
          .child(widget.id.toString())
          .child(i.toString())
          .getDownloadURL();
      vsikombiji.doc(widget.id).update(({'slika $i': download.toString()}));
    });
  }

  Future<void> postToFirestore() {
    CollectionReference dodajkombi =
        FirebaseFirestore.instance.collection('kombiji');

    List<dynamic> haha = [];

    return dodajkombi.doc(widget.id).update({
      'kid': widget.id,
      'dateTime': DateTime.now(),
      'opis': opisEditingController.text,
      'cena': cenaEditingController.text,
      'arr': haha
    }).then((value) => {
          Navigator.pop(context),
          Navigator.pop(context),
          Fluttertoast.showToast(msg: "Kombi je dodan v pregled")
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            vsikombiji.doc(widget.id).delete();
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.red),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _FormKey,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Stack(alignment: Alignment.center, children: <Widget>[
                    ImageSlideshow(
                      /// Width of the [ImageSlideshow].
                      width: double.infinity,

                      /// Height of the [ImageSlideshow].
                      height: 170,

                      /// The page to show when first creating the [ImageSlideshow].
                      initialPage: 0,

                      /// The color to paint the indicator.
                      indicatorColor: Colors.blue,

                      /// The color to paint behind th indicator.
                      indicatorBackgroundColor: Colors.grey,

                      /// The widgets to display in the [ImageSlideshow].
                      /// Add the sample image file into the images folder
                      children: [
                        potSlik!.length < 1
                            ? Image.asset("assets/images/van.png")
                            : Image.asset(potSlik![0]),
                        potSlik!.length < 2
                            ? Visibility(
                                child: Text("no match"),
                                visible: false,
                              )
                            : Image.asset(potSlik![1]),
                        potSlik!.length < 3
                            ? Visibility(
                                child: Text("no match"),
                                visible: false,
                              )
                            : Image.asset(potSlik![2]),
                      ],
                      onPageChanged: (value) {
                        print('Page changed: $value');
                      },
                      autoPlayInterval: null,

                      isLoop: false,
                    ),
                    ElevatedButton(
                      onPressed: getImage,
                      child: Icon(Icons.add_a_photo, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(20),
                        primary:
                            Colors.grey.withOpacity(0.5), // <-- Button color
                        onPrimary: Colors.black, // <-- Splash color
                      ),
                    )
                  ]),
                ),
                TextFormField(
                  controller: opisEditingController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Napišite opis";
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Opis",
                    contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  maxLines: 5,
                ),
                const SizedBox(height: 10),
                TextFormField(
                    controller: cenaEditingController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Napišite ceno";
                      }
                    },
                    decoration: InputDecoration(
                        hintText: "Cena na dan",
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)))),
                MaterialButton(
                  child: Text("Dodaj"),
                  onPressed: () {
                    if (_FormKey.currentState!.validate()) {
                      if (slike == null) {
                        Fluttertoast.showToast(
                            msg: "Nimate izbrane nobene slike");
                      } else {
                        uploadFunction(slike!);
                        postToFirestore();
                      }
                    }
                  },
                  color: Colors.red,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
