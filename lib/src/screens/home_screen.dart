import 'package:flutter/material.dart';

import '../models/chicken.dart';
import '../models/farm_animals.dart';
import '../models/mammals.dart';
import '../models/oviparous.dart';
import '../models/sheep.dart';
import '../models/tags.dart';
import '../services/firebase_service.dart';
import 'animal_list_screen.dart'; // Import the AnimalListScreen

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _breedController = TextEditingController();
  final _imageController = TextEditingController();
  final _sexController = TextEditingController();
  final _tagsController = TextEditingController();
  final _notesController = TextEditingController();
  final _customFieldsController = TextEditingController();
  final _animalTypeOptions = ['Mammals', 'Oviparous'];
  final _animalKindOptions = ['Sheep', 'Chicken'];
  String? _selectedAnimalType;
  String? _selectedAnimalKind;
  late String _loggedInUserId;
  // Store the logged-in user's ID

  @override
  void initState() {
    super.initState();
    _getCurrentUserId();
  }

  void _getCurrentUserId() async {
    final user = await _firebaseService.getCurrentUser();
    if (user != null) {
      setState(() {
        _loggedInUserId = user.uid;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _breedController.dispose();
    _imageController.dispose();
    _sexController.dispose();
    _tagsController.dispose();
    _notesController.dispose();
    _customFieldsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _firebaseService.signOut();
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Add SingleChildScrollView here
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create a Farm',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Farm Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a farm name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Text(
                  'Select Animal Type:',
                  style: TextStyle(fontSize: 16),
                ),
                DropdownButtonFormField<String>(
                  value: _selectedAnimalType,
                  items: _animalTypeOptions
                      .map((type) => DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedAnimalType = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select an animal type';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                if (_selectedAnimalType != null)
                  Text(
                    'Select Animal Kind:',
                    style: TextStyle(fontSize: 16),
                  ),
                if (_selectedAnimalType != null)
                  DropdownButtonFormField<String>(
                    value: _selectedAnimalKind,
                    items: _animalKindOptions
                        .map((kind) => DropdownMenuItem<String>(
                              value: kind,
                              child: Text(kind),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedAnimalKind = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select an animal kind';
                      }
                      return null;
                    },
                  ),
                SizedBox(height: 16),
                ElevatedButton(
                  child: Text('Submit Animal'),
                  onPressed: () async {
                    if (_formKey.currentState!.validate() &&
                        _selectedAnimalType != null &&
                        _selectedAnimalKind != null) {
                      FarmAnimals animal;
                      if (_selectedAnimalType == 'Mammals') {
                        Sheep sheep = Sheep(
                          id: '1',
                          dob: DateTime.now(),
                          name: _nameController.text,
                          breed: _breedController.text,
                          image: _imageController.text,
                          sex: _sexController.text,
                          parents: [],
                          children: [],
                          tags: Tags(
                            currentState: _tagsController.text.split(','),
                            medicalState: [],
                            other: [],
                          ),
                          notes: _notesController.text,
                          customFields: {},
                          uploadedFiles: [],
                          dateOfMate: DateTime.now(),
                          dateOfDeadOrSell: DateTime.now(),
                          dateOfWeaning: DateTime.now(),
                          breedingStage: '',
                        );
                        animal = FarmAnimals(
                          name: _nameController.text,
                          createdDate: DateTime.now(),
                          userId: _loggedInUserId, // Assign the user ID
                          mammals: Mammals(sheep: sheep),
                        );
                      } else {
                        Chicken chicken = Chicken(
                          id: '1',
                          dob: DateTime.now(),
                          name: _nameController.text,
                          breed: _breedController.text,
                          image: _imageController.text,
                          sex: _sexController.text,
                          parents: [],
                          children: [],
                          tags: Tags(
                            currentState: _tagsController.text.split(','),
                            medicalState: [],
                            other: [],
                          ),
                          notes: _notesController.text,
                          customFields: {},
                          uploadedFiles: [],
                          dateOfMate: DateTime.now(),
                          dateOfDeadOrSell: DateTime.now(),
                          dateOfWeaning: DateTime.now(),
                          breedingStage: '',
                        );
                        animal = FarmAnimals(
                          name: _nameController.text,
                          createdDate: DateTime.now(),
                          userId: _loggedInUserId, // Assign the user ID
                          oviparous: Oviparous(chicken: chicken),
                        );
                      }

                      String? animalId =
                          await _firebaseService.addFarmAnimal(animal);
                      if (animalId != null) {
                        print('Farm added with ID: $animalId');
                      } else {
                        print('Failed to add animal');
                      }
                    }
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  child: const Text('Animal List'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AnimalListScreen(userId: _loggedInUserId)),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
