import 'package:flutter/material.dart';

import 'package:mycombi/screens/register/registration_screen.dart';

import 'stateful_login.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: <Widget>[
                const Image(
                  image: AssetImage('assets/images/van.png'),
                  height: 200,
                ),
                const SizedBox(
                  height: 30,
                ),
                //Image(image: AssetImage('/Users/amadejjerlah/Developer/mojkombi/assets/logo.png'),),
                const Loginform(),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text("Nimate računa?"),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const RegistrationScreen()));
                      },
                      child: const Text(
                        " Registrirajte se!",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
