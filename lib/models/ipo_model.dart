import 'ipo.dart';

class IPO {
  final String id;
  final String name;
  final String? logo;
  final OfferDate offerDate;
  final String status;
  final String exchange;
  final IPOCategory category;
  final OfferPrice offerPrice;
  final int lotSize;
  final Subscription subscription;
  final GMP gmp;
  final String issueSize;
  final String? listingDate;
  final String? allotmentDate;
  final double faceValue;
  final String companyDescription;
  final String sector;
  final String? registrar;
  final List<String> leadManagers;
  final List<Financial> financials;
  final Valuations valuations;
  final Promoters promoters;
  final List<String> issueObjectives;
  final List<String> strengths;
  final List<String> weaknesses;
  final ExpectedPremium expectedPremium;
  final CompanyDetails? companyDetails;
  final RegistrarDetails? registrarDetails;
  final List<IPODocument> documents;
  final FreshIssue? freshIssue;
  final OFS? ofs;
  final MarketLot? marketLot;
  final String? retailPortion;
  final SharesOffered? sharesOffered;
  final AnchorInvestors? anchorInvestors;
  final List<Peer> peers;
  final ProductPortfolio? productPortfolio;
  final BiddingTimings? biddingTimings;

  const IPO({
    required this.id,
    required this.name,
    this.logo,
    required this.offerDate,
    required this.status,
    required this.exchange,
    required this.category,
    required this.offerPrice,
    required this.lotSize,
    required this.subscription,
    required this.gmp,
    required this.issueSize,
    this.listingDate,
    this.allotmentDate,
    required this.faceValue,
    required this.companyDescription,
    required this.sector,
    this.registrar,
    required this.leadManagers,
    required this.financials,
    required this.valuations,
    required this.promoters,
    required this.issueObjectives,
    required this.strengths,
    required this.weaknesses,
    required this.expectedPremium,
    this.companyDetails,
    this.registrarDetails,
    this.documents = const [],
    this.freshIssue,
    this.ofs,
    this.marketLot,
    this.retailPortion,
    this.sharesOffered,
    this.anchorInvestors,
    this.peers = const [],
    this.productPortfolio,
    this.biddingTimings,
  });

  // Helper getters
  IPOStatus get ipoStatus {
    switch (status.toLowerCase()) {
      case 'upcoming':
        return IPOStatus.upcoming;
      case 'current':
        return IPOStatus.current;
      case 'closed':
        return IPOStatus.closed;
      case 'listed':
        return IPOStatus.listed;
      case 'withdrawn':
        return IPOStatus.withdrawn;
      default:
        return IPOStatus.upcoming;
    }
  }

  String get statusText {
    switch (ipoStatus) {
      case IPOStatus.upcoming:
        return 'Upcoming';
      case IPOStatus.current:
        return 'Open Now';
      case IPOStatus.closed:
        return 'Closed';
      case IPOStatus.listed:
        return 'Listed';
      case IPOStatus.withdrawn:
        return 'Withdrawn';
    }
  }

  String get categoryText {
    switch (category) {
      case IPOCategory.sme:
        return 'SME';
      case IPOCategory.mainboard:
        return 'Mainboard';
    }
  }

  // Days calculation
  int? get daysRemaining {
    final now = DateTime.now();
    try {
      if (ipoStatus == IPOStatus.upcoming) {
        final startDate = DateTime.parse(offerDate.start);
        return startDate.difference(now).inDays;
      } else if (ipoStatus == IPOStatus.current) {
        final endDate = DateTime.parse(offerDate.end);
        return endDate.difference(now).inDays;
      }
    } catch (e) {
      // Handle date parsing errors
    }
    return null;
  }

  String get daysRemainingText {
    final days = daysRemaining;
    if (days == null) return '';

    if (ipoStatus == IPOStatus.upcoming) {
      return days > 0 ? 'Opens in $days days' : 'Opening soon';
    } else if (ipoStatus == IPOStatus.current) {
      return days > 0 ? 'Closes in $days days' : 'Closing today';
    }
    return '';
  }

  // Subscription status
  String get subscriptionStatus {
    if (!subscription.hasSubscriptionData) {
      return 'Not Available';
    }

    final times = subscription.displayTimes;
    if (times >= 1.0) {
      return '${times.toStringAsFixed(2)}x subscribed';
    } else {
      return '${(times * 100).toStringAsFixed(0)}% subscribed';
    }
  }

  // GMP status color indicator
  bool get hasPositiveGMP => gmp.hasGMPData && gmp.safePercentage > 0;

