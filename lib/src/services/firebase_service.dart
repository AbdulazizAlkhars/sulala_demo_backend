import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/farm_animals.dart';

class FirebaseService {
  final CollectionReference farmAnimalsCollection =
      FirebaseFirestore.instance.collection('farm_animals');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> addFarmAnimal(FarmAnimals animal) async {
    try {
      final docRef = await farmAnimalsCollection.add(animal.toMap());
      return docRef.id;
    } catch (e) {
      print('Error adding farm animal: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      // Add any additional cleanup or navigation logic here
    } catch (e) {
      // Handle sign-out error
      print('Failed to sign out: $e');
    }
  }

  Future<User?> getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user;
  }

  // New function to get a Stream of all FarmAnimals for a specific user
  Stream<QuerySnapshot> getFarmAnimalsByUserStream(String userId) {
    return farmAnimalsCollection.where('userId', isEqualTo: userId).snapshots();
  }

  // This function will convert QuerySnapshot into a List of FarmAnimals
  List<FarmAnimals> querySnapshotToList(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      if (data != null) {
        DateTime? createdDate;
        if (data['createdDate'] is Timestamp) {
          createdDate = (data['createdDate'] as Timestamp).toDate();
        }
        return FarmAnimals.fromMap(data, createdDate: createdDate);
      } else {
        throw Exception('No document found');
      }
    }).toList();
  }
}
