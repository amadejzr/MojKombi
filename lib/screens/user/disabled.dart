import 'package:flutter/material.dart';
import 'package:mycombi/screens/login/login_screen.dart';

class Disabled extends StatelessWidget {
  const Disabled({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Prosim počakajte, še pregledujemo vaše podatke.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 10,
              color: Colors.redAccent,
              child: MaterialButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                },
                child: const Text("Nazaj"),
              ),
            )
          ],
        ),
      )),
    ));
  }
}
