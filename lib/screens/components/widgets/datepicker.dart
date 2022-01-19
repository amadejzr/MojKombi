import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class SfDate extends StatefulWidget {
  final String documentId;
  final List<dynamic> datumi;
  const SfDate({Key? key, required this.documentId, required this.datumi})
      : super(key: key);

  @override
  _SfDateState createState() => _SfDateState();
}

class _SfDateState extends State<SfDate> {
  final DateRangePickerController _controller = DateRangePickerController();
  late DateTime _startDate, _endDate;

  User? user = FirebaseAuth.instance.currentUser;
  void selectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      _startDate = (args.value.startDate);
      _endDate = (args.value.endDate ?? args.value.startDate);
    });
  }

  Future<void> postToFirestore() {
    return FirebaseFirestore.instance
        .collection('kombiji')
        .doc(widget.documentId)
        .collection('datumi')
        .doc()
        .set({
      "zac": _startDate,
      "kon": _endDate,
      'uid': user!.uid,
      'email': user!.email,
      'approved': false,
    }).then((value) => {print("dodano")});
  }

  List<DateTime> haha() {
    List<DateTime> testi = [];
    for (var item in widget.datumi) {
      testi.add(item.toDate());
    }
    return testi;
  }

  @override
  Widget build(BuildContext context) {
    haha();
    return SfDateRangePicker(
      controller: _controller,
      onSelectionChanged: selectionChanged,
      selectionMode: DateRangePickerSelectionMode.range,
      monthViewSettings: DateRangePickerMonthViewSettings(
        blackoutDates: haha(),
      ),
      enablePastDates: false,
      showActionButtons: true,
      onCancel: () {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Canceled"),
          duration: Duration(milliseconds: 300),
        ));
      },
      onSubmit: (value) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Selection Confirmed',
          ),
          duration: Duration(milliseconds: 500),
        ));
        postToFirestore();
      },
    );
  }
}
