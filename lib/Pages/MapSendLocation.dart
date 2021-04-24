import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:taxis_app/Core/ApiUbication.dart';
import 'package:taxis_app/Core/User_Preferens.dart';

class MapSendLocation extends StatefulWidget {
  @override
  _MapSendLocationState createState() => _MapSendLocationState();
}

class _MapSendLocationState extends State<MapSendLocation> {
  UserPreferences prefs = UserPreferences();
  LocationData position;
  ApiUbication apiUbication = ApiUbication();

  CollectionReference taxis = FirebaseFirestore.instance.collection('taxis');

  // StreamController streamController;

  // void onPauseHandler() {
  //   print('on Pause');
  // }
  //
  StreamSubscription<LocationData> positionStream;
  int i = 0;

  Location location = new Location();

  @override
  void initState() {
    super.initState();
    getUbication();
    cargarMarker();

    positionStream = location.onLocationChanged.listen((LocationData position) {
      // Use current location
      _markers = {};
      this.position = position;
      i = i + 1;

      print(position == null
              ? 'Unknown'
              : position.latitude.toString() +
                  ', ' +
                  position.longitude.toString() +
                  ' __ ' +
                  // position.floor.toString()  + ' __ ' +
                  position.accuracy.toString() +
                  ' __ ' +
                  position.altitude.toString() +
                  ' __ ' +
                  position.heading.toString() +
                  ' __ ' +
                  // position.isMocked .toString()  + ' __ ' +
                  position.speed.toString() +
                  ' __ ' +
                  position.speedAccuracy.toString() +
                  ' __ ' +
                  position.time.toString()
          // position.timestamp.toString()
          );
      if (position != null) {
        setState(() {
          _markers.add(Marker(
            markerId: MarkerId("MIMARCADOR"),
            position: LatLng(position.latitude, position.longitude),
            icon: markerBitMap,
            rotation: position.heading,
            anchor: Offset(0.5, 0.5),
          ));
          try {
            // mapController.animateCamera(CameraUpdate.newCameraPosition(
            // CameraPosition(target: LatLng(position.latitude,position.longitude ), zoom: 16),
            // ));
            taxis
                .doc("${prefs.userMatricula}")
                .set({
                  'matricula': prefs.userMatricula,
                  'idFirebase': prefs.userFirebaseId,
                  'userEmail': prefs.userEmail,
                  'userPhoto': prefs.userPhotoUrl,
                  'userName': prefs.userName,
                  'latitude': position.latitude.toString(),
                  'longitude': position.longitude.toString(),
                  // 'floor':position.floor.toString(),
                  'accuracy': position.accuracy.toString(),
                  'altitude': position.altitude.toString(),
                  'heading': position.heading.toString(),
                  // 'isMocked':position.isMocked .toString(),
                  'speed': position.speed.toString(),
                  'speedAccuracy': position.speedAccuracy.toString(),
                  'time': position.time.toString(),
                })
                .then((value) => print("taxi Updated"))
                .catchError((error) => print("Failed to update taxi: $error"));
          } catch (e) {
            print("############ $e #############");
          }
        });
      }
    });

    // positionStream = Geolocator.getPositionStream(
    //   desiredAccuracy: LocationAccuracy.best,
    //   distanceFilter: 2,
    //   // intervalDuration: Duration(seconds: 1),
    //   // forceAndroidLocationManager: true
    //   // timeInterval: 1
    // ).listen(
    //   (LocationData position) {
    //       _markers = {};
    //       this.position = position;
    //       i = i+1;
    //       print(position == null ? 'Unknown' :
    //         position.latitude.toString() + ', ' +
    //         position.longitude.toString() + ' __ ' +
    //         position.floor.toString()  + ' __ ' +
    //         position.accuracy.toString()  + ' __ ' +
    //         position.altitude.toString()  + ' __ ' +
    //         position.heading.toString()  + ' __ ' +
    //         position.isMocked .toString()  + ' __ ' +
    //         position.speed.toString()  + ' __ ' +
    //         position.speedAccuracy.toString()  + ' __ ' +
    //         position.timestamp.toString()
    //       );
    //       if(position != null){
    //         setState(() {
    //           _markers.add(
    //           Marker(
    //             markerId: MarkerId("MIMARCADOR"),
    //             position: LatLng(position.latitude,position.longitude ),
    //             icon: markerBitMap,
    //             )
    //           );
    //           try {
    //             // mapController.animateCamera(CameraUpdate.newCameraPosition(
    //             // CameraPosition(target: LatLng(position.latitude,position.longitude ), zoom: 16),
    //             // ));
    //             taxis
    //             .doc("${prefs.userMatricula}")
    //             .set({
    //               'matricula':prefs.userMatricula,
    //               'idFirebase':prefs.userFirebaseId,
    //               'userEmail':prefs.userEmail,
    //               'userPhoto':prefs.userPhotoUrl,
    //               'userName':prefs.userName,
    //               'latitude':position.latitude.toString(),
    //               'longitude':position.longitude.toString(),
    //               'floor':position.floor.toString(),
    //               'accuracy':position.accuracy.toString(),
    //               'altitude':position.altitude.toString(),
    //               'heading':position.heading.toString(),
    //               'isMocked':position.isMocked .toString(),
    //               'speed':position.speed.toString(),
    //               'speedAccuracy':position.speedAccuracy.toString(),
    //               'timestamp':position.timestamp.toString(),
    //             })
    //             .then((value) => print("taxi Updated"))
    //             .catchError((error) => print("Failed to update taxi: $error"));
    //           } catch (e) {
    //             print("############ $e #############");
    //           }
    //         });

    //       }
    //   });
  }

