import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/broker.dart';

class FirebaseBrokerService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'brokers';

  // Get all brokers from Firestore
  static Future<List<Broker>> getAllBrokers() async {
    try {
      final querySnapshot = await _firestore.collection(_collection).get();
      return querySnapshot.docs
          .map((doc) => Broker.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error fetching brokers: $e');
      return [];
    }
  }

  // Get brokers by type/category
  static Future<List<Broker>> getBrokersByType(String type) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('type', isEqualTo: type)
          .get();
      return querySnapshot.docs
          .map((doc) => Broker.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error fetching brokers by type: $e');
      return [];
    }
  }

  // Get broker by ID
  static Future<Broker?> getBrokerById(String id) async {
    try {
      final docSnapshot =
          await _firestore.collection(_collection).doc(id).get();
      if (docSnapshot.exists) {
        return Broker.fromJson({...docSnapshot.data()!, 'id': docSnapshot.id});
      }
      return null;
    } catch (e) {
      print('Error fetching broker by ID: $e');
      return null;
    }
  }

  // Search brokers by name
  static Future<List<Broker>> searchBrokers(String query) async {
    try {
      if (query.isEmpty) return getAllBrokers();

      // Firestore doesn't support case-insensitive search directly
      // We'll fetch all and filter locally for now
      final allBrokers = await getAllBrokers();
      return allBrokers
          .where((broker) =>
              broker.name.toLowerCase().contains(query.toLowerCase()) ||
              broker.type.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      print('Error searching brokers: $e');
      return [];
    }
  }

  // Get brokers by rating range
  static Future<List<Broker>> getBrokersByRating(double minRating) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('rating', isGreaterThanOrEqualTo: minRating)
          .orderBy('rating', descending: true)
          .get();
      return querySnapshot.docs
          .map((doc) => Broker.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error fetching brokers by rating: $e');
      return [];
    }
  }

  // Get top-rated brokers
  static Future<List<Broker>> getTopRatedBrokers({int limit = 10}) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .orderBy('rating', descending: true)
          .limit(limit)
          .get();
      return querySnapshot.docs
          .map((doc) => Broker.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error fetching top-rated brokers: $e');
      return [];
    }
  }

  // Stream brokers for real-time updates
  static Stream<List<Broker>> getBrokersStream() {
    return _firestore.collection(_collection).snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => Broker.fromJson({...doc.data(), 'id': doc.id}))
              .toList(),
        );
  }

  // Stream brokers by type for real-time updates
  static Stream<List<Broker>> getBrokersByTypeStream(String type) {
    return _firestore
        .collection(_collection)
        .where('type', isEqualTo: type)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Broker.fromJson({...doc.data(), 'id': doc.id}))
              .toList(),
        );
  }

  // Get unique broker types
  static Future<List<String>> getUniqueBrokerTypes() async {
    try {
      final querySnapshot = await _firestore.collection(_collection).get();
      final types = querySnapshot.docs
          .map((doc) => doc.data()['type'] as String)
          .toSet()
          .toList();
      types.sort();
      return types;
    } catch (e) {
      print('Error fetching unique broker types: $e');
      return [];
    }
  }

  // Get broker statistics
  static Future<Map<String, dynamic>> getBrokerStats() async {
    try {
      final querySnapshot = await _firestore.collection(_collection).get();
      final brokers = querySnapshot.docs
          .map((doc) => Broker.fromJson({...doc.data(), 'id': doc.id}))
          .toList();

      final stats = {
        'total': brokers.length,
        'averageRating': brokers.isEmpty
            ? 0.0
            : brokers.map((b) => b.rating).reduce((a, b) => a + b) /
                brokers.length,
        'topRated': brokers.where((b) => b.rating >= 4.0).length,
        'discountBrokers': brokers
            .where((b) => b.type.toLowerCase().contains('discount'))
            .length,
        'fullServiceBrokers':
            brokers.where((b) => b.type.toLowerCase().contains('full')).length,
      };

      return stats;
    } catch (e) {
      print('Error fetching broker stats: $e');
      return {};
    }
  }
}
