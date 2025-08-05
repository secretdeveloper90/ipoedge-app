import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ipo_model.dart';

class FirebaseIPOService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'ipos';

  // Get all IPOs from Firestore
  static Future<List<IPO>> getAllIPOs() async {
    try {
      final querySnapshot = await _firestore.collection(_collection).get();
      return querySnapshot.docs
          .map((doc) => IPO.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error fetching IPOs: $e');
      return [];
    }
  }

  // Get IPOs by category
  static Future<List<IPO>> getIPOsByCategory(String category) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('category', isEqualTo: category)
          .get();
      return querySnapshot.docs
          .map((doc) => IPO.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error fetching IPOs by category: $e');
      return [];
    }
  }

  // Get IPO by ID
  static Future<IPO?> getIPOById(String id) async {
    try {
      final docSnapshot =
          await _firestore.collection(_collection).doc(id).get();
      if (docSnapshot.exists) {
        return IPO.fromJson({...docSnapshot.data()!, 'id': docSnapshot.id});
      }
      return null;
    } catch (e) {
      print('Error fetching IPO by ID: $e');
      return null;
    }
  }

  // Search IPOs by name or sector
  static Future<List<IPO>> searchIPOs(String query) async {
    try {
      if (query.isEmpty) return getAllIPOs();

      // Firestore doesn't support case-insensitive search directly
      // We'll fetch all and filter locally for now
      final allIPOs = await getAllIPOs();
      return allIPOs
          .where((ipo) =>
              ipo.name.toLowerCase().contains(query.toLowerCase()) ||
              ipo.sector.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      print('Error searching IPOs: $e');
      return [];
    }
  }

  // Get IPOs by status
  static Future<List<IPO>> getIPOsByStatus(String status) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('status', isEqualTo: status)
          .get();
      return querySnapshot.docs
          .map((doc) => IPO.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error fetching IPOs by status: $e');
      return [];
    }
  }

  // Stream IPOs for real-time updates
  static Stream<List<IPO>> getIPOsStream() {
    return _firestore.collection(_collection).snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => IPO.fromJson({...doc.data(), 'id': doc.id}))
              .toList(),
        );
  }

  // Stream IPOs by category for real-time updates
  static Stream<List<IPO>> getIPOsByCategoryStream(String category) {
    return _firestore
        .collection(_collection)
        .where('category', isEqualTo: category)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => IPO.fromJson({...doc.data(), 'id': doc.id}))
              .toList(),
        );
  }
}
