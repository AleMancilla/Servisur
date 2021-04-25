import 'package:background_geolocation_plugin/background_geolocation_plugin.dart';
import 'package:background_geolocation_plugin/location_item.dart';
import 'package:background_geolocation_plugin/measure_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taxis_app/Core/User_Preferens.dart';
import 'package:taxis_app/Pages/MapSendLocation.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserPreferences prefs = UserPreferences();
  CollectionReference taxis = FirebaseFirestore.instance.collection('taxis');

  String _platformVersion = 'Unknown';
  String resultMsg = 'Unknown';
  List<LocationItem> allLocations = [];
  MeasureState currentState;

  void execMethod(methodName) async {
    var res = "";
    try {
      if (methodName == "startLocationTracking") {
        res = await BackgroundGeolocationPlugin.startLocationTracking();
      } else if (methodName == "stopLocationTracking") {
        res = await BackgroundGeolocationPlugin.stopLocationTracking();
      } else if (methodName == "pauseLocationTracking") {
        res = await BackgroundGeolocationPlugin.pauseLocationTracking();
      } else if (methodName == "continueLocationTracking") {
        res = await BackgroundGeolocationPlugin.continueLocationTracking();
      } else if (methodName == "getState") {
        currentState = await BackgroundGeolocationPlugin.getState();
        res =
            '${currentState.isBinded}__${currentState.isRunning}__${currentState.metadata}';
      } else if (methodName == "requestPermissions") {
        res = await BackgroundGeolocationPlugin.requestPermissions();
      } else if (methodName == "getAllLocations") {
        List<LocationItem> items =
            await BackgroundGeolocationPlugin.getAllLocations();
        allLocations = items;
        res = "all stored locations size " + items.length.toString();
      } else if (methodName == "getNewLocations") {
        var time = allLocations.last.time;
        List<LocationItem> items = await BackgroundGeolocationPlugin
            .getAllStoredLocationsWithTimeBiggerThan(time);
        allLocations.addAll(items);
        res = "Got " + items.length.toString() + " new locations";
      }
    } on PlatformException catch (e) {
      res = "Error, code: " +
          e.code +
          ", message: " +
          e.message +
          ", details: " +
          e.details;
    }

    setState(() {
      resultMsg = "Result for: " + methodName + ": " + res;
    });
  }

  @override
  void initState() {
    // activarSegundoPlano();
    super.initState();
  }

  activarSegundoPlano() async {
    try {
      currentState = await BackgroundGeolocationPlugin.getState();
      bool state = currentState.isBinded;
      if (state) {
        await BackgroundGeolocationPlugin.stopLocationTracking();
      }
      await BackgroundGeolocationPlugin.startLocationTracking();
    } catch (e) {
      print('__ERROR __ $e');
    }
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
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Conductor: ${prefs.userName}',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.w500),
            ),
            // SizedBox(
            //   height: 15,
            // ),
            Text(
              'Numero: ${prefs.userPhone}',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              'Codigo: ${prefs.userMatricula}',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 25,
            ),
            Divider(),
            CupertinoButton(
                child: Text("EMPEZAR JORNADA"),
                color: Colors.green,
                onPressed: () async {
                  // MapSendLocation

                  taxis.doc("${prefs.userMatricula}").update({'inJob': true});
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              MapSendLocation()));
                  activarSegundoPlano();
                }),

            // ////////////////////////////////
            // Text(resultMsg),
            // RaisedButton(
            //   onPressed: () {
            //     execMethod("startLocationTracking");
            //   },
            //   child: Text("startLocationTracking"),
            // ),
            // RaisedButton(
            //   onPressed: () {
            //     execMethod("stopLocationTracking");
            //   },
            //   child: Text("stopLocationTracking"),
            // ),
            // RaisedButton(
            //   onPressed: () {
            //     execMethod("pauseLocationTracking");
            //   },
            //   child: Text("pauseLocationTracking"),
            // ),
            // RaisedButton(
            //   onPressed: () {
            //     execMethod("continueLocationTracking");
            //   },
            //   child: Text("continueLocationTracking"),
            // ),
            // RaisedButton(
            //   onPressed: () {
            //     execMethod("getState");
            //   },
            //   child: Text("getState"),
            // ),
            // RaisedButton(
            //   onPressed: () {
            //     execMethod("requestPermissions");
            //   },
            //   child: Text("requestPermissions"),
            // ),
            // RaisedButton(
            //   onPressed: () {
            //     execMethod("getAllLocations");
            //   },
            //   child: Text("getAllLocations"),
            // ),
            // RaisedButton(
            //   onPressed: () {
            //     execMethod("getNewLocations");
            //   },
            //   child: Text("getNewLocations"),
            // ),
          ],
        ),
      ),
    );
  }
}
