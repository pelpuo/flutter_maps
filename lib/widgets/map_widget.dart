import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:solutions_challenge/providers/map_provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MapWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MapProvider mapProvider = Provider.of<MapProvider>(context);
    return Container(
      child: mapProvider.center == null
          ? SpinKitFadingCube(
              color: Colors.blue,
              size: 50,
            )
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: mapProvider.center,
                zoom: 17,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              markers: mapProvider.markers != null
                  ? Set<Marker>.from(mapProvider.markers)
                  : null,
              polylines: mapProvider.polylines,
              onMapCreated: mapProvider.onCreate,
            ),
    );
  }
}
