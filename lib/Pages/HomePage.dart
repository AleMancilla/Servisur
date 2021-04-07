import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taxis_app/Pages/MapSendLocation.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.orange,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoButton(
              child: Text("Obtener Ubicacion"),
              color: Colors.green, 
              onPressed: (){
                // MapSendLocation
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (BuildContext context) => MapSendLocation())
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}