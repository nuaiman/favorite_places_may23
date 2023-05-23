import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapView extends StatelessWidget {
  const MapView({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        interactiveFlags: InteractiveFlag.none,
        center: LatLng(latitude, longitude),
        zoom: 13,
      ),
      children: [
        TileLayer(
          urlTemplate:
              'https://{s}.google.com/vt/lyrs=m&h1={h1}&x={x}&y={y}&z={z}',
          additionalOptions: const {'h1': 'en'},
          subdomains: const ['mt0', 'mt1', 'mt2', 'mt3'],
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: LatLng(latitude, longitude),
              builder: (context) => const Icon(
                Icons.location_on,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
