import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
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
  final _breedController = TextEditingController();
  final _imageController = TextEditingController();
  final _sexController = TextEditingController();
  final _tagsController = TextEditingController();
  final _notesController = TextEditingController();
  final _customFieldsController = TextEditingController();
  final _dateOfMateController = TextEditingController();
  final _dateOfDeadOrSellController = TextEditingController();
  final _dateOfWeaningController = TextEditingController();
  final _dobController = TextEditingController();
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
    _breedController.dispose();
    _imageController.dispose();
    _sexController.dispose();
    _tagsController.dispose();
    _notesController.dispose();
    _customFieldsController.dispose();
    _dateOfMateController.dispose();
    _dateOfDeadOrSellController.dispose();
    _dateOfWeaningController.dispose();
    _dobController.dispose();
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
                if (_selectedAnimalKind == 'Sheep') ..._buildSheepFormFields(),
                if (_selectedAnimalKind == 'Chicken')
                  ..._buildChickenFormFields(),
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
                          breed: _breedController.text,
                          image: _imageController.text,
                          sex: _sexController.text,
                          tags: Tags(),
                          notes: _notesController.text,
                          customFields: {},
                          dateOfMate:
                              DateTime.parse(_dateOfMateController.text),
                          dateOfDeadOrSell:
                              DateTime.parse(_dateOfDeadOrSellController.text),
                          dateOfWeaning:
                              DateTime.parse(_dateOfWeaningController.text),
                          dob: DateTime.parse(_dobController.text),
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
                          breed: _breedController.text,
                          image: _imageController.text,
                          sex: _sexController.text,
                          tags: Tags(),
                          notes: _notesController.text,
                          customFields: {},
                          dateOfMate:
                              DateTime.parse(_dateOfMateController.text),
                          dateOfDeadOrSell:
                              DateTime.parse(_dateOfDeadOrSellController.text),
                          dateOfWeaning:
                              DateTime.parse(_dateOfWeaningController.text),
                          dob: DateTime.parse(_dobController.text),
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

  List<Widget> _buildSheepFormFields() {
    return [
      const SizedBox(height: 16),
      TextFormField(
        controller: _breedController,
        decoration: const InputDecoration(
          labelText: 'Sheep Breed',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the sheep breed';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: _imageController,
        decoration: const InputDecoration(
          labelText: 'Sheep Image',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the sheep image URL';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: _sexController,
        decoration: const InputDecoration(
          labelText: 'Sheep Sex',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the sheep sex';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: _tagsController,
        decoration: const InputDecoration(
          labelText: 'Sheep Tags',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the sheep tags';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: _notesController,
        decoration: const InputDecoration(
          labelText: 'Sheep Notes',
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: _customFieldsController,
        decoration: const InputDecoration(
          labelText: 'Sheep Custom Fields',
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: _dateOfMateController,
        readOnly: true,
        decoration: const InputDecoration(
          labelText: 'Date of Mate',
          border: OutlineInputBorder(),
        ),
        onTap: () {
          _showDatePicker(_dateOfMateController);
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the date of mate';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: _dateOfDeadOrSellController,
        readOnly: true,
        decoration: const InputDecoration(
          labelText: 'Date of Dead or Sell',
          border: OutlineInputBorder(),
        ),
        onTap: () {
          _showDatePicker(_dateOfDeadOrSellController);
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the date of dead or sell';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: _dateOfWeaningController,
        readOnly: true,
        decoration: const InputDecoration(
          labelText: 'Date of Weaning',
          border: OutlineInputBorder(),
        ),
        onTap: () {
          _showDatePicker(_dateOfWeaningController);
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the date of weaning';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: _dobController,
        readOnly: true,
        decoration: const InputDecoration(
          labelText: 'Date of Birth',
          border: OutlineInputBorder(),
        ),
        onTap: () {
          _showDatePicker(_dobController);
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the date of birth';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),
    ];
  }

  List<Widget> _buildChickenFormFields() {
    return [
      const SizedBox(height: 16),
      TextFormField(
        controller: _breedController,
        decoration: const InputDecoration(
          labelText: 'Chicken Breed',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the chicken breed';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: _imageController,
        decoration: const InputDecoration(
          labelText: 'Chicken Image',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the chicken image URL';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: _sexController,
        decoration: const InputDecoration(
          labelText: 'Chicken Sex',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the chicken sex';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: _tagsController,
        decoration: const InputDecoration(
          labelText: 'Chicken Tags',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the chicken tags';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: _notesController,
        decoration: const InputDecoration(
          labelText: 'Chicken Notes',
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: _customFieldsController,
        decoration: const InputDecoration(
          labelText: 'Chicken Custom Fields',
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: _dateOfMateController,
        readOnly: true,
        decoration: const InputDecoration(
          labelText: 'Date of Mate',
          border: OutlineInputBorder(),
        ),
        onTap: () {
          _showDatePicker(_dateOfMateController);
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the date of mate';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: _dateOfDeadOrSellController,
        readOnly: true,
        decoration: const InputDecoration(
          labelText: 'Date of Dead or Sell',
          border: OutlineInputBorder(),
        ),
        onTap: () {
          _showDatePicker(_dateOfDeadOrSellController);
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the date of dead or sell';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: _dateOfWeaningController,
        readOnly: true,
        decoration: const InputDecoration(
          labelText: 'Date of Weaning',
          border: OutlineInputBorder(),
        ),
        onTap: () {
          _showDatePicker(_dateOfWeaningController);
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the date of weaning';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: _dobController,
        readOnly: true,
        decoration: const InputDecoration(
          labelText: 'Date of Birth',
          border: OutlineInputBorder(),
        ),
        onTap: () {
          _showDatePicker(_dobController);
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the date of birth';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),
    ];
  }

  Future<void> _showDatePicker(TextEditingController controller) async {
    DateTime? pickedDate = await showRoundedDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      theme: ThemeData(primarySwatch: Colors.green),
    );
    if (pickedDate != null) {
      controller.text = pickedDate.toIso8601String();
    }
  }
}
