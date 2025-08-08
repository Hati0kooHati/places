import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:location/location.dart';

import 'package:http/http.dart' as http;
import 'package:places/models/location_place.dart';

class InputLocationWidget extends StatefulWidget {
  const InputLocationWidget({super.key});

  @override
  State<InputLocationWidget> createState() => _InputLocationState();
}

class _InputLocationState extends State<InputLocationWidget> {
  LocationData? locationData;
  LocationPlace? pickedLocation;

  // doesnt work
  String getLocationImage() {
    if (locationData == null) {
      return "";
    }

    final double lat = pickedLocation!.lat;
    final double lng = pickedLocation!.lng;

    // doesnt work
    // should get Api in GoogleMaps Api Keys
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng=&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=AIzaSyDLcwxUggpPZo8lcbH0TB4Crq5SJjtj4ag';
  }

  void getLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionStatus;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus == PermissionStatus.denied) {
        return;
      }
    }

    locationData = await location.getLocation();

    final double? lat = locationData!.latitude;
    final double? lng = locationData!.longitude;

    if (lat == null || lng == null) {
      return;
    }

    final response = await http.get(
      Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=AIzaSyDLcwxUggpPZo8lcbH0TB4Crq5SJjtj4ag',
      ),
    );

    final String address = json.decode(
      response.body,
    )['results'][0]['formatted_address'];

    pickedLocation = LocationPlace(lat: lat, lng: lng, address: address);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,

          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),

          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: const Color.fromARGB(223, 255, 255, 255),
            ),
          ),
          child: Center(
            child: Text(
              "No location chosen",
              style: TextStyle(color: const Color.fromARGB(255, 198, 184, 234)),
            ),
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: getLocation,
              icon: Icon(Icons.location_on),
              label: Text(
                "get locaiton",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: Icon(Icons.map),
              label: Text(
                "select on map",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}
