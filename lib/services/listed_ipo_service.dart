import '../models/listed_ipo.dart';
import '../models/firebase_ipo_model.dart';
import '../services/firebase_ipo_service.dart';

class ListedIpoService {
  static final ListedIpoService _instance = ListedIpoService._internal();
  factory ListedIpoService() => _instance;
  ListedIpoService._internal();

  static ListedIpoService get instance => _instance;

  List<ListedIpo> _listedIpos = [];
  bool _dataLoaded = false;

  Future<void> loadFirebaseData() async {
    if (_dataLoaded) return;

    try {
      final firebaseIpos = await FirebaseIPOService.getAllFirebaseIPOs();
      final listedIpos = <ListedIpo>[];

      for (final firebaseIpo in firebaseIpos) {
        // Only include IPOs that have been listed (have listing date and listing gains)
        if (firebaseIpo.importantDates.listingDate != null &&
            firebaseIpo.importantDates.listingDate!.isNotEmpty &&
            firebaseIpo.listingGains != null) {
          final listingDate =
              DateTime.tryParse(firebaseIpo.importantDates.listingDate!);
          if (listingDate != null) {
            // Get registrar information
            final registrar = _getRegistrarFromFirebaseIpo(firebaseIpo);
            final registrarLink = _getRegistrarLinkFromFirebaseIpo(firebaseIpo);

            // Calculate listing price from gains
            final issuePrice =
                (firebaseIpo.companyIpoOverview.priceRangeMax ?? 0).toDouble();
            final listingGainPercent =
                firebaseIpo.listingGains?.listingGainPercent ?? 0;
            final listingPrice =
                issuePrice + (issuePrice * listingGainPercent / 100);

            final listedIpo = ListedIpo(
              id: firebaseIpo.companyHeaders.ipoId.toString(),
              ipoName: firebaseIpo.companyHeaders.companyName,
              companyName: firebaseIpo.companyHeaders.companyName,
              listingDate: listingDate,
              registrarName: registrar,
              registrarLink: registrarLink,
              logoUrl: firebaseIpo.companyHeaders.companyLogo ?? '',
              listingPrice: listingPrice,
              issuePrice: issuePrice,
              status: 'Listed',
            );

            listedIpos.add(listedIpo);
          }
        }
      }

      _listedIpos = listedIpos;
      _dataLoaded = true;
    } catch (e) {
      // If Firebase fails, keep empty list
      _listedIpos = [];
      _dataLoaded = true;
    }
  }

  Future<List<ListedIpo>> getRecentlyListedIpos({int daysBack = 30}) async {
    await loadFirebaseData(); // Ensure data is loaded
    final cutoffDate = DateTime.now().subtract(Duration(days: daysBack));
    return _listedIpos
        .where((ipo) => ipo.listingDate.isAfter(cutoffDate))
        .toList()
      ..sort((a, b) => b.listingDate.compareTo(a.listingDate));
  }

  Future<List<ListedIpo>> getIposWithAllotmentDatePassed() async {
    await loadFirebaseData(); // Ensure data is loaded
    final now = DateTime.now();

    // Get all Firebase IPOs and filter by allotment date
    final firebaseIpos = await FirebaseIPOService.getAllFirebaseIPOs();
    final List<ListedIpo> allotmentIpos = [];

    for (final firebaseIpo in firebaseIpos) {
      // Check if allotment date has passed
      final allotmentDateStr = firebaseIpo.importantDates.allotmentDate;
      if (allotmentDateStr != null && allotmentDateStr.isNotEmpty) {
        final allotmentDate = DateTime.tryParse(allotmentDateStr);
        if (allotmentDate != null && now.isAfter(allotmentDate)) {
          // Convert to ListedIpo format
          final registrar = _getRegistrarFromFirebaseIpo(firebaseIpo);
          final registrarLink = _getRegistrarLinkFromFirebaseIpo(firebaseIpo);

          // Calculate listing price from gains if available
          final issuePrice =
              firebaseIpo.companyIpoOverview.priceRangeMax?.toDouble() ?? 0.0;
          double listingPrice = issuePrice;

          if (firebaseIpo.listingGains?.listingGainPercent != null) {
            final gainPercent = firebaseIpo.listingGains!.listingGainPercent!;
            listingPrice = issuePrice + (issuePrice * gainPercent / 100);
          }

          // Use allotment date as listing date for display purposes
          final displayDate = allotmentDate;

          final listedIpo = ListedIpo(
            id: firebaseIpo.companyHeaders.ipoId.toString(),
            ipoName: firebaseIpo.companyHeaders.companyName,
            companyName: firebaseIpo.companyHeaders.companyName,
            listingDate: displayDate,
            registrarName: registrar,
            registrarLink: registrarLink,
            logoUrl: firebaseIpo.companyHeaders.companyLogo ?? '',
            listingPrice: listingPrice,
            issuePrice: issuePrice,
            status: 'Allotment Finalized',
          );

          allotmentIpos.add(listedIpo);
        }
      }
    }

    // Sort by allotment date (most recent first)
    allotmentIpos.sort((a, b) => b.listingDate.compareTo(a.listingDate));
    return allotmentIpos;
  }

