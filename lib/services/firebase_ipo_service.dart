import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ipo_model.dart';
import '../models/firebase_ipo_model.dart';

class FirebaseIPOService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'ipos';

  // Get all IPOs from Firestore (new Firebase structure)
  static Future<List<FirebaseIPO>> getAllFirebaseIPOs() async {
    try {
      print('🔍 Fetching all Firebase IPOs from collection: $_collection');
      final querySnapshot = await _firestore.collection(_collection).get();
      print('📊 Found ${querySnapshot.docs.length} documents in Firebase');

      final firebaseIPOs = <FirebaseIPO>[];
      for (final doc in querySnapshot.docs) {
        try {
          print('📄 Processing document: ${doc.id}');
          final firebaseIPO = FirebaseIPO.fromJson(doc.data());
          firebaseIPOs.add(firebaseIPO);
          print(
              '✅ Successfully parsed IPO: ${firebaseIPO.companyHeaders.companyName}');

          // Debug data availability
          print('🔍 Data check for ${firebaseIPO.companyHeaders.companyName}:');
          print('   Logo: ${firebaseIPO.companyHeaders.companyLogo}');
          print(
              '   Price Range: ${firebaseIPO.companyIpoOverview.priceRangeMin} - ${firebaseIPO.companyIpoOverview.priceRangeMax}');
          print('   Lot Size: ${firebaseIPO.companyIpoOverview.lotSize}');
          print(
              '   Subscription: ${firebaseIPO.subscriptionRate.subscriptionHeaderData?.totalSubscribed}');
          print('   Open Date: ${firebaseIPO.importantDates.openDate}');
          print('   Close Date: ${firebaseIPO.importantDates.closeDate}');
        } catch (e) {
          print('❌ Error parsing document ${doc.id}: $e');
          print('📄 Document data: ${doc.data()}');
        }
      }

      print('✅ Successfully parsed ${firebaseIPOs.length} Firebase IPOs total');

      // Print overall summary counts
      _printOverallSummary(firebaseIPOs);

      return firebaseIPOs;
    } catch (e) {
      print('❌ Error fetching Firebase IPOs: $e');
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
      print('Error fetching IPOs: $e');
      return [];
    }
  }

  // Get Firebase IPOs by category
  static Future<List<FirebaseIPO>> getFirebaseIPOsByCategory(
      String category) async {
    try {
      print('🏷️ Filtering IPOs by category: $category');
      final allIPOs = await getAllFirebaseIPOs();
      print('📊 Total IPOs before category filtering: ${allIPOs.length}');

      // Filter by category based on isSme field (category field contains status, not mainboard/sme)
      final filteredIPOs = allIPOs.where((ipo) {
        final ipoCategory = ipo.category?.toLowerCase();
        final isSme = ipo.stockData.isSme;
        print(
            '🔍 IPO: ${ipo.companyHeaders.companyName}, category: $ipoCategory, isSme: $isSme');

        if (category == 'sme') {
          // Filter SME IPOs based on isSme field
          return isSme == true;
        } else if (category == 'mainboard') {
          // Filter Mainboard IPOs based on isSme field
          return isSme != true;
        }
        return true; // 'all' category
      }).toList();

      print('✅ Filtered IPOs for category $category: ${filteredIPOs.length}');
      for (final ipo in filteredIPOs) {
        print(
            '   - ${ipo.companyHeaders.companyName} (category: ${ipo.category}, isSme: ${ipo.stockData.isSme})');
      }

      return filteredIPOs;
    } catch (e) {
      print('❌ Error fetching Firebase IPOs by category: $e');
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
      print('Error fetching IPOs by category: $e');
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
      print('Error fetching Firebase IPO by ID: $e');
      return null;
    }
  }

  // Get IPO by ID (legacy format for backward compatibility)
  static Future<IPO?> getIPOById(String id) async {
    try {
      final firebaseIPO = await getFirebaseIPOById(id);
      return firebaseIPO?.toLegacyIPO();
    } catch (e) {
      print('Error fetching IPO by ID: $e');
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

      print(
          '🔍 Searching Firebase IPOs with query: "$query", category: $category');

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

      print('✅ Found ${results.length} Firebase IPOs matching query "$query"');
      return results;
    } catch (e) {
      print('❌ Error searching Firebase IPOs: $e');
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
      print('🎯 Filtering all IPOs by status: $status');
      print('📊 Total IPOs before filtering: ${allIPOs.length}');

      final filteredIPOs = allIPOs.where((ipo) {
        final now = DateTime.now();
        final openDate = DateTime.tryParse(ipo.importantDates.openDate ?? '');
        final closeDate = DateTime.tryParse(ipo.importantDates.closeDate ?? '');
        final listingDate =
            DateTime.tryParse(ipo.importantDates.listingDate ?? '');
        final ipoCategory = ipo.category?.toLowerCase();

        // Always exclude draft issues
        if (ipoCategory == 'draft_issues') {
          print(
              '   ❌ Excluded: ${ipo.companyHeaders.companyName} (Draft issue)');
          return false;
        }

        bool shouldInclude = false;
        switch (status.toLowerCase()) {
          case 'current_upcoming':
            // Show current (open for bidding) and upcoming IPOs
            // Only include upcoming_open and listing_soon categories
            if (ipoCategory == 'upcoming_open' ||
                ipoCategory == 'listing_soon') {
              print(
                  '   ✅ Included: ${ipo.companyHeaders.companyName} (Category: $ipoCategory)');
              shouldInclude = true;
            } else if (ipoCategory == 'recently_listed' ||
                ipoCategory == 'gain_loss_analysis') {
              print(
                  '   ❌ Excluded: ${ipo.companyHeaders.companyName} (Category: $ipoCategory - belongs in recently listed)');
              shouldInclude = false;
            } else {
              print(
                  '   ❌ Excluded: ${ipo.companyHeaders.companyName} (Category: $ipoCategory - unknown category)');
              shouldInclude = false;
            }
            break;

          case 'recently_listed':
            // Show recently listed IPOs and gain/loss analysis categories
            if (ipoCategory == 'recently_listed' ||
                ipoCategory == 'gain_loss_analysis') {
              print(
                  '   ✅ Included: ${ipo.companyHeaders.companyName} (Category: $ipoCategory)');
              shouldInclude = true;
            } else {
              print(
                  '   ❌ Excluded: ${ipo.companyHeaders.companyName} (Category: $ipoCategory - not recently listed)');
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
            print(
                '   ${shouldInclude ? "✅ Included" : "❌ Excluded"}: ${ipo.companyHeaders.companyName} (Current check)');
            break;

          case 'upcoming':
            // Show only upcoming IPOs
            if (openDate != null) {
              shouldInclude = now.isBefore(openDate);
            } else {
              shouldInclude = false;
            }
            print(
                '   ${shouldInclude ? "✅ Included" : "❌ Excluded"}: ${ipo.companyHeaders.companyName} (Upcoming check)');
            break;

          case 'listed':
            // Show all listed IPOs
            if (listingDate != null) {
              shouldInclude = now.isAfter(listingDate);
            } else {
              shouldInclude = ipo.companyHeaders.recentlyListed == true;
            }
            print(
                '   ${shouldInclude ? "✅ Included" : "❌ Excluded"}: ${ipo.companyHeaders.companyName} (Listed check)');
            break;

          default:
            shouldInclude = true;
            break;
        }

        return shouldInclude;
      }).toList();

      print('✅ Final filtered IPOs for status $status: ${filteredIPOs.length}');
      for (final ipo in filteredIPOs) {
        print('   - ${ipo.companyHeaders.companyName}');
      }

      return filteredIPOs;
    } catch (e) {
      print('Error fetching Firebase IPOs by status: $e');
      return [];
    }
  }

  // Get Firebase IPOs by category and status
  static Future<List<FirebaseIPO>> getFirebaseIPOsByCategoryAndStatus(
      String category, String status) async {
    try {
      print('🎯 Filtering IPOs by category: $category, status: $status');
      final categoryIPOs = await getFirebaseIPOsByCategory(category);
      print('📊 IPOs after category filtering: ${categoryIPOs.length}');

      final now = DateTime.now();
      print('⏰ Current time: $now');

      final filteredIPOs = categoryIPOs.where((ipo) {
        final openDate = DateTime.tryParse(ipo.importantDates.openDate ?? '');
        final closeDate = DateTime.tryParse(ipo.importantDates.closeDate ?? '');
        final listingDate =
            DateTime.tryParse(ipo.importantDates.listingDate ?? '');
        final recentlyListed = ipo.companyHeaders.recentlyListed;

        print('🔍 Checking IPO: ${ipo.companyHeaders.companyName}');
        print('   📅 Open: ${ipo.importantDates.openDate} (parsed: $openDate)');
        print(
            '   📅 Close: ${ipo.importantDates.closeDate} (parsed: $closeDate)');
        print(
            '   📅 Listing: ${ipo.importantDates.listingDate} (parsed: $listingDate)');
        print('   🏷️ Recently Listed: $recentlyListed');

        bool shouldInclude = false;
        switch (status.toLowerCase()) {
          case 'current_upcoming':
            // Show current (open for bidding) and upcoming IPOs
            // Only include upcoming_open and listing_soon categories
            final ipoCategory = ipo.category?.toLowerCase();
            if (ipoCategory == 'upcoming_open' ||
                ipoCategory == 'listing_soon') {
              print(
                  '   ✅ Included: ${ipo.companyHeaders.companyName} (Category: $ipoCategory)');
              shouldInclude = true;
            } else {
              print(
                  '   ❌ Excluded: ${ipo.companyHeaders.companyName} (Category: $ipoCategory - not current/upcoming)');
              shouldInclude = false;
            }
            break;

          case 'recently_listed':
            // Show recently listed IPOs and gain/loss analysis categories
            final ipoCategory = ipo.category?.toLowerCase();
            if (ipoCategory == 'recently_listed' ||
                ipoCategory == 'gain_loss_analysis') {
              print(
                  '   ✅ Included: ${ipo.companyHeaders.companyName} (Category: $ipoCategory)');
              shouldInclude = true;
            } else {
              print(
                  '   ❌ Excluded: ${ipo.companyHeaders.companyName} (Category: $ipoCategory - not recently listed)');
              shouldInclude = false;
            }
            break;

          case 'current':
            // Show only current (open for bidding) IPOs
            if (openDate != null && closeDate != null) {
              shouldInclude = now.isAfter(openDate) && now.isBefore(closeDate);
              print(
                  '   ${shouldInclude ? "✅ Included" : "❌ Excluded"}: Current (open for bidding)');
            } else {
              shouldInclude = false;
              print('   ❌ Excluded: Missing open/close dates');
            }
            break;

          case 'upcoming':
            // Show only upcoming IPOs
            if (openDate != null) {
              shouldInclude = now.isBefore(openDate);
              print(
                  '   ${shouldInclude ? "✅ Included" : "❌ Excluded"}: Upcoming');
            } else {
              shouldInclude = false;
              print('   ❌ Excluded: Missing open date');
            }
            break;

          case 'listed':
            // Show all listed IPOs
            if (listingDate != null) {
              shouldInclude = now.isAfter(listingDate);
            } else {
              shouldInclude = recentlyListed == true;
            }
            print('   ${shouldInclude ? "✅ Included" : "❌ Excluded"}: Listed');
            break;

          default:
            shouldInclude = true;
            print('   ✅ Included: Default case');
        }

        return shouldInclude;
      }).toList();

      print(
          '✅ Final filtered IPOs for $category/$status: ${filteredIPOs.length}');
      for (final ipo in filteredIPOs) {
        print('   - ${ipo.companyHeaders.companyName}');
      }

      // Print detailed count summary
      _printDetailedCounts(categoryIPOs, category, status);

      return filteredIPOs;
    } catch (e) {
      print('❌ Error fetching Firebase IPOs by category and status: $e');
      return [];
    }
  }

  // Helper method to print detailed counts for debugging
  static void _printDetailedCounts(
      List<FirebaseIPO> categoryIPOs, String category, String status) {
    print('\n📊 ===== DETAILED COUNT SUMMARY =====');
    print('🏷️ Category: ${category.toUpperCase()}');
    print('📈 Status: ${status.toUpperCase()}');

    // Count only relevant IPOs (exclude only draft issues)
    int relevantCount = 0;
    final statusBreakdown = <String, int>{};

    for (final ipo in categoryIPOs) {
      final ipoCategory = ipo.category?.toLowerCase() ?? 'unknown';
      final recentlyListed = ipo.companyHeaders.recentlyListed;

      // Skip only draft issues
      if (ipoCategory == 'draft_issues') {
        continue;
      }

      relevantCount++;

      // Determine status for breakdown based on category
      String ipoStatus = 'other';
      if (ipoCategory == 'recently_listed' ||
          ipoCategory == 'gain_loss_analysis') {
        ipoStatus = 'recently_listed';
      } else if (ipoCategory == 'upcoming_open' ||
          ipoCategory == 'listing_soon') {
        ipoStatus = 'current_upcoming';
      }

      statusBreakdown[ipoStatus] = (statusBreakdown[ipoStatus] ?? 0) + 1;
    }

    print('📊 Relevant IPOs in category: $relevantCount');
    print('\n📋 Status Breakdown (Excluding Only Draft Issues):');
    statusBreakdown.forEach((stat, count) {
      print('   $stat: $count IPOs');
    });

    print('=====================================\n');
  }

  // Helper method to print overall summary of all IPOs
  static void _printOverallSummary(List<FirebaseIPO> allIPOs) {
    print('\n🌟 ===== OVERALL IPO SUMMARY =====');
    print('📊 Total IPOs in Firebase: ${allIPOs.length}');

    // Count by mainboard vs SME
    int mainboardCount = 0;
    int smeCount = 0;
    int unknownCount = 0;

    // Count by Firebase categories
    final categoryBreakdown = <String, int>{};

    // Count by status for each type
    final mainboardStatus = <String, int>{};
    final smeStatus = <String, int>{};

    for (final ipo in allIPOs) {
      final isSme = ipo.stockData.isSme;
      final category = ipo.category?.toLowerCase() ?? 'unknown';
      final recentlyListed = ipo.companyHeaders.recentlyListed;

      // Count mainboard vs SME
      if (isSme == true) {
        smeCount++;
      } else if (isSme == false) {
        mainboardCount++;
      } else {
        unknownCount++;
      }

      // Count by Firebase category
      categoryBreakdown[category] = (categoryBreakdown[category] ?? 0) + 1;

      // Determine app status based on category (exclude only draft issues from counts)
      String appStatus = 'other';
      if (category == 'draft_issues') {
        // Skip counting draft issues only
        continue;
      } else if (category == 'recently_listed' ||
          category == 'gain_loss_analysis') {
        appStatus = 'recently_listed';
      } else if (category == 'upcoming_open' || category == 'listing_soon') {
        appStatus = 'current_upcoming';
      }

      // Add to appropriate status count
      if (isSme == true) {
        smeStatus[appStatus] = (smeStatus[appStatus] ?? 0) + 1;
      } else if (isSme == false) {
        mainboardStatus[appStatus] = (mainboardStatus[appStatus] ?? 0) + 1;
      }
    }

    print('\n🏢 MAINBOARD vs SME Breakdown:');
    print('   🏢 Mainboard IPOs: $mainboardCount');
    print('   🏪 SME IPOs: $smeCount');
    print('   ❓ Unknown Type: $unknownCount');

    print('\n📱 TAB COUNTS:');
    print(
        '   🏢 Mainboard Current/Upcoming: ${mainboardStatus['current_upcoming'] ?? 0}');
    print(
        '   🏢 Mainboard Recently Listed: ${mainboardStatus['recently_listed'] ?? 0}');
    print('   🏪 SME Current/Upcoming: ${smeStatus['current_upcoming'] ?? 0}');
    print('   🏪 SME Recently Listed: ${smeStatus['recently_listed'] ?? 0}');

    print('=====================================\n');
  }

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
      print('Error fetching IPOs by category and status: $e');
      return [];
    }
  }
}
