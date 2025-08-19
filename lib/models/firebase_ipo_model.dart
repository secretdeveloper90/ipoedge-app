import 'ipo.dart';
import 'ipo_model.dart';

/// Firebase IPO model that matches the new data structure
class FirebaseIPO {
  final CompanyHeaders companyHeaders;
  final CompanyIPOOverview companyIpoOverview;
  final Map<String, dynamic>? companyEvents;
  final SubscriptionRate subscriptionRate;
  final String? subscriptionModified;
  final SharesOnOffer sharesOnOffer;
  final ImportantDates importantDates;
  final ListingGains? listingGains;
  final String? financials; // HTML content
  final CompanyInformation information;
  final StrengthsAndRisks strengthsAndRisks;
  final List<LeadManagerRegistrar> leadManagersAndRegistrars;
  final List<FAQ> faqs;
  final StockData stockData;
  final AllotmentData allotment;
  final String? category; // New category field for mainboard/sme

  const FirebaseIPO({
    required this.companyHeaders,
    required this.companyIpoOverview,
    this.companyEvents,
    required this.subscriptionRate,
    this.subscriptionModified,
    required this.sharesOnOffer,
    required this.importantDates,
    this.listingGains,
    this.financials,
    required this.information,
    required this.strengthsAndRisks,
    required this.leadManagersAndRegistrars,
    required this.faqs,
    required this.stockData,
    required this.allotment,
    this.category,
  });

  factory FirebaseIPO.fromJson(Map<String, dynamic> json) {
    return FirebaseIPO(
      companyHeaders: CompanyHeaders.fromJson(json['company_headers'] ?? {}),
      companyIpoOverview:
          CompanyIPOOverview.fromJson(json['company_ipo_overview'] ?? {}),
      companyEvents: json['company_events'],
      subscriptionRate:
          SubscriptionRate.fromJson(json['subscription_rate'] ?? {}),
      subscriptionModified: json['subscription_modified'],
      sharesOnOffer: SharesOnOffer.fromJson(json['shares_on_offer'] ?? {}),
      importantDates: ImportantDates.fromJson(json['important_dates'] ?? {}),
      listingGains: json['listing_gains'] != null
          ? ListingGains.fromJson(json['listing_gains'])
          : null,
      financials: json['financials'],
      information: CompanyInformation.fromJson(json['information'] ?? {}),
      strengthsAndRisks:
          StrengthsAndRisks.fromJson(json['strengths_and_risks'] ?? {}),
      leadManagersAndRegistrars: json['lead_managers_and_registrars'] != null
          ? (json['lead_managers_and_registrars'] as List)
              .map((item) => LeadManagerRegistrar.fromJson(item))
              .toList()
          : [],
      faqs: json['faqs'] != null
          ? (json['faqs'] as List).map((item) => FAQ.fromJson(item)).toList()
          : [],
      stockData: StockData.fromJson(json['stock_data'] ?? {}),
      allotment: AllotmentData.fromJson(json['allotment'] ?? {}),
      category: json['category'], // Add category field
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company_headers': companyHeaders.toJson(),
      'company_ipo_overview': companyIpoOverview.toJson(),
      'company_events': companyEvents,
      'subscription_rate': subscriptionRate.toJson(),
      'subscription_modified': subscriptionModified,
      'shares_on_offer': sharesOnOffer.toJson(),
      'important_dates': importantDates.toJson(),
      'listing_gains': listingGains?.toJson(),
      'financials': financials,
      'information': information.toJson(),
      'strengths_and_risks': strengthsAndRisks.toJson(),
      'lead_managers_and_registrars':
          leadManagersAndRegistrars.map((item) => item.toJson()).toList(),
      'faqs': faqs.map((item) => item.toJson()).toList(),
      'stock_data': stockData.toJson(),
      'allotment': allotment.toJson(),
      'category': category, // Add category field
    };
  }