  factory IPO.fromJson(Map<String, dynamic> json) {
    return IPO(
      id: json['id'],
      name: json['name'],
      logo: json['logo'],
      offerDate: OfferDate.fromJson(json['offerDate']),
      status: json['status'],
      exchange: json['exchange'],
      category:
          json['category'] == 'sme' ? IPOCategory.sme : IPOCategory.mainboard,
      offerPrice: OfferPrice.fromJson(json['offerPrice']),
      lotSize: json['lotSize'],
      subscription: Subscription.fromJson(json['subscription']),
      gmp: GMP.fromJson(json['gmp']),
      issueSize: json['issueSize'],
      listingDate: json['listingDate'],
      allotmentDate: json['allotmentDate'],
      faceValue: json['faceValue'].toDouble(),
      companyDescription: json['companyDescription'],
      sector: json['sector'],
      registrar: json['registrar'],
      leadManagers: List<String>.from(json['leadManagers']),
      financials: (json['financials'] as List)
          .map((f) => Financial.fromJson(f))
          .toList(),
      valuations: Valuations.fromJson(json['valuations']),
      promoters: Promoters.fromJson(json['promoters']),
      issueObjectives: List<String>.from(json['issueObjectives']),
      strengths: List<String>.from(json['strengths']),
      weaknesses: List<String>.from(json['weaknesses']),
      expectedPremium: ExpectedPremium.fromJson(json['expectedPremium']),
      companyDetails: json['companyDetails'] != null
          ? CompanyDetails.fromJson(json['companyDetails'])
          : null,
      registrarDetails: json['registrarDetails'] != null
          ? RegistrarDetails.fromJson(json['registrarDetails'])
          : null,
      documents:
          json['documents'] != null ? _parseDocuments(json['documents']) : [],
      freshIssue: json['freshIssue'] != null
          ? FreshIssue.fromJson(json['freshIssue'])
          : null,
      ofs: json['ofs'] != null ? OFS.fromJson(json['ofs']) : null,
      marketLot: json['marketLot'] != null
          ? MarketLot.fromJson(json['marketLot'])
          : null,
      retailPortion: json['retailPortion'],
      sharesOffered: json['sharesOffered'] != null
          ? SharesOffered.fromJson(json['sharesOffered'])
          : null,
      anchorInvestors: json['anchorInvestors'] != null
          ? AnchorInvestors.fromJson(json['anchorInvestors'])
          : null,
      peers: json['peers'] != null
          ? (json['peers'] as List).map((p) => Peer.fromJson(p)).toList()
          : [],
      productPortfolio: json['productPortfolio'] != null
          ? ProductPortfolio.fromJson(json['productPortfolio'])
          : null,
      biddingTimings: json['bidingTimings'] != null
          ? BiddingTimings.fromJson(json['bidingTimings'])
          : null,
    );
  }

  static List<IPODocument> _parseDocuments(dynamic documentsData) {
    if (documentsData is List) {
      // New format: List of IPODocument objects
      return documentsData.map((d) => IPODocument.fromJson(d)).toList();
    } else if (documentsData is Map<String, dynamic>) {
      // Old format: Map with document types as keys
      List<IPODocument> documents = [];
      documentsData.forEach((key, value) {
        if (value != null && value.toString().isNotEmpty) {
          documents.add(IPODocument(
            title: _getDocumentTitle(key),
            url: value.toString(),
            type: key.toUpperCase(),
          ));
        }
      });
      return documents;
    }
    return [];
  }

  static String _getDocumentTitle(String key) {
    switch (key.toLowerCase()) {
      case 'drhp':
        return 'Draft Red Herring Prospectus (DRHP)';
      case 'rhp':
        return 'Red Herring Prospectus (RHP)';
      case 'anchor':
        return 'Anchor Investor Details';
      case 'prospectus':
        return 'Final Prospectus';
      default:
        return key.toUpperCase();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
      'offerDate': offerDate.toJson(),
      'status': status,
      'exchange': exchange,
      'category': category.name,
      'offerPrice': offerPrice.toJson(),
      'lotSize': lotSize,
      'subscription': subscription.toJson(),
      'gmp': gmp.toJson(),
      'issueSize': issueSize,
      'listingDate': listingDate,
      'allotmentDate': allotmentDate,
      'faceValue': faceValue,
      'companyDescription': companyDescription,
      'sector': sector,
      'registrar': registrar,
      'leadManagers': leadManagers,
      'financials': financials.map((f) => f.toJson()).toList(),
      'valuations': valuations.toJson(),
      'promoters': promoters.toJson(),
      'issueObjectives': issueObjectives,
      'strengths': strengths,
      'weaknesses': weaknesses,
      'expectedPremium': expectedPremium.toJson(),
      'companyDetails': companyDetails?.toJson(),
      'registrarDetails': registrarDetails?.toJson(),
      'documents': documents.map((d) => d.toJson()).toList(),
      'freshIssue': freshIssue?.toJson(),
      'ofs': ofs?.toJson(),
      'marketLot': marketLot?.toJson(),
      'retailPortion': retailPortion,
      'sharesOffered': sharesOffered?.toJson(),
      'anchorInvestors': anchorInvestors?.toJson(),
      'peers': peers.map((p) => p.toJson()).toList(),
      'productPortfolio': productPortfolio?.toJson(),
      'biddingTimings': biddingTimings?.toJson(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is IPO && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'IPO(id: $id, name: $name, category: $category, status: $status)';
  }
}