  // Declarado fuera del metodo Build
  GoogleMapController mapController;

  @override
  void dispose() {
    positionStream.cancel();
    super.dispose();
  }

  BitmapDescriptor markerBitMap;
  cargarMarker() async {
    markerBitMap = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'src/icons/carTop.png',
    );
  }

  getUbication() async {
    try {
      position = await apiUbication.determinePosition();
      print("===> $position");
      try {
        mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(position.latitude, position.longitude), zoom: 16),
        ));
      } catch (e) {}
      setState(() {});
    } catch (e) {}
  }

  CameraPosition positionMap = CameraPosition(
      target: LatLng(-16.482557865279468, -68.1214064732194), zoom: 16);

  // Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.grey[50],
          child: Stack(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: positionMap,
                  markers: _markers,
                  trafficEnabled: false,
                  indoorViewEnabled: false,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  minMaxZoomPreference: MinMaxZoomPreference(12, 19.6),
                  rotateGesturesEnabled: false,
                  scrollGesturesEnabled: true,
                  tiltGesturesEnabled: false,
                  onMapCreated: (controller) {
                    // _controller.complete(controller);
                    mapController = controller;
                    rootBundle.loadString('assets/mapStyle.txt').then((string) {
                      mapController.setMapStyle(string);
                    });
                  },
                ),
              ),
              Positioned(
                  bottom: 0,
                  child: Container(
                    // margin: EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.red,
                    width: double.infinity,
                    height: 200,
                  ))
              // Text("  == Datos transferidos           = $i ="),
              // if(position?.latitude!=null)Text("  == Latitude                = ${position.latitude} ="),
              // if(position?.longitude!=null)Text("  == Longitude              = ${position.longitude} ="),
              // // if(position?.floor!=null)Text("  == floor                      = ${position.floor} ="),
              // if(position?.accuracy!=null)Text("  == accuracy                = ${position.accuracy} ="),
              // if(position?.altitude!=null)Text("  == Altitude                   = ${position.altitude} ="),
              // if(position?.heading!=null)Text("  == heading                   = ${position.heading} ="),
              // // if(position?.isMocked!=null)Text("  == isMocked                = ${position.isMocked} ="),
              // if(position?.speed!=null)Text("  == Velocidad               = ${position.speed} "),
              // if(position?.speedAccuracy!=null)Text("  == Aceleracion            = ${position.speedAccuracy} ="),
              // if(position?.time!=null)Text("  == time              = ${position.time} ="),
            ],
          ),
        ),
      ),
    );
  }

  //////////////////////////////////////////////
  ///
  Set<Marker> _markers = {};
}
