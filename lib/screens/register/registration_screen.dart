import 'package:flutter/material.dart';
import 'package:mycombi/screens/register/stateful_register.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.red),
        elevation: 0.0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const <Widget>[
                Image(
                  image: AssetImage('assets/images/van.png'),
                  height: 100,
                ),
                const SizedBox(
                  height: 20,
                ),
                RegisterForm()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
