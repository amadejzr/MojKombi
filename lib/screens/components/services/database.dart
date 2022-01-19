import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  final CollectionReference collectionStream =
      FirebaseFirestore.instance.collection('kombiji');

  Stream<QuerySnapshot> get kombi {
    return collectionStream.where('approved', isEqualTo: true).snapshots();
  }
}
