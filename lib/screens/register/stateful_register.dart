import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mycombi/screens/components/services/user_model.dart';
import 'package:mycombi/screens/components/widgets/mojtextfield.dart';
import 'package:mycombi/screens/login/login_screen.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  String? errorMessage;

  final _auth = FirebaseAuth.instance;

  final firstNameEditingController = TextEditingController();
  final priimekEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmPasswordEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future signUp(String email, String password) async {
      if (_formKey.currentState!.validate()) {
        try {
          await _auth
              .createUserWithEmailAndPassword(email: email, password: password)
              .then(
                  (value) => {postDetailsToFirestore(), Navigator.pop(context)})
              .catchError((e) {
            Fluttertoast.showToast(msg: e!.message);
          });
        } on FirebaseAuthException catch (error) {
          switch (error.code) {
            case "invalid-email":
              errorMessage = "Napačen email";
              break;
            case "wrong-password":
              errorMessage = "Napačno geslo";
              break;
            case "user-not-found":
              errorMessage = "User with this email doesn't exist.";
              break;
            case "user-disabled":
              errorMessage = "User with this email has been disabled.";
              break;
            case "too-many-requests":
              errorMessage = "Preveč prošenj";
              break;

            default:
              errorMessage = "Neznana napaka.";
          }
          Fluttertoast.showToast(msg: errorMessage!);
        }
      }
    }

    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            signUp(emailEditingController.text, passwordEditingController.text);
          },
          child: const Text(
            "Sign Up",
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
          MojTextField(
              controller: firstNameEditingController,
              obs: false,
              action: TextInputAction.next,
              hint: "Ime"),
          const SizedBox(
            height: 10,
          ),
          MojTextField(
              controller: priimekEditingController,
              obs: false,
              action: TextInputAction.next,
              hint: "Priimek"),
          const SizedBox(
            height: 10,
          ),
          MojTextField(
            controller: emailEditingController,
            obs: false,
            action: TextInputAction.next,
            hint: "Email",
          ),
          const SizedBox(
            height: 10,
          ),
          MojTextField(
              controller: passwordEditingController,
              obs: true,
              action: TextInputAction.next,
              hint: "Geslo"),
          const SizedBox(
            height: 10,
          ),
          MojTextField(
            controller: confirmPasswordEditingController,
            obs: true,
            action: TextInputAction.done,
            hint: "Ponovi geslo",
            asd: (value) {
              if (confirmPasswordEditingController.text.length > 6 &&
                  passwordEditingController.text != value) {
                return "Gesli se neujemata.";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 25,
          ),
          signUpButton
        ],
      ),
    );
  }

  Future<void> postDetailsToFirestore() {
    CollectionReference dodajuser =
        FirebaseFirestore.instance.collection('uporabniki');

    List<dynamic> haha = [];
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();
    userModel.uid = user!.uid;
    userModel.ime = firstNameEditingController.text;
    userModel.priimek = priimekEditingController.text;
    userModel.email = user.email;
    userModel.state = 'Disabled';
    userModel.sposojeniKombiji = haha;

    return dodajuser.doc(user.uid).set(userModel.toMap()).then(
        (value) => {Fluttertoast.showToast(msg: "Uporabnik uspešno dodan")});
  }
}
