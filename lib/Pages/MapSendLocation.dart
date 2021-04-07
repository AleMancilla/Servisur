import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:taxis_app/Core/ApiUbication.dart';
class MapSendLocation extends StatefulWidget {
  @override
  _MapSendLocationState createState() => _MapSendLocationState();
}

class _MapSendLocationState extends State<MapSendLocation> {

  Position position;
  ApiUbication apiUbication = ApiUbication();


  StreamController streamController;

  void onPauseHandler() {
    print('on Pause');
  }

  @override
  void initState() { 
    super.initState();
    getUbication();

    // streamController = new StreamController(
    //     onPause: onPauseHandler,
    //   );
  
    //   StreamSubscription subscription;

    StreamSubscription<Position> positionStream = Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.best,
      // distanceFilter: 2,
      intervalDuration: Duration(seconds: 10),
      timeInterval: 10
    ).listen(
      (Position position) {
          print(position == null ? 'Unknown' : position.latitude.toString() + ', ' + position.longitude.toString());
      });
    
      // subscription = streamController.stream.listen((data) {
      //   print("DataReceived: " + data);
 
      //   // Add 5 seconds delay
      //   // It will call onPause function passed on StreamController constructor
      //   subscription.pause(Future.delayed(const Duration(seconds: 5)));
      // }, onDone: () {
      //   print("Task Done");
      // }, onError: (error) {
      //   print("Some Error");
      // });
  }

  getUbication()async{
    position = await apiUbication.determinePosition();
    print("===> $position");
    // try {
    //   setState(() {});  
    // } catch (e) {
    // }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.red,
      ),
    );
  }
}