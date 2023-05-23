import 'package:favorite_places/models/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.isBeingSelected = true,
    this.location = const PlaceLocation(
      latitude: 23.8103,
      longitude: 90.4125,
      address: '',
    ),
  });

  final PlaceLocation location;
  final bool isBeingSelected;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;

  void _onMapClicked(TapPosition position, LatLng coordinates) {
    setState(() {
      _pickedLocation = coordinates;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.isBeingSelected ? 'Pick Your Location' : 'Your Location'),
        actions: [
          if (widget.isBeingSelected)
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop(_pickedLocation);
                },
                icon: const Icon(Icons.save)),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          interactiveFlags: InteractiveFlag.none,
          center: LatLng(widget.location.latitude, widget.location.longitude),
          zoom: 13,
          onTap: _onMapClicked,
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://{s}.google.com/vt/lyrs=m&h1={h1}&x={x}&y={y}&z={z}',
            additionalOptions: const {'h1': 'en'},
            subdomains: const ['mt0', 'mt1', 'mt2', 'mt3'],
          ),
          if (widget.isBeingSelected)
            MarkerLayer(
              markers: [
                Marker(
                  point: _pickedLocation ??
                      LatLng(
                          widget.location.latitude, widget.location.longitude),
                  builder: (context) => const Icon(
                    Icons.location_on,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
