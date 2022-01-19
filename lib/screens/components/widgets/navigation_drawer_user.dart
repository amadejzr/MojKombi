import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mycombi/screens/login/login_screen.dart';

class NavigationUserDrawer extends StatelessWidget {
  const NavigationUserDrawer({Key? key}) : super(key: key);

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
          const Divider(color: Colors.black),
          buildMenuItem(
            text: 'Invalidi',
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
      break;
    case 1:
      break;
    case 2:
      break;
    case 3:
      break;
    case 4:
      break;
  }
}
