import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/place_detail_screen.dart';
import 'package:flutter/material.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({super.key, required this.places});

  final List<Place> places;

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('No Places Added Yet...'),
    );

    if (places.isNotEmpty) {
      content = ListView.builder(
        itemCount: places.length,
        itemBuilder: (context, index) => ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PlaceDetailScreen(place: places[index]),
              ),
            );
          },
          leading: CircleAvatar(
            backgroundImage: FileImage(places[index].image),
          ),
          title: Text(places[index].title),
          subtitle: Text(places[index].location.address),
        ),
      );
    }

    return content;
  }
}
