import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/material.dart';
import 'dart:math' show cos, sqrt, asin;
import 'dart:async';

class MapProvider with ChangeNotifier {
  MapProvider.initialize() {
    getCurrentLocation();
    addRandomMarkers();
    createPolylines(
        LatLng(5.653794, -0.189129), LatLng(5.804876, -0.114641), Colors.black);
  }

  Set<Marker> markers = {};
  // Map<PolylineId, Polyline> polylines = {};
  final Set<Polyline> polylines = {};
  final Geolocator geolocator = Geolocator();
  Position currentPosition;
  GoogleMapController mapController;
  PolylinePoints polylinePoints;
  List<LatLng> polylineCoordinates = [];
  Completer<GoogleMapController> controller = Completer();
  BitmapDescriptor busIcon;
  LatLng _center;
  LatLng get center => _center;

  String placeDistance;

  addRandomMarkers() async {
    busIcon = await setCustomMapPin('assets/bus_icon.png');
    addmarker(LatLng(5.653794, -0.189129), busIcon, "I am a Dropoff Point");
    addmarker(LatLng(5.804876, -0.114641), busIcon, "I am a Dropoff Point");

    addmarker(LatLng(5.693794, -0.185454), busIcon, "I am a Dropoff Point");
    addmarker(LatLng(5.834566, -0.113254), busIcon, "I am a Dropoff Point");

    addmarker(LatLng(5.744455, -0.186565), busIcon, "I am a Dropoff Point");
    addmarker(LatLng(5.807754, -0.116625), busIcon, "I am a Dropoff Point");

    addmarker(LatLng(5.956633, -0.182346), busIcon, "I am a Dropoff Point");
    addmarker(LatLng(5.876765, -0.154767), busIcon, "I am a Dropoff Point");
  }

  Future<void> getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      currentPosition = position;
      _center = LatLng(position.latitude, position.longitude);
    }).catchError((e) {
      print(e);
    });

    notifyListeners();
  }

  moveCamera(LatLng newPosition) {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: newPosition,
          zoom: 18.0,
        ),
      ),
    );
  }

  addmarker(LatLng location, icon, title) {
    Marker newMarker = Marker(
        markerId: MarkerId('$location.latitude-$location.longitude'),
        position: location,
        infoWindow: InfoWindow(
          title: title,
        ),
        icon: icon //BitmapDescriptor.defaultMarker,
        );

    markers.add(newMarker);

    notifyListeners();
  }

  Future<void> createPolylines(LatLng start, LatLng destination, color) async {
    // Initializing PolylinePoints
    polylinePoints = PolylinePoints();

    // Generating the list of coordinates to be used for
    // drawing the polylines
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyD9S2CZMlHDg78ZTAA55WOD-vLp5seHOPo', // Google Maps API Key
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.driving,
    );

    // Adding the coordinates to the list
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    // Defining an ID
    PolylineId id = PolylineId('poly');

    // Initializing Polyline
    Polyline polyline = Polyline(
      polylineId: id,
      color: color,
      points: polylineCoordinates,
      width: 3,
    );

    // Adding the polyline to the map
    // polylines[id] = polyline;
    polylines.add(polyline);
    notifyListeners();
  }

  onCreate(GoogleMapController controller) {
    mapController = controller;
    notifyListeners();
  }

  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  calculateDistance() {
    double totalDistance = 0.0;

// Calculating the total distance by adding the distance
// between small segments
    for (int i = 0; i < polylineCoordinates.length - 1; i++) {
      totalDistance += _coordinateDistance(
        polylineCoordinates[i].latitude,
        polylineCoordinates[i].longitude,
        polylineCoordinates[i + 1].latitude,
        polylineCoordinates[i + 1].longitude,
      );
    }

    placeDistance = totalDistance.toStringAsFixed(2);
    print('DISTANCE: $placeDistance km');
  }

  Future<void> gotoLocation(double lat, double long) async {
    final GoogleMapController _controller = await controller.future;
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, long),
      zoom: 15,
      tilt: 50.0,
      bearing: 45.0,
    )));
    notifyListeners();
  }

  setCustomMapPin(String image) async {
    BitmapDescriptor icon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), image);
    return icon;
  }
}
