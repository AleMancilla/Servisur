import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:taxis_app/Core/ApiUbication.dart';
import 'package:taxis_app/Core/User_Preferens.dart';
import 'package:taxis_app/Pages/MapSendLocation.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position position;
  ApiUbication apiUbication = ApiUbication();
  final UserPreferences prefs = UserPreferences();

  getUbication()async{
      position = await apiUbication.determinePosition();
  }

  @override
  void initState() {
    getUbication();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.network(
                prefs.userPhotoUrl,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 15,),
            Text(prefs.userName,
              style: TextStyle(fontSize: 18,color: Colors.blueGrey,fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 15,),
            Text(prefs.userMatricula,
              style: TextStyle(fontSize: 18,color: Colors.blueGrey,fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 25,),
            Divider(),
            CupertinoButton(
              child: Text("Reportar Ubicacion"),
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