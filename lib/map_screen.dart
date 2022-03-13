// ignore_for_file: unused_import, use_key_in_widget_constructors, annotate_overrides, prefer_const_constructors, unnecessary_new, deprecated_member_use

import 'dart:async';
import 'package:busmap/home_menu.dart';
import 'package:busmap/navi.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  late GoogleMapController newGoogleMapController;
  final GlobalKey<ScaffoldState> _scarffoldKey = new GlobalKey<ScaffoldState>();
  List<Marker> markers = [];

  @override
  void initState() {
    intilize();
    super.initState();
  }

  intilize() {
    Marker firstMarker = Marker(
      markerId: MarkerId('1'),
      position: LatLng(10.876766353907618, 106.80180790445476),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRed,
      ),
    );
    markers.add(firstMarker);
    setState(() {});
  }

  late Position currentPosition;
  var geoLocator = Geolocator();
  Future locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    LatLng latlngPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
        new CameraPosition(target: latlngPosition, zoom: 17);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  static const _initialCameraPosition = CameraPosition(
      target: LatLng(10.87754733715716, 106.80162827288832), zoom: 15);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scarffoldKey,
      body: SafeArea(
        child: Container(
          constraints: BoxConstraints.expand(),
          color: Colors.black,
          child: Stack(
            children: <Widget>[
              GoogleMap(
                mapType: MapType.normal,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: true,
                zoomGesturesEnabled: true,
                myLocationEnabled: true,
                initialCameraPosition: _initialCameraPosition,
                onMapCreated: (GoogleMapController controller) {
                  _controllerGoogleMap.complete(controller);
                  newGoogleMapController = controller;
                },
                markers: markers.map((e) => e).toSet(),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: Column(
                  children: <Widget>[
                    AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0.0,
                      title: Container(
                          child: Text(
                            "BusRoute",
                            style: TextStyle(color: Colors.black),
                          ),
                          alignment: Alignment.topLeft),
                      leading: FlatButton(
                          onPressed: () {
                            _scarffoldKey.currentState!.openDrawer();
                          },
                          child:
                              Image(image: AssetImage("assets/neww_menu.png"))),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.bottomRight,
                margin: EdgeInsets.only(bottom: 100, left: 330),
                child: FlatButton(
                    shape: CircleBorder(),
                    color: Colors.blue,
                    onPressed: locatePosition,
                    child: Icon(
                      Icons.location_on,
                      size: 25,
                      color: Colors.white,
                    )),
              )
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: HomeMenu(),
      ),
    );
  }
}
