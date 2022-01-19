import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mycombi/screens/components/widgets/datepicker.dart';

import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class Test extends StatelessWidget {
  final String documentId;

  Test({Key? key, required this.documentId}) : super(key: key);

  CollectionReference users = FirebaseFirestore.instance.collection('kombiji');

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {}

  final DateRangePickerController _controller = DateRangePickerController();
  late String _startDate, _endDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: FutureBuilder<DocumentSnapshot>(
          future: users.doc(documentId).get(),
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

              List<dynamic> datumi = data['arr'];

              var arr = [
                data['slika 0'].toString(),
                data['slika 1'].toString(),
                data['slika 2'].toString()
              ];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: ImageSlideshow(
                          /// Width of the [ImageSlideshow].
                          width: double.infinity,

                          /// Height of the [ImageSlideshow].
                          height: 200,

                          /// The page to show when first creating the [ImageSlideshow].
                          initialPage: 0,

                          /// The color to paint the indicator.
                          indicatorColor: Colors.blue,

                          /// The color to paint behind th indicator.
                          indicatorBackgroundColor: Colors.grey,

                          /// The widgets to display in the [ImageSlideshow].
                          /// Add the sample image file into the images folder
                          children: [
                            arr.length < 1
                                ? Image.asset("assets/images/van.png")
                                : Image.network(arr[0]),
                            arr[1] == "null"
                                ? const Visibility(
                                    child: Text("no match"),
                                    visible: false,
                                  )
                                : Image.network(arr[1]),
                            arr[2] == "null"
                                ? const Visibility(
                                    child: Text("no match"),
                                    visible: false,
                                  )
                                : Image.network(arr[2]),
                          ],
                          onPageChanged: (value) {
                            print('Page changed: $value');
                          },
                          autoPlayInterval: null,

                          isLoop: false,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(30)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Znamka: ${data['znamka']}'),
                                Text('Model: ${data['model']}'),
                                Text('Letnik: ${data['leto']}'),
                                Text('Gorivo: ${data['gorivo']}'),
                                Text('Opis: ${data['opis']}'),
                              ]),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text('Cena na dan: ${data['cena']}'),
                      const SizedBox(
                        height: 20,
                      ),
                      const Center(
                        child: Text(
                          "Izberi datum za rezervacijo",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.redAccent),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SfDate(
                        documentId: documentId,
                        datumi: datumi,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              );
            }

            return const Text("loading");
          },
        ));
  }
}
