import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxis_app/Core/ApiUbication.dart';
class MapSendLocation extends StatefulWidget {
  final FirebaseApp app;

  const MapSendLocation({Key key, this.app}) : super(key: key);
  @override
  _MapSendLocationState createState() => _MapSendLocationState();
}

class _MapSendLocationState extends State<MapSendLocation> {

  Position position;
  ApiUbication apiUbication = ApiUbication();


  // StreamController streamController;

  // void onPauseHandler() {
  //   print('on Pause');
  // }
  // 
  StreamSubscription<Position> positionStream;
  int i = 0;

  
  @override
  void initState() { 
    super.initState();
    getUbication();
    cargarMarker();
    positionStream = Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.best,
      // distanceFilter: 1,
      intervalDuration: Duration(seconds: 1),
      // timeInterval: 1
    ).listen(
      (Position position) {
          _markers = {};
          i = i+1;
          print(position == null ? 'Unknown' : 
            position.latitude.toString() + ', ' + 
            position.longitude.toString() + ' __ ' +
            position.floor.toString()  + ' __ ' +
            position.accuracy.toString()  + ' __ ' +
            position.altitude.toString()  + ' __ ' +
            position.heading.toString()  + ' __ ' +
            position.isMocked .toString()  + ' __ ' +
            position.speed.toString()  + ' __ ' +
            position.speedAccuracy.toString()  + ' __ ' +
            position.timestamp.toString()
          );
          if(position != null){
            setState(() {
              _markers.add(
              Marker(
                markerId: MarkerId("MIMARCADOR"),
                position: LatLng(position.latitude,position.longitude ),
                icon: markerBitMap,
                )
              );
              try {
                mapController.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(target: LatLng(position.latitude,position.longitude ), zoom: 16),
                )); 
              } catch (e) {
              }
            });
          }
      });


  }

  // Declarado fuera del metodo Build
  GoogleMapController mapController;

  @override
  void dispose() { 
    positionStream.cancel();
    super.dispose();
  }


  BitmapDescriptor markerBitMap;
  cargarMarker()async{
     markerBitMap = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),'src/icons/markerTaxi.png');
  }

  getUbication()async{
    try {
      position = await apiUbication.determinePosition();
      print("===> $position");
      setState(() {});  
    } catch (e) {
    }
  }

  CameraPosition positionMap = CameraPosition(
    target: LatLng(-16.482557865279468, -68.1214064732194),
    zoom: 16
  );

  // Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.red,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: positionMap,
                  markers: _markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  minMaxZoomPreference: MinMaxZoomPreference(12, 18.6),
                  rotateGesturesEnabled: false,
                  scrollGesturesEnabled: true,
                  tiltGesturesEnabled: false,
                  onMapCreated: (controller) {
                    // _controller.complete(controller);
                    mapController = controller;
                  },
                ),
              ),
              Text("  == SETSTATE           = $i ="),
              if(position?.latitude!=null)Text("  == latitude           = ${position.latitude} ="),
              if(position?.longitude!=null)Text("  == longitude          = ${position.longitude} ="),
              if(position?.floor!=null)Text("  == floor              = ${position.floor} ="),
              if(position?.accuracy!=null)Text("  == accuracy           = ${position.accuracy} ="),
              if(position?.altitude!=null)Text("  == altitude           = ${position.altitude} ="),
              if(position?.heading!=null)Text("  == heading            = ${position.heading} ="),
              if(position?.isMocked!=null)Text("  == isMocked           = ${position.isMocked} ="),
              if(position?.speed!=null)Text("  == speed              = ${position.speed} "),
              if(position?.speedAccuracy!=null)Text("  == speedAccuracy      = ${position.speedAccuracy} ="),
              if(position?.timestamp!=null)Text("  == timestamp          = ${position.timestamp} ="),

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