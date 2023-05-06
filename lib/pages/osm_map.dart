// ignore_for_file: prefer_interpolation_to_compose_strings, deprecated_member_use

import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OsmMap extends StatefulWidget {
  const OsmMap({super.key});

  @override
  State<OsmMap> createState() => _OsmMapState();
}

class _OsmMapState extends State<OsmMap> {
  var locationName = "";
  Position currentPosition = const Position(
    latitude: 0,
    longitude: 0,
    accuracy: 0,
    altitude: 0,
    heading: 0,
    speed: 0,
    speedAccuracy: 0,
    timestamp: null,
  );
  MapController mapController = MapController();

  // Define two variables to keep track of the current zoom level and the maximum zoom level
  double currentZoom = 8;
  double minZoom = 8;
  double maxZoom = 18;

  bool _allowZoomButtons = false;

  _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _allowZoomButtons = prefs.getBool('allowZoomButtons') ?? false;
    });
  }

  Future getLocationName(double lat, double lng) async {
    final url =
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lng&zoom=18&addressdetails=1';
    final response =
        await http.get(Uri.parse(url), headers: {'accept-language': 'en-US'});

    final data = json.decode(response.body);
    return locationName = data['address']['village'] ??
        data['address']['city'] ??
        data['address']['town'] ??
        data['address']['counrty'] ??
        data['address']['county'] ??
        data['address']['state'] ??
        data['address']['road'] ??
        data['address']['suburd'];
  }

  Future getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, so request the user to enable them
      bool enable = await Geolocator.openLocationSettings();
      if (!enable) {
        // User did not enable location services
        return null;
      }
    }

    // Check if the app has permission to access location
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      // The user has previously denied location permission forever, so they need to go to settings to grant permission
      bool enable = await Geolocator.openAppSettings();
      if (!enable) {
        // User did not grant permission
        return null;
      }
    } else if (permission == LocationPermission.denied) {
      // The user has denied location permission, so request it from them
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // User did not grant permission
        return null;
      }
    }
    currentPosition = await Geolocator.getCurrentPosition();
    setState(() {
      Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(currentPosition.latitude, currentPosition.longitude),
        builder: (ctx) => const Icon(Icons.my_location),
      );
    });
  }

  Future openGoogleMaps(double lat, double lng) async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      final webUrl =
          'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&dirflg=w';
      if (await canLaunch(webUrl)) {
        await launch(webUrl);
      } else {
        throw 'Could not launch $webUrl';
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    _loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    final Map data = ModalRoute.of(context)?.settings.arguments as Map;
    final double lat = double.parse(data['latitude']);
    final double lng = double.parse(data['longitude']);

    getLocationName(lat, lng);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 2,
        iconTheme: IconThemeData(color: Colors.grey[800]),
        backgroundColor: Colors.grey[200],
        title: Text(
          overflow: TextOverflow.ellipsis,
          AppLocalizations.of(context)!.medicineOnMap(data['name']),
          style: TextStyle(
            color: Colors.grey[800],
          ),
        ),
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          center: LatLng(
            33.882533,
            35.748181,
          ),
          zoom: currentZoom,
          maxZoom: maxZoom,
          minZoom: minZoom,
          onPositionChanged: (MapPosition position, bool hasGesture) {
            if (hasGesture) {
              currentZoom = position.zoom!;
            }
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 50,
                height: 50,
                point: LatLng(
                  double.parse(data['latitude']),
                  double.parse(data['longitude']),
                ),
                builder: (ctx) => GestureDetector(
                  onTap: () {
                    showDialog(
                      context: ctx,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Row(
                            children: [
                              const Icon(Icons.info_outline),
                              const SizedBox(width: 5),
                              Text(AppLocalizations.of(context)!
                                  .info(data['name'])),
                            ],
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 8,
                          backgroundColor: Colors.grey[200],
                          shadowColor: Colors.red[300],
                          content: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: AppLocalizations.of(context)!
                                        .pharmacist,
                                    style: TextStyle(
                                      color: Colors.grey[800],
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: data['full_name'],
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5),
                                RichText(
                                  text: TextSpan(
                                    text:
                                        AppLocalizations.of(context)!.pharmacy,
                                    style: TextStyle(
                                      color: Colors.grey[800],
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: data['pharmacy_name'],
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5),
                                RichText(
                                  text: TextSpan(
                                    text:
                                        AppLocalizations.of(context)!.location,
                                    style: TextStyle(
                                      color: Colors.grey[800],
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: locationName,
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5),
                                RichText(
                                  text: TextSpan(
                                    text: AppLocalizations.of(context)!
                                        .phoneNumber,
                                    style: TextStyle(
                                      color: Colors.grey[800],
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: data['phone_number'],
                                        style: TextStyle(
                                          color: Colors.blue[700],
                                          fontSize: 15,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            launch(
                                                "tel://+961${data['phone_number']}");
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5),
                              ],
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                openGoogleMaps(double.parse(data['latitude']),
                                    double.parse(data['longitude']));
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red[600],
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.map, size: 30),
                                  Text(AppLocalizations.of(context)!
                                      .trackWithGoogleMaps),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.grey[400],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(AppLocalizations.of(context)!.back),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Icon(
                    Icons.location_pin,
                    color: Color.fromARGB(255, 225, 0, 255),
                    size: 50,
                  ),
                ),
              ),
              Marker(
                width: 80.0,
                height: 80.0,
                point:
                    LatLng(currentPosition.latitude, currentPosition.longitude),
                builder: (ctx) => GestureDetector(
                  onTap: () {
                    showDialog(
                      context: ctx,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          icon: const Icon(Icons.info_outline),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 8,
                          backgroundColor: Colors.grey[200],
                          shadowColor: Colors.red[300],
                          content: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .yourCurrentLocation,
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(AppLocalizations.of(context)!.close),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Icon(
                    Icons.my_location_rounded,
                    color: Color.fromARGB(255, 255, 1, 1),
                    size: 35,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              children: [
                Visibility(
                  visible: _allowZoomButtons ? true : false,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                      color: Colors.red,
                    ),
                    child: GestureDetector(
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 30,
                      ),
                      onTap: () {
                        if (currentZoom < maxZoom) {
                          currentZoom++;
                          LatLng targetLatLng = LatLng(
                              double.parse(data['latitude']),
                              double.parse(data['longitude']));
                          mapController.move(targetLatLng, currentZoom);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Visibility(
                  visible: _allowZoomButtons ? true : false,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                      color: Colors.red,
                    ),
                    child: GestureDetector(
                      child: const Icon(
                        Icons.remove,
                        color: Colors.white,
                        size: 30,
                      ),
                      onTap: () {
                        if (currentZoom > minZoom) {
                          currentZoom--;
                          LatLng targetLatLng = LatLng(
                              double.parse(data['latitude']),
                              double.parse(data['longitude']));
                          mapController.move(targetLatLng, currentZoom);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
