// lib/src/screens/animal_details_screen.dart
import 'package:flutter/material.dart';
import '../models/sheep.dart';

class AnimalDetailsScreen extends StatelessWidget {
  final Sheep sheep; // replace with Cat if displaying cat

  const AnimalDetailsScreen({super.key, required this.sheep});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animal Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${sheep.name}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('DOB: ${sheep.dob.toIso8601String()}',
                style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Breed: ${sheep.breed}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            // Add more fields as required
          ],
        ),
      ),
    );
  }
}
