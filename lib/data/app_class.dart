import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:location/location.dart';

class AppClass {
  List workouts = [];

  Location currLocation = Location();
  bool isServiceEnabled = false;
  PermissionStatus? permissionGranted;
  LocationData? locationData;

  // Contructor --------------------------------------------
  // -------------------------------------------------------
  AppClass() {
    // GETTING THE LOCATION OF THE CURRENT DEVICE ----------
    // IMPLEMANTING ALL PERMISSIONS AND SERVicES -----------
    setPermission();
  }

  get workoutsGetter => workouts;

  void setPermission() async {
    // ALLOWING GEOLOCATION SERVICES ------------------------
    // ------------------------------------------------------
    isServiceEnabled = await currLocation.serviceEnabled();
    if (!isServiceEnabled) {
      isServiceEnabled = await currLocation.requestService();
      if (!isServiceEnabled) {
        debugPrint('Error on Services');
        return;
      }
    }

    // PERMISSION -------------------------------------------
    // ------------------------------------------------------
    permissionGranted = await currLocation.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await currLocation.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        debugPrint('Error on Permisson');
        return;
      }
    }
  }

  Widget loadMap(MapController mapController, Widget marker, Function onTap1) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialZoom: 5,
        onTap: (tapPosition, point) {
          onTap1();
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.de/{z}/{x}/{y}.png',
          userAgentPackageName: 'dev.fleaflet.flutter_map.example',
        ),
        marker,
      ],
    );
  }
}
