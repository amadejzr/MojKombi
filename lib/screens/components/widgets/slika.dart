import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class Slika extends StatelessWidget {
  const Slika({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image(
      image: AssetImage('assets/images/van.png'),
    );
  }
}
