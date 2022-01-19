import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mycombi/screens/admin/admin_screen.dart';
import 'package:mycombi/screens/admin/all_users.dart';
import 'package:mycombi/screens/admin/banned_users.dart';
import 'package:mycombi/screens/admin/kombiji.dart';
import 'package:mycombi/screens/admin/vsi_kombiji.dart';
import 'package:mycombi/screens/components/widgets/user_data.dart';
import '../../login/login_screen.dart';

class MyNavigationdrawer extends StatelessWidget {
  const MyNavigationdrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> logout(BuildContext context) async {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }

    return Drawer(
      child: Container(
          child: ListView(
        children: <Widget>[
          UserData(),
          const Divider(color: Colors.black),
          buildMenuItem(
            text: 'Čakalna vrsta',
            icon: Icons.disabled_by_default,
            onClicked: () => selectedItem(context, 0),
          ),
          buildMenuItem(
            text: 'Banani uporabniki',
            icon: Icons.phone_disabled_sharp,
            onClicked: () => selectedItem(context, 1),
          ),
          buildMenuItem(
            text: 'Uporabniki',
            icon: Icons.verified_user_sharp,
            onClicked: () => selectedItem(context, 2),
          ),
          const Divider(
            color: Colors.grey,
          ),
          buildMenuItem(
            text: 'Kombiji',
            icon: Icons.verified_user_sharp,
            onClicked: () => selectedItem(context, 4),
          ),
          buildMenuItem(
            text: 'Vsi kombiji',
            icon: Icons.verified_user_sharp,
            onClicked: () => {selectedItem(context, 3)},
          ),
          const Divider(
            color: Colors.black,
          ),
          ListTile(
            title: const Center(
                child: Text(
              "Log out",
              style: TextStyle(color: Colors.red),
            )),
            onTap: () {
              logout(context);
            },
          )
        ],
      )),
    );
  }
}

Widget buildMenuItem({
  required String text,
  required IconData icon,
  VoidCallback? onClicked,
}) {
  return ListTile(
    leading: Icon(icon),
    title: Text(text),
    onTap: onClicked,
  );
}

void selectedItem(BuildContext context, int i) {
  Navigator.of(context).pop();
  switch (i) {
    case 0:
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (builder) => Home()));
      break;
    case 1:
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (builder) => BannedUsers()));
      break;
    case 2:
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (builder) => AllUsers()));
      break;
    case 3:
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (builder) => AllCombies()));
      break;
    case 4:
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (builder) => Combies()));
      break;
  }
}
