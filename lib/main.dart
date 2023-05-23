import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/places_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Favorite Places',
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Colors.black,
            ),
      ),
      home: const PlacesScreen(),
    );
  }
}
