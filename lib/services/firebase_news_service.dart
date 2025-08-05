import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseNewsService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'news';

  // Get all news from Firestore
  static Future<List<Map<String, dynamic>>> getAllNews() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .orderBy('date', descending: true)
          .get();
      return querySnapshot.docs
          .map((doc) => {...doc.data(), 'id': doc.id})
          .toList();
    } catch (e) {
      print('Error fetching news: $e');
      return [];
    }
  }

  // Get news by sector
  static Future<List<Map<String, dynamic>>> getNewsBySector(
      String sector) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('sector', isEqualTo: sector)
          .orderBy('date', descending: true)
          .get();
      return querySnapshot.docs
          .map((doc) => {...doc.data(), 'id': doc.id})
          .toList();
    } catch (e) {
      print('Error fetching news by sector: $e');
      return [];
    }
  }

  // Get news by date range
  static Future<List<Map<String, dynamic>>> getNewsByDateRange(
      DateTime startDate, DateTime endDate) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('date',
              isGreaterThanOrEqualTo: startDate.toIso8601String().split('T')[0])
          .where('date',
              isLessThanOrEqualTo: endDate.toIso8601String().split('T')[0])
          .orderBy('date', descending: true)
          .get();
      return querySnapshot.docs
          .map((doc) => {...doc.data(), 'id': doc.id})
          .toList();
    } catch (e) {
      print('Error fetching news by date range: $e');
      return [];
    }
  }

  // Search news by headline or summary
  static Future<List<Map<String, dynamic>>> searchNews(String query) async {
    try {
      if (query.isEmpty) return getAllNews();

      // Firestore doesn't support case-insensitive search directly
      // We'll fetch all and filter locally for now
      final allNews = await getAllNews();
      return allNews
          .where((news) =>
              news['headline']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              news['summary']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              news['sector']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      print('Error searching news: $e');
      return [];
    }
  }

  // Get latest news (limit)
  static Future<List<Map<String, dynamic>>> getLatestNews(
      {int limit = 10}) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .orderBy('date', descending: true)
          .limit(limit)
          .get();
      return querySnapshot.docs
          .map((doc) => {...doc.data(), 'id': doc.id})
          .toList();
    } catch (e) {
      print('Error fetching latest news: $e');
      return [];
    }
  }

  // Stream news for real-time updates
  static Stream<List<Map<String, dynamic>>> getNewsStream() {
    return _firestore
        .collection(_collection)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => {...doc.data(), 'id': doc.id})
              .toList(),
        );
  }

  // Stream news by sector for real-time updates
  static Stream<List<Map<String, dynamic>>> getNewsBySectorStream(
      String sector) {
    return _firestore
        .collection(_collection)
        .where('sector', isEqualTo: sector)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => {...doc.data(), 'id': doc.id})
              .toList(),
        );
  }

  // Get unique sectors
  static Future<List<String>> getUniqueSectors() async {
    try {
      final querySnapshot = await _firestore.collection(_collection).get();
      final sectors = querySnapshot.docs
          .map((doc) => doc.data()['sector'] as String)
          .toSet()
          .toList();
      sectors.sort();
      return sectors;
    } catch (e) {
      print('Error fetching unique sectors: $e');
      return [];
    }
  }
}
