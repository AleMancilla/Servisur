import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:background_geolocation_plugin/background_geolocation_plugin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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
  bool checkedValue = false;
  double zoomSize = 15;
  CollectionReference taxis = FirebaseFirestore.instance.collection('taxis');

  // StreamController streamController;

  // void onPauseHandler() {
  //   print('on Pause');
  // }
  //
  StreamSubscription<LocationData> positionStream;
  // int i = 0;

  Location location = new Location();

  @override
  void initState() {
    super.initState();
    getstatustaxi();
    getUbication();
    cargarMarker();

    positionStream = location.onLocationChanged.listen((LocationData position) {
      // Use current location
      print('-==========================');
      this.position = position;
      // i = i + 1;
      getUbication(lat: this.position.latitude, long: this.position.longitude);
      // print(position == null
      //         ? 'Unknown'
      //         : position.latitude.toString() +
      //             ', ' +
      //             position.longitude.toString() +
      //             ' __ ' +
      //             // position.floor.toString()  + ' __ ' +
      //             position.accuracy.toString() +
      //             ' __ ' +
      //             position.altitude.toString() +
      //             ' __ ' +
      //             position.heading.toString() +
      //             ' __ ' +
      //             // position.isMocked .toString()  + ' __ ' +
      //             position.speed.toString() +
      //             ' __ ' +
      //             position.speedAccuracy.toString() +
      //             ' __ ' +
      //             position.time.toString()
      //     // position.timestamp.toString()
      //     );
      if (position != null) {
        cambiarMarker();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('=========DIDCHANGE===========');
  }

  cambiarMarker({String status}) {
    _markers = {};
    try {
      setState(() {
        _markers.add(Marker(
          markerId: MarkerId("MIMARCADOR"),
          position: LatLng(position.latitude, position.longitude),
          icon: markerBitMap,
          rotation: position.heading,
          anchor: Offset(0.5, 0.5),
        ));
      });
    } catch (e) {
      print('___ $e');
    }
    try {
      // mapController.animateCamera(CameraUpdate.newCameraPosition(
      // CameraPosition(target: LatLng(position.latitude,position.longitude ), zoom: 16),
      // ));
      taxis
          .doc("${prefs.userMatricula}")
          .update({
            // 'matricula': prefs.userMatricula,
            // 'idFirebase': prefs.userFirebaseId,
            // 'userEmail': prefs.userEmail,
            // 'userPhoto': prefs.userPhotoUrl,
            // 'userName': prefs.userName,
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
            if (status != null) 'status': status
          })
          .then((value) => print("taxi Updated"))
          .catchError((error) => print("Failed to update taxi: $error"));
    } catch (e) {
      print("############ $e #############");
    }
  }

  // Declarado fuera del metodo Build
  GoogleMapController mapController;

  @override
  void dispose() {
    // positionStream.cancel();
    mapController.dispose();
    super.dispose();
  }

  getUbication({double lat, double long}) async {
    try {
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: zoomSize),
      ));
      setState(() {});
    } catch (e) {}
  }

  getstatustaxi() {
    FirebaseFirestore.instance
        .collection('taxis')
        .doc(prefs.userMatricula)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        if (documentSnapshot.data()['status'] != null) {
          if (documentSnapshot.data()['status'] == 'LIBRE') {
            markerBitMap = await BitmapDescriptor.fromAssetImage(
              ImageConfiguration(devicePixelRatio: 2.5),
              'src/icons/carTopGreen.png',
            );
          }
          if (documentSnapshot.data()['status'] == 'EN CAMINO') {
            markerBitMap = await BitmapDescriptor.fromAssetImage(
              ImageConfiguration(devicePixelRatio: 2.5),
              'src/icons/carTopYellow.png',
            );
          }
          if (documentSnapshot.data()['status'] == 'ABORDO') {
            markerBitMap = await BitmapDescriptor.fromAssetImage(
              ImageConfiguration(devicePixelRatio: 2.5),
              'src/icons/carTopRed.png',
            );
          }
        }
      }
    });
  }

  BitmapDescriptor markerBitMap;
  cargarMarker() async {
    markerBitMap = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'src/icons/carTopGreen.png',
    );
  }

  // getUbication() async {
  //   print('ENTRO');
  //   try {
  //     position = await apiUbication.determinePosition();
  //     print("===> $position");
  //     try {
  //       mapController.animateCamera(CameraUpdate.newCameraPosition(
  //         CameraPosition(
  //             target: LatLng(position.latitude, position.longitude), zoom: 15),
  //       ));
  //     } catch (e) {}
  //     setState(() {});
  //   } catch (e) {}
  // }

  CameraPosition positionMap = CameraPosition(
      target: LatLng(-16.482557865279468, -68.1214064732194), zoom: 15);

  // Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.grey[50],
          child: Column(
            children: [
              Container(
                // height: 30,
                child: CheckboxListTile(
                  title: Text("Mostrar trafico"),
                  value: checkedValue,
                  onChanged: (newValue) {
                    setState(() {
                      checkedValue = newValue;
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.leading, //  <-- leading Checkbox
                ),
              ),
              Expanded(
                child: Stack(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: positionMap,
                        markers: _markers,
                        trafficEnabled: checkedValue,
                        indoorViewEnabled: false,
                        myLocationButtonEnabled: true,
                        myLocationEnabled: true,
                        minMaxZoomPreference: MinMaxZoomPreference(10, 19.6),
                        rotateGesturesEnabled: false,
                        scrollGesturesEnabled: true,
                        tiltGesturesEnabled: false,
                        onMapCreated: (controller) {
                          // _controller.complete(controller);
                          mapController = controller;
                          rootBundle
                              .loadString('assets/mapStyle.txt')
                              .then((string) {
                            mapController.setMapStyle(string);
                          });
                        },
                        onCameraMove: (position) {
                          print('===== ZOOOMM ${position.zoom} ');
                          zoomSize = position.zoom;
                        },
                        // onCameraIdle: () {
                        //   print('======= onCameraIdle');
                        // },
                        // onCameraMoveStarted: () {
                        //   print('======= onCameraMoveStarted');
                        // },
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        child: Container(
                          // margin: EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.transparent,
                          width: MediaQuery.of(context).size.width - 100,
                          // width: double.infinity,
                          height: 130,
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            children: [
                              Container(
                                width: 100,
                                padding: const EdgeInsets.all(8.0),
                                child: CupertinoButton(
                                  child: Text('LIBRE'),
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  onPressed: () async {
                                    markerBitMap =
                                        await BitmapDescriptor.fromAssetImage(
                                      ImageConfiguration(devicePixelRatio: 2.5),
                                      'src/icons/carTopGreen.png',
                                    );
                                    cambiarMarker(status: 'LIBRE');

                                    Flushbar(
                                      title: "LIBRE",
                                      message:
                                          "A la espera de nuevas solicitudes",
                                      duration: Duration(seconds: 3),
                                      backgroundColor: Colors.green,
                                    )..show(context);
                                  },
                                  color: Colors.green,
                                ),
                              ),
                              Container(
                                width: 120,
                                padding: const EdgeInsets.all(8.0),
                                child: CupertinoButton(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  child: Text('ABORDO'),
                                  onPressed: () async {
                                    markerBitMap =
                                        await BitmapDescriptor.fromAssetImage(
                                      ImageConfiguration(devicePixelRatio: 2.5),
                                      'src/icons/carTopRed.png',
                                    );
                                    cambiarMarker(status: 'ABORDO');

                                    Flushbar(
                                      title: "ABORDO",
                                      message: "Recogiste al pasajero.",
                                      duration: Duration(seconds: 3),
                                      backgroundColor: Colors.green,
                                    )..show(context);
                                  },
                                  color: Colors.red,
                                ),
                              ),
                              Container(
                                width: 150,
                                padding: const EdgeInsets.all(8.0),
                                child: CupertinoButton(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    'EN CAMINO',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onPressed: () async {
                                    markerBitMap =
                                        await BitmapDescriptor.fromAssetImage(
                                      ImageConfiguration(devicePixelRatio: 2.5),
                                      'src/icons/carTopYellow.png',
                                    );
                                    cambiarMarker(status: 'EN CAMINO');
                                    Flushbar(
                                      title: "EN CAMINO",
                                      message: "Vamos en camino.",
                                      duration: Duration(seconds: 3),
                                      backgroundColor: Colors.green,
                                    )..show(context);
                                  },
                                  color: Colors.yellow,
                                ),
                              ),
                            ],
                          ),
                        )),
                    Positioned(
                      top: 0.0,
                      child: Container(
                        width: 200,
                        child: CupertinoButton(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text("FINALIZAR JORNADA"),
                            color: Colors.green.withOpacity(0.8),
                            onPressed: () async {
                              // MapSendLocation
                              positionStream.cancel();
                              taxis
                                  .doc("${prefs.userMatricula}")
                                  .update({'inJob': false});
                              Navigator.pop(context);
                              await BackgroundGeolocationPlugin
                                  .stopLocationTracking();
                              Flushbar(
                                title: "Dia concluido",
                                message:
                                    "Tu ubicacion dejara de ser compartida.",
                                duration: Duration(seconds: 3),
                                backgroundColor: Colors.green,
                              )..show(context);
                            }),
                      ),
                    )
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
