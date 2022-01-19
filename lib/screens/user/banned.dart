import 'package:flutter/material.dart';
import 'package:mycombi/screens/login/login_screen.dart';

class Banned extends StatelessWidget {
  const Banned({Key? key}) : super(key: key);

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
                'Vaš račun je bil benan!',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
              SizedBox(height: 20),
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
        ),
      ),
    ));
  }
}
