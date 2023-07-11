import 'package:flutter/material.dart';
import 'package:sulala_demo_backend/src/widgets/build_chicken_form.dart';
import 'package:sulala_demo_backend/src/widgets/build_sheep_form.dart';
import '../models/chicken.dart';
import '../models/farm_animals.dart';
import '../models/mammals.dart';
import '../models/oviparous.dart';
import '../models/sheep.dart';
import '../models/tags.dart';
import '../services/firebase_service.dart';
import 'animal_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _animalTypeOptions = ['Mammals', 'Oviparous'];
  final _animalKindOptions = ['Sheep', 'Chicken'];
  String? _selectedAnimalType;
  String? _selectedAnimalKind;
  late String _loggedInUserId;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _firebaseService.signOut();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create a Farm',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
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
                const SizedBox(height: 16),
                const Text(
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
                      _selectedAnimalKind = null;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select an animal type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                if (_selectedAnimalType != null)
                  const Text(
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
                const SizedBox(height: 16),
                if (_selectedAnimalKind == 'Sheep')
                  const BuildSheepFormFields(),
                if (_selectedAnimalKind == 'Chicken')
                  const BuildChickenFormFields(),
                const SizedBox(height: 16),
                ElevatedButton(
                  child: const Text('Submit Animal'),
                  onPressed: () async {
                    if (_formKey.currentState!.validate() &&
                        _selectedAnimalType != null &&
                        _selectedAnimalKind != null) {
                      FarmAnimals animal;
                      if (_selectedAnimalType == 'Mammals') {
                        Sheep sheep = Sheep(
                          name: _nameController.text,
                          breed: '',
                          image: '',
                          sex: '',
                          tags: Tags(),
                          notes: '',
                          customFields: {},
                          dateOfMate: DateTime.now(),
                          dateOfDeadOrSell: DateTime.now(),
                          dateOfWeaning: DateTime.now(),
                          dob: DateTime.now(),
                        );
                        animal = FarmAnimals(
                          name: _nameController.text,
                          createdDate: DateTime.now(),
                          userId: _loggedInUserId,
                          mammals: Mammals(sheep: sheep),
                        );
                      } else {
                        Chicken chicken = Chicken(
                          name: _nameController.text,
                          breed: '',
                          image: '',
                          sex: '',
                          tags: Tags(),
                          notes: '',
                          customFields: {},
                          dateOfMate: DateTime.now(),
                          dateOfDeadOrSell: DateTime.now(),
                          dateOfWeaning: DateTime.now(),
                          dob: DateTime.now(),
                        );
                        animal = FarmAnimals(
                          name: _nameController.text,
                          createdDate: DateTime.now(),
                          userId: _loggedInUserId,
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
                            AnimalListScreen(userId: _loggedInUserId),
                      ),
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
