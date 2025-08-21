import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ipo_model.dart';
import '../models/firebase_ipo_model.dart';

class FirebaseIPOService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'ipos';

  // Get all IPOs from Firestore (new Firebase structure)
  static Future<List<FirebaseIPO>> getAllFirebaseIPOs() async {
    try {
      final querySnapshot = await _firestore.collection(_collection).get();

      final firebaseIPOs = <FirebaseIPO>[];
      for (final doc in querySnapshot.docs) {
        try {
          final firebaseIPO = FirebaseIPO.fromJson(doc.data());
          firebaseIPOs.add(firebaseIPO);
        } catch (e) {}
      }

      return firebaseIPOs;
    } catch (e) {
      return [];
    }
  }

  // Get all IPOs from Firestore (legacy format for backward compatibility)
  static Future<List<IPO>> getAllIPOs() async {
    try {
      final firebaseIPOs = await getAllFirebaseIPOs();
      return firebaseIPOs
          .map((firebaseIPO) => firebaseIPO.toLegacyIPO())
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get Firebase IPOs by category
  static Future<List<FirebaseIPO>> getFirebaseIPOsByCategory(
      String category) async {
    try {
      final allIPOs = await getAllFirebaseIPOs();

      // Filter by category based on isSme field (category field contains status, not mainboard/sme)
      final filteredIPOs = allIPOs.where((ipo) {    
                final isSme = ipo.stockData.isSme;

        if (category == 'sme') {
          // Filter SME IPOs based on isSme field
          return isSme == true;
        } else if (category == 'mainboard') {
          // Filter Mainboard IPOs based on isSme field
          return isSme != true;
        }
        return true; // 'all' category
      }).toList();

      return filteredIPOs;
    } catch (e) {
      return [];
    }
  }

  // Get IPOs by category (legacy format for backward compatibility)
  static Future<List<IPO>> getIPOsByCategory(String category) async {
    try {
      final firebaseIPOs = await getFirebaseIPOsByCategory(category);
      return firebaseIPOs
          .map((firebaseIPO) => firebaseIPO.toLegacyIPO())
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get Firebase IPO by ID
  static Future<FirebaseIPO?> getFirebaseIPOById(String id) async {
    try {
      final docSnapshot =
          await _firestore.collection(_collection).doc(id).get();
      if (docSnapshot.exists) {
        return FirebaseIPO.fromJson(docSnapshot.data()!);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Get IPO by ID (legacy format for backward compatibility)
  static Future<IPO?> getIPOById(String id) async {
    try {
      final firebaseIPO = await getFirebaseIPOById(id);
      return firebaseIPO?.toLegacyIPO();
    } catch (e) {
      return null;
    }
  }

  // Search Firebase IPOs by name, sector, or other fields
  static Future<List<FirebaseIPO>> searchFirebaseIPOs(String query,
      {String? category}) async {
    try {
      if (query.isEmpty) {
        if (category != null) {
          return getFirebaseIPOsByCategory(category);
        }
        return getAllFirebaseIPOs();
      }

      // Get IPOs by category first if specified, otherwise get all
      List<FirebaseIPO> iposToSearch;
      if (category != null) {
        iposToSearch = await getFirebaseIPOsByCategory(category);
      } else {
        iposToSearch = await getAllFirebaseIPOs();
      }

      // Filter by search query
      final results = iposToSearch.where((ipo) {
        final companyName = ipo.companyHeaders.companyName.toLowerCase();
        final sectorName = ipo.stockData.sectorName?.toLowerCase() ?? '';
        final queryLower = query.toLowerCase();

        return companyName.contains(queryLower) ||
            sectorName.contains(queryLower);
      }).toList();

      return results;
    } catch (e) {
      return [];
    }
  }

  // Search IPOs by name or sector (legacy format for backward compatibility)
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
      return [];
    }
  }

  // Stream Firebase IPOs for real-time updates
  static Stream<List<FirebaseIPO>> getFirebaseIPOsStream() {
    return _firestore.collection(_collection).snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => FirebaseIPO.fromJson(doc.data()))
              .toList(),
        );
  }

  // Stream IPOs for real-time updates (legacy format)
  static Stream<List<IPO>> getIPOsStream() {
    return getFirebaseIPOsStream().map(
      (firebaseIPOs) =>
          firebaseIPOs.map((firebaseIPO) => firebaseIPO.toLegacyIPO()).toList(),
    );
  }

  // Stream Firebase IPOs by category for real-time updates
  static Stream<List<FirebaseIPO>> getFirebaseIPOsByCategoryStream(
      String category) {
    return getFirebaseIPOsStream().map((allIPOs) {
      return allIPOs.where((ipo) {
        final isSme = ipo.stockData.isSme;

        if (category == 'sme') {
          // Filter SME IPOs based on isSme field
          return isSme == true;
        } else if (category == 'mainboard') {
          // Filter Mainboard IPOs based on isSme field
          return isSme != true;
        }
        return true; // 'all' category
      }).toList();
    });
  }

  // Stream IPOs by category for real-time updates (legacy format)
  static Stream<List<IPO>> getIPOsByCategoryStream(String category) {
    return getFirebaseIPOsByCategoryStream(category).map(
      (firebaseIPOs) =>
          firebaseIPOs.map((firebaseIPO) => firebaseIPO.toLegacyIPO()).toList(),
    );
  }

  // Get Firebase IPOs by status based on new data structure
  static Future<List<FirebaseIPO>> getFirebaseIPOsByStatus(
      String status) async {
    try {
      final allIPOs = await getAllFirebaseIPOs();

      final filteredIPOs = allIPOs.where((ipo) {
        final now = DateTime.now();
        final openDate = DateTime.tryParse(ipo.importantDates.openDate ?? '');
        final closeDate = DateTime.tryParse(ipo.importantDates.closeDate ?? '');
        final listingDate =
            DateTime.tryParse(ipo.importantDates.listingDate ?? '');
        final ipoCategory = ipo.category?.toLowerCase();

        // Always exclude draft issues
        if (ipoCategory == 'draft_issues') {
          return false;
        }

        bool shouldInclude = false;
        switch (status.toLowerCase()) {
          case 'current_upcoming':
            // Show current (open for bidding) and upcoming IPOs
            // Only include upcoming_open and listing_soon categories
            if (ipoCategory == 'upcoming_open' ||
                ipoCategory == 'listing_soon') {
              shouldInclude = true;
            } else if (ipoCategory == 'recently_listed' ||
                ipoCategory == 'gain_loss_analysis') {
              shouldInclude = false;
            } else {
              shouldInclude = false;
            }
            break;

          case 'recently_listed':
            // Show recently listed IPOs and gain/loss analysis categories
            if (ipoCategory == 'recently_listed' ||
                ipoCategory == 'gain_loss_analysis') {
              shouldInclude = true;
            } else {
              shouldInclude = false;
            }
            break;

          case 'current':
            // Show only current (open for bidding) IPOs
            if (openDate != null && closeDate != null) {
              shouldInclude = now.isAfter(openDate) && now.isBefore(closeDate);
            } else {
              shouldInclude = false;
            }
            break;

          case 'upcoming':
            // Show only upcoming IPOs
            if (openDate != null) {
              shouldInclude = now.isBefore(openDate);
            } else {
              shouldInclude = false;
            }
            break;

          case 'listed':
            // Show all listed IPOs
            if (listingDate != null) {
              shouldInclude = now.isAfter(listingDate);
            } else {
              shouldInclude = ipo.companyHeaders.recentlyListed == true;
            }
            break;

          default:
            shouldInclude = true;
            break;
        }

        return shouldInclude;
      }).toList();

      return filteredIPOs;
    } catch (e) {
      return [];
    }
  }

  // Get Firebase IPOs by category and status
  static Future<List<FirebaseIPO>> getFirebaseIPOsByCategoryAndStatus(
      String category, String status) async {
    try {
      final categoryIPOs = await getFirebaseIPOsByCategory(category);

      final now = DateTime.now();

      final filteredIPOs = categoryIPOs.where((ipo) {
        final openDate = DateTime.tryParse(ipo.importantDates.openDate ?? '');
        final closeDate = DateTime.tryParse(ipo.importantDates.closeDate ?? '');
        final listingDate =
            DateTime.tryParse(ipo.importantDates.listingDate ?? '');
        final recentlyListed = ipo.companyHeaders.recentlyListed;

        bool shouldInclude = false;
        switch (status.toLowerCase()) {
          case 'current_upcoming':
            // Show current (open for bidding) and upcoming IPOs
            // Only include upcoming_open and listing_soon categories
            final ipoCategory = ipo.category?.toLowerCase();
            if (ipoCategory == 'upcoming_open' ||
                ipoCategory == 'listing_soon') {
              shouldInclude = true;
            } else {
              shouldInclude = false;
            }
            break;

          case 'recently_listed':
            // Show recently listed IPOs and gain/loss analysis categories
            final ipoCategory = ipo.category?.toLowerCase();
            if (ipoCategory == 'recently_listed' ||
                ipoCategory == 'gain_loss_analysis') {
              shouldInclude = true;
            } else {
              shouldInclude = false;
            }
            break;

          case 'current':
            // Show only current (open for bidding) IPOs
            if (openDate != null && closeDate != null) {
              shouldInclude = now.isAfter(openDate) && now.isBefore(closeDate);
            } else {
              shouldInclude = false;
            }
            break;

          case 'upcoming':
            // Show only upcoming IPOs
            if (openDate != null) {
              shouldInclude = now.isBefore(openDate);
            } else {
              shouldInclude = false;
            }
            break;

          case 'listed':
            // Show all listed IPOs
            if (listingDate != null) {
              shouldInclude = now.isAfter(listingDate);
            } else {
              shouldInclude = recentlyListed == true;
            }
            break;

          default:
            shouldInclude = true;
        }

        return shouldInclude;
      }).toList();

      return filteredIPOs;
    } catch (e) {
      return [];
    }
  }

  // Debug functions removed for production

  // Legacy method for backward compatibility
  static Future<List<IPO>> getIPOsByCategoryAndStatus(
      String category, String status) async {
    try {
      final firebaseIPOs =
          await getFirebaseIPOsByCategoryAndStatus(category, status);
      return firebaseIPOs
          .map((firebaseIPO) => firebaseIPO.toLegacyIPO())
          .toList();
    } catch (e) {
      return [];
    }
  }
}
