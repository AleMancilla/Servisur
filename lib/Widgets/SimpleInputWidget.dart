import 'package:flutter/material.dart';

class SimpleInputWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "hola",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(
            color: Colors.amber,
            style: BorderStyle.solid,
          ),
        ),
      ),
    );
  }
}