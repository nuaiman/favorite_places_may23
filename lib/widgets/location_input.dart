import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geo;

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onLocationPicked});

  final void Function(PlaceLocation pickedLocation) onLocationPicked;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  bool _isGettingLocation = false;

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();

    final latitude = locationData.latitude;
    final longitude = locationData.longitude;

    if (latitude == null || longitude == null) {
      setState(() {
        _isGettingLocation = false;
      });
      return;
    }

    _savePlace(latitude, longitude);
  }

  Future<List<geo.Placemark>> _getLocationAddress(
      double latitude, double longitude) async {
    List<geo.Placemark> placeList =
        await geo.placemarkFromCoordinates(latitude, longitude);
    return placeList;
  }

  void _savePlace(double latitude, double longitude) async {
    final addressData = await _getLocationAddress(latitude, longitude);
    if (addressData.isEmpty) {
      return;
    }
    final String? street = addressData[0].street;
    final String? postalCode = addressData[0].postalCode;
    final String? locality = addressData[0].locality;
    final String? country = addressData[0].country;

    final String address = '$street, $postalCode, $locality, $country';

    setState(() {
      _pickedLocation = PlaceLocation(
        latitude: latitude,
        longitude: longitude,
        address: address,
      );
      _isGettingLocation = false;
    });

    widget.onLocationPicked(_pickedLocation!);
  }

  Future<void> _selectOnMap() async {
    final position = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (context) => const MapScreen(),
      ),
    );

    _savePlace(position!.latitude, position.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('No Location Selected Yet...'),
    );

    if (_isGettingLocation) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_pickedLocation != null) {
      content = FlutterMap(
        options: MapOptions(
          interactiveFlags: InteractiveFlag.none,
          center: LatLng(_pickedLocation!.latitude, _pickedLocation!.longitude),
          zoom: 9,
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
                point: LatLng(
                    _pickedLocation!.latitude, _pickedLocation!.longitude),
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

    return Column(
      children: [
        Container(
          height: 300,
          width: double.infinity,
          decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.black)),
          child: content,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Get Current Location'),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
            ),
          ],
        ),
      ],
    );
  }
}
