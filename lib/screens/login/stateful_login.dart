import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mycombi/screens/admin/admin_screen.dart';
import 'package:mycombi/screens/components/roles.dart';

class Loginform extends StatefulWidget {
  const Loginform({Key? key}) : super(key: key);

  @override
  _LoginformState createState() => _LoginformState();
}

class _LoginformState extends State<Loginform> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String? errorMessage;
  CollectionReference users =
      FirebaseFirestore.instance.collection('uporabniki');

  @override
  Widget build(BuildContext context) {
    void signIn(String email, String password) async {
      if (_formKey.currentState!.validate()) {
        try {
          await _auth
              .signInWithEmailAndPassword(email: email, password: password)
              .then((uid) => {
                    Fluttertoast.showToast(msg: "Login Successful"),
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const Roles())),
                  });
        } on FirebaseAuthException catch (error) {
          switch (error.code) {
            case "invalid-email":
              errorMessage = "Napačen email.";
              break;
            case "wrong-password":
              errorMessage = "Napačno geslo.";
              break;
            case "user-not-found":
              errorMessage = "Uporabnik ne obstaja.";
              break;
            case "user-disabled":
              errorMessage = "Uporabnik je disejblan";
              break;
            case "too-many-requests":
              errorMessage = "Preveč prošenj, počakajte malo.";
              break;
            case "operation-not-allowed":
              errorMessage =
                  "Signing in with Email and Password is not enabled.";
              break;
            default:
              errorMessage = "Neznana napaka";
          }
          Fluttertoast.showToast(msg: errorMessage!);
        }
      }
    }

    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Vnesite email");
        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Vnesite pravilen email");
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
    );

    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Vnesite geslo.");
        }
        if (!regex.hasMatch(value)) {
          return ("Vnesite  pravilno geslo (Min. 6 znakov)");
        }
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Geslo",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
    );

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            signIn(emailController.text, passwordController.text);
          },
          child: const Text(
            "Prijava",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          emailField,
          const SizedBox(
            height: 10,
          ),
          passwordField,
          const SizedBox(height: 15),
          loginButton
        ],
      ),
    );
  }
}
