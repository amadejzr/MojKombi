import 'package:flutter/material.dart';

class MojTextField extends StatefulWidget {
  final TextEditingController controller;
  final bool obs;
  final TextInputAction action;
  final String hint;
  final FormFieldValidator? asd;

  const MojTextField(
      {Key? key,
      required this.controller,
      required this.obs,
      required this.action,
      required this.hint,
      this.asd})
      : super(key: key);

  @override
  _MojTextFieldState createState() => _MojTextFieldState();
}

class _MojTextFieldState extends State<MojTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: false,
      controller: widget.controller,
      obscureText: widget.obs,
      validator: widget.asd,
      onSaved: (value) {
        widget.controller.text = value!;
      },
      textInputAction: widget.action,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: widget.hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
    );
  }
}
