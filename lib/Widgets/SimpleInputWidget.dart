import 'package:flutter/material.dart';

class SimpleInputWidget extends StatelessWidget {
  final TextEditingController textEditingController;
  final String label;

  const SimpleInputWidget({Key key, this.textEditingController, this.label}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: this.textEditingController,
      decoration: InputDecoration(
        labelText: this.label,
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