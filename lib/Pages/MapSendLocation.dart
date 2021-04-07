import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animarker/lat_lng_interpolation.dart';
import 'package:flutter_animarker/models/lat_lng_delta.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxis_app/Core/ApiUbication.dart';
class MapSendLocation extends StatefulWidget {
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
          print(position == null ? 'Unknown' : position.latitude.toString() + ', ' + position.longitude.toString() + ' __ '+position.floor.toString());
          if(position != null){
            _markers.add(
            Marker(
              markerId: MarkerId("MIMARCADOR"),
              position: LatLng(position.latitude,position.longitude ),
              icon: markerBitMap,
              )
            );
            setState(() {
              
            });
          }
      });
  }

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

  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.red,
          child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: positionMap,
            markers: _markers,
            onMapCreated: (controller) {
              _controller.complete(controller);
            },
          ),
        ),
      ),
    );
  }

  //////////////////////////////////////////////
  ///
  Set<Marker> _markers = {};
  
}