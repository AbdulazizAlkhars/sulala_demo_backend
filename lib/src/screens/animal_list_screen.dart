import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/farm_animals.dart';
import '../services/firebase_service.dart';
import 'animal_details_screen.dart';

class AnimalListScreen extends StatefulWidget {
  final String userId;

  const AnimalListScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _AnimalListScreenState createState() => _AnimalListScreenState();
}

class _AnimalListScreenState extends State<AnimalListScreen> {
  final firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animal List'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firebaseService.getFarmAnimalsByUserStream(widget.userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            List<FarmAnimals> farmAnimals =
                firebaseService.querySnapshotToList(snapshot.data!);
            return ListView.builder(
              itemCount: farmAnimals.length,
              itemBuilder: (context, index) {
                FarmAnimals animal = farmAnimals[index];
                return Material(
                  child: ListTile(
                    title: Text(animal.name),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AnimalDetailsScreen(
                            sheep: animal.mammals.sheep,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