  /// Convert Firebase IPO to legacy IPO model for backward compatibility
  IPO toLegacyIPO() {
    // Create offer date from important dates
    final offerDate = OfferDate(
      start: importantDates.openDate ?? '',
      end: importantDates.closeDate ?? '',
    );

    // Create offer price from company IPO overview
    final offerPrice = OfferPrice(
      min: (companyIpoOverview.priceRangeMin ?? 0).toDouble(),
      max: (companyIpoOverview.priceRangeMax ?? 0).toDouble(),
    );

    // Create subscription from subscription rate
    final subscription = Subscription(
      times: subscriptionRate.subscriptionHeaderData?.totalSubscribed,
      retail: subscriptionRate.subscriptionHeaderData?.retailIndividualInvestor,
      hni: subscriptionRate.subscriptionHeaderData?.nonInstitutionalInvestor,
      qib:
          subscriptionRate.subscriptionHeaderData?.qualifiedInstitutionalBuyers,
    );

    // Create GMP from listing gains
    final gmp = GMP(
      premium: listingGains?.listingGainPercent,
      percentage: listingGains?.currentGainPercent,
    );

    // Create expected premium from listing gains
    final expectedPremium = ExpectedPremium(
      range: listingGains != null
          ? '${listingGains!.listingGainPercent?.toStringAsFixed(1) ?? '0'} - ${listingGains!.currentGainPercent?.toStringAsFixed(1) ?? '0'}'
          : null,
      note: '',
    );

    // Create promoters from information
    final promoters = Promoters(
      preIssueHolding: companyIpoOverview.postIssuePromoterHoldingPercent,
      postIssueHolding: companyIpoOverview.postIssuePromoterHoldingPercent,
      names: information.promoters ?? [],
    );

    // Create valuations (empty for now as not in Firebase structure)
    const valuations = Valuations();

    return IPO(
      id: companyHeaders.ipoId.toString(),
      name: companyHeaders.companyName,
      logo: companyHeaders.companyLogo,
      offerDate: offerDate,
      status: _getStatusFromDates(),
      exchange: importantDates.exchangeFlags ?? '',
      category:
          stockData.isSme == true ? IPOCategory.sme : IPOCategory.mainboard,
      offerPrice: offerPrice,
      lotSize: companyIpoOverview.lotSize ?? 0,
      subscription: subscription,
      gmp: gmp,
      issueSize: _formatIssueSize(),
      listingDate: importantDates.listingDate,
      allotmentDate: importantDates.allotmentDate,
      faceValue: 10.0, // Default face value
      companyDescription: information.aboutTheCompany ?? '',
      sector: stockData.sectorName ?? '',
      registrar: _getRegistrar(),
      leadManagers: _getLeadManagers(),
      financials: [], // Empty for now
      valuations: valuations,
      promoters: promoters,
      issueObjectives: _getIssueObjectives(),
      strengths: _getStrengths(),
      weaknesses: _getRisks(),
      expectedPremium: expectedPremium,
    );
  }

  String _getStatusFromDates() {
    final now = DateTime.now();
    final openDate = DateTime.tryParse(importantDates.openDate ?? '');
    final closeDate = DateTime.tryParse(importantDates.closeDate ?? '');
    final listingDate = DateTime.tryParse(importantDates.listingDate ?? '');

    if (listingDate != null && now.isAfter(listingDate)) {
      return 'listed';
    } else if (openDate != null && closeDate != null) {
      if (now.isBefore(openDate)) {
        return 'upcoming';
      } else if (now.isAfter(closeDate)) {
        return 'closed';
      } else {
        return 'current';
      }
    }
    return 'upcoming';
  }

  String _formatIssueSize() {
    if (companyIpoOverview.issueSize != null) {
      final size =
          companyIpoOverview.issueSize! / 10000000; // Convert to crores
      return '₹${size.toStringAsFixed(2)} Crores';
    }
    return '';
  }

  String? _getRegistrar() {
    final registrars = leadManagersAndRegistrars
        .where((item) => item.designation.toLowerCase().contains('registrar'))
        .toList();
    return registrars.isNotEmpty ? registrars.first.name : null;
  }

  List<String> _getLeadManagers() {
    return leadManagersAndRegistrars
        .where(
            (item) => item.designation.toLowerCase().contains('lead manager'))
        .map((item) => item.name)
        .toList();
  }

  List<String> _getIssueObjectives() {
    if (information.objectOfTheIssue != null) {
      // Parse HTML content to extract objectives
      return [information.objectOfTheIssue!];
    }
    return [];
  }

  List<String> _getStrengths() {
    return strengthsAndRisks.strengths?.map((item) => item.title).toList() ??
        [];
  }

  List<String> _getRisks() {
    return strengthsAndRisks.risks?.map((item) => item.title).toList() ?? [];
  }
}