  String _getRegistrarFromFirebaseIpo(FirebaseIPO firebaseIpo) {
    // Look for registrar in leadManagersAndRegistrars
    final registrars = firebaseIpo.leadManagersAndRegistrars
        .where((item) => item.designation.toLowerCase().contains('registrar'))
        .toList();

    if (registrars.isNotEmpty) {
      return registrars.first.name;
    }

    // Fallback to a default registrar name
    return 'Registrar';
  }

  String _getRegistrarLinkFromFirebaseIpo(FirebaseIPO firebaseIpo) {
    // Check if there's a registrar allotment URL in company headers
    if (firebaseIpo.companyHeaders.registrarAllotmentUrl != null &&
        firebaseIpo.companyHeaders.registrarAllotmentUrl!.isNotEmpty) {
      return firebaseIpo.companyHeaders.registrarAllotmentUrl!;
    }

    // Get registrar name and provide default links based on common registrars
    final registrarName =
        _getRegistrarFromFirebaseIpo(firebaseIpo).toLowerCase();

    if (registrarName.contains('link intime')) {
      return 'https://linkintime.co.in/initial_offer/public-issues.html';
    } else if (registrarName.contains('kfin')) {
      return 'https://ris.kfintech.com/ipostatus/';
    } else if (registrarName.contains('computer age') ||
        registrarName.contains('cams')) {
      return 'https://www.camsonline.com/Investors/Public-Issue';
    } else if (registrarName.contains('registrar and transfer')) {
      return 'https://www.rtaindia.com/ipo';
    } else if (registrarName.contains('bigshare')) {
      return 'https://www.bigshareonline.com/Portfolio_Mgmt/ipo.aspx';
    } else {
      // Default fallback
      return 'https://www.google.com/search?q=${Uri.encodeComponent('$registrarName IPO allotment status')}';
    }
  }

  Future<List<ListedIpo>> getAllListedIpos() async {
    await loadFirebaseData(); // Ensure data is loaded
    return List.from(_listedIpos)
      ..sort((a, b) => b.listingDate.compareTo(a.listingDate));
  }

  Future<ListedIpo?> getListedIpoById(String id) async {
    await loadFirebaseData(); // Ensure data is loaded
    try {
      return _listedIpos.firstWhere((ipo) => ipo.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<ListedIpo>> searchListedIpos(String query) async {
    await loadFirebaseData(); // Ensure data is loaded
    final lowercaseQuery = query.toLowerCase();
    return _listedIpos
        .where((ipo) =>
            ipo.ipoName.toLowerCase().contains(lowercaseQuery) ||
            ipo.companyName.toLowerCase().contains(lowercaseQuery))
        .toList()
      ..sort((a, b) => b.listingDate.compareTo(a.listingDate));
  }

  Future<Map<String, dynamic>> getListingStats() async {
    final totalIpos = _listedIpos.length;
    final gainers = _listedIpos.where((ipo) => ipo.isGainer).length;
    final losers = totalIpos - gainers;

    double avgGain = 0;
    if (totalIpos > 0) {
      avgGain = _listedIpos
              .map((ipo) => ipo.listingGainPercent)
              .reduce((a, b) => a + b) /
          totalIpos;
    }

    return {
      'total': totalIpos,
      'gainers': gainers,
      'losers': losers,
      'averageGain': avgGain,
    };
  }
}
