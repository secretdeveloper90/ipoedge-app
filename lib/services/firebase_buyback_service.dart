import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/buyback_model.dart';

class FirebaseBuybackService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'buybacks';

  // Get all buybacks from Firestore
  static Future<List<Buyback>> getAllBuybacks() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .orderBy('issueDate', descending: true)
          .get();
      return querySnapshot.docs
          .map((doc) => Buyback.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error fetching buybacks: $e');
      return [];
    }
  }

  // Get buybacks by status
  static Future<List<Buyback>> getBuybacksByStatus(String status) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('status', isEqualTo: status)
          .orderBy('issueDate', descending: true)
          .get();
      return querySnapshot.docs
          .map((doc) => Buyback.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error fetching buybacks by status: $e');
      return [];
    }
  }

  // Get upcoming buybacks
  static Future<List<Buyback>> getUpcomingBuybacks() async {
    return getBuybacksByStatus('upcoming');
  }

  // Get open buybacks
  static Future<List<Buyback>> getOpenBuybacks() async {
    return getBuybacksByStatus('open');
  }

  // Get closed buybacks
  static Future<List<Buyback>> getClosedBuybacks() async {
    return getBuybacksByStatus('closed');
  }

  // Get buyback by ID
  static Future<Buyback?> getBuybackById(String id) async {
    try {
      final docSnapshot =
          await _firestore.collection(_collection).doc(id).get();
      if (docSnapshot.exists) {
        return Buyback.fromJson({...docSnapshot.data()!, 'id': docSnapshot.id});
      }
      return null;
    } catch (e) {
      print('Error fetching buyback by ID: $e');
      return null;
    }
  }

  // Search buybacks by company name
  static Future<List<Buyback>> searchBuybacks(String query) async {
    try {
      if (query.isEmpty) return getAllBuybacks();

      // Firestore doesn't support case-insensitive search directly
      // We'll fetch all and filter locally for now
      final allBuybacks = await getAllBuybacks();
      return allBuybacks
          .where((buyback) =>
              buyback.companyName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      print('Error searching buybacks: $e');
      return [];
    }
  }

  // Get buybacks by method
  static Future<List<Buyback>> getBuybacksByMethod(String method) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('method', isEqualTo: method)
          .orderBy('issueDate', descending: true)
          .get();
      return querySnapshot.docs
          .map((doc) => Buyback.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error fetching buybacks by method: $e');
      return [];
    }
  }

  // Get buybacks by date range
  static Future<List<Buyback>> getBuybacksByDateRange(
      DateTime startDate, DateTime endDate) async {
    try {
      final startDateStr = startDate.toIso8601String().split('T')[0];
      final endDateStr = endDate.toIso8601String().split('T')[0];

      final querySnapshot = await _firestore
          .collection(_collection)
          .where('issueDate', isGreaterThanOrEqualTo: startDateStr)
          .where('issueDate', isLessThanOrEqualTo: endDateStr)
          .orderBy('issueDate', descending: true)
          .get();
      return querySnapshot.docs
          .map((doc) => Buyback.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error fetching buybacks by date range: $e');
      return [];
    }
  }

  // Get buybacks by price range
  static Future<List<Buyback>> getBuybacksByPriceRange(
      double minPrice, double maxPrice) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('buybackPrice', isGreaterThanOrEqualTo: minPrice)
          .where('buybackPrice', isLessThanOrEqualTo: maxPrice)
          .orderBy('buybackPrice', descending: true)
          .get();
      return querySnapshot.docs
          .map((doc) => Buyback.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error fetching buybacks by price range: $e');
      return [];
    }
  }

  // Stream buybacks for real-time updates
  static Stream<List<Buyback>> getBuybacksStream() {
    return _firestore
        .collection(_collection)
        .orderBy('issueDate', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Buyback.fromJson({...doc.data(), 'id': doc.id}))
              .toList(),
        );
  }

  // Stream buybacks by status for real-time updates
  static Stream<List<Buyback>> getBuybacksByStatusStream(String status) {
    return _firestore
        .collection(_collection)
        .where('status', isEqualTo: status)
        .orderBy('issueDate', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Buyback.fromJson({...doc.data(), 'id': doc.id}))
              .toList(),
        );
  }

  // Get buyback statistics
  static Future<Map<String, dynamic>> getBuybackStats() async {
    try {
      final allBuybacks = await getAllBuybacks();
      final upcomingBuybacks = await getUpcomingBuybacks();
      final openBuybacks = await getOpenBuybacks();
      final closedBuybacks = await getClosedBuybacks();

      final totalIssueSize = allBuybacks
          .map((b) =>
              double.tryParse(b.issueSize.replaceAll(RegExp(r'[^\d.]'), '')) ??
              0.0)
          .reduce((a, b) => a + b);

      final averagePrice = allBuybacks.isEmpty
          ? 0.0
          : allBuybacks.map((b) => b.buybackPrice).reduce((a, b) => a + b) /
              allBuybacks.length;

      return {
        'total': allBuybacks.length,
        'upcoming': upcomingBuybacks.length,
        'open': openBuybacks.length,
        'closed': closedBuybacks.length,
        'totalIssueSize': totalIssueSize,
        'averagePrice': averagePrice,
        'tenderOffers':
            allBuybacks.where((b) => b.method.toLowerCase() == 'tender').length,
        'openMarket': allBuybacks
            .where((b) => b.method.toLowerCase() == 'open_market')
            .length,
      };
    } catch (e) {
      print('Error fetching buyback stats: $e');
      return {};
    }
  }
}
