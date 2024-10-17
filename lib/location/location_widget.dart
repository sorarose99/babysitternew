import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationWidget extends StatefulWidget {
  final LatLng initialPosition;

  LocationWidget({required this.initialPosition});

  @override
  _LocationWidgetState createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  late GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: GoogleMap(
        onMapCreated: (controller) {
          _mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: widget.initialPosition,
          zoom: 14.0,
        ),
        markers: {
          Marker(
            markerId: MarkerId('sitter_location'),
            position: widget.initialPosition,
          ),
        },
      ),
    );
  }
}
