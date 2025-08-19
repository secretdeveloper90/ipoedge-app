enum IPOCategory {
  sme,
  mainboard,
}

enum IPOStatus {
  upcoming,
  current,
  closed,
  listed,
  withdrawn,
}

// New Firebase data structure models
class CompanyHeaders {
  final String companyName;
  final String companyShortName;
  final int ipoId;
  final String companySlugName;
  final String? stockPageUrl;
  final String? registrarAllotmentUrl;
  final String? exchangeAllotmentUrl;
  final String? companyLogo;
  final String? biddingDates;
  final String? biddingDateOpen;
  final String? biddingDateClose;
  final String? ipoFailureMessage;
  final bool? recentlyListed;
  final double? subscriptionValue;
  final String? subscriptionText;
  final String? subscriptionColor;

  const CompanyHeaders({
    required this.companyName,
    required this.companyShortName,
    required this.ipoId,
    required this.companySlugName,
    this.stockPageUrl,
    this.registrarAllotmentUrl,
    this.exchangeAllotmentUrl,
    this.companyLogo,
    this.biddingDates,
    this.biddingDateOpen,
    this.biddingDateClose,
    this.ipoFailureMessage,
    this.recentlyListed,
    this.subscriptionValue,
    this.subscriptionText,
    this.subscriptionColor,
  });

  factory CompanyHeaders.fromJson(Map<String, dynamic> json) {
    return CompanyHeaders(
      companyName: json['company_name'] ?? '',
      companyShortName: json['company_short_name'] ?? '',
      ipoId: (json['ipo_id'] ?? 0).toInt(),
      companySlugName: json['company_slug_name'] ?? '',
      stockPageUrl: json['stock_page_url'],
      registrarAllotmentUrl: json['registrar_allotment_url'],
      exchangeAllotmentUrl: json['exchange_allotment_url'],
      companyLogo: json['company_logo'],
      biddingDates: json['bidding_dates'],
      biddingDateOpen: json['bidding_date_open'],
      biddingDateClose: json['bidding_date_close'],
      ipoFailureMessage: json['ipo_failure_message'],
      recentlyListed: json['recentlyListed'],
      subscriptionValue: json['subscription_value']?.toDouble(),
      subscriptionText: json['subscription_text'],
      subscriptionColor: json['subscription_color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company_name': companyName,
      'company_short_name': companyShortName,
      'ipo_id': ipoId,
      'company_slug_name': companySlugName,
      'stock_page_url': stockPageUrl,
      'registrar_allotment_url': registrarAllotmentUrl,
      'exchange_allotment_url': exchangeAllotmentUrl,
      'company_logo': companyLogo,
      'bidding_dates': biddingDates,
      'bidding_date_open': biddingDateOpen,
      'bidding_date_close': biddingDateClose,
      'ipo_failure_message': ipoFailureMessage,
      'recentlyListed': recentlyListed,
      'subscription_value': subscriptionValue,
      'subscription_text': subscriptionText,
      'subscription_color': subscriptionColor,
    };
  }
}

class CompanyIPOOverview {
  final int? minInvestment;
  final int? lotSize;
  final int? noOfShares;
  final int? priceRangeMin;
  final int? priceRangeMax;
  final int? issuePrice;
  final int? issueSize;
  final double? postIssuePromoterHoldingPercent;
  final int? issueSizeMin;
  final int? issueSizeMax;
  final String? ipoRhpDocument;
  final String? ipoDrhpDocument;
  final String? rhpExternalDocument;
  final RetailData? retailData;
  final int? minLot;
  final int? maxLot;

  const CompanyIPOOverview({
    this.minInvestment,
    this.lotSize,
    this.noOfShares,
    this.priceRangeMin,
    this.priceRangeMax,
    this.issuePrice,
    this.issueSize,
    this.postIssuePromoterHoldingPercent,
    this.issueSizeMin,
    this.issueSizeMax,
    this.ipoRhpDocument,
    this.ipoDrhpDocument,
    this.rhpExternalDocument,
    this.retailData,
    this.minLot,
    this.maxLot,
  });

  factory CompanyIPOOverview.fromJson(Map<String, dynamic> json) {
    return CompanyIPOOverview(
      minInvestment: json['min_investment']?.toInt(),
      lotSize: json['lot_size']?.toInt(),
      noOfShares: json['no_of_shares']?.toInt(),
      priceRangeMin: json['price_range_min']?.toInt(),
      priceRangeMax: json['price_range_max']?.toInt(),
      issuePrice: json['issue_price']?.toInt(),
      issueSize: json['issue_size']?.toInt(),
      postIssuePromoterHoldingPercent:
          json['post_issue_promoter_holding_percent']?.toDouble(),
      issueSizeMin: json['issue_size_min']?.toInt(),
      issueSizeMax: json['issue_size_max']?.toInt(),
      ipoRhpDocument: json['ipo_rhp_document'],
      ipoDrhpDocument: json['ipo_drhp_document'],
      rhpExternalDocument: json['rhp_external_document'],
      retailData: json['retail_data'] != null
          ? RetailData.fromJson(json['retail_data'])
          : null,
      minLot: json['min_lot']?.toInt(),
      maxLot: json['max_lot']?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'min_investment': minInvestment,
      'lot_size': lotSize,
      'no_of_shares': noOfShares,
      'price_range_min': priceRangeMin,
      'price_range_max': priceRangeMax,
      'issue_price': issuePrice,
      'issue_size': issueSize,
      'post_issue_promoter_holding_percent': postIssuePromoterHoldingPercent,
      'issue_size_min': issueSizeMin,
      'issue_size_max': issueSizeMax,
      'ipo_rhp_document': ipoRhpDocument,
      'ipo_drhp_document': ipoDrhpDocument,
      'rhp_external_document': rhpExternalDocument,
      'retail_data': retailData?.toJson(),
      'min_lot': minLot,
      'max_lot': maxLot,
    };
  }
}

class RetailData {
  final int? applicationLotSizeMin;
  final int? applicationLotSizeMax;
  final int? applicationShareSizeMin;
  final int? applicationShareSizeMax;

  const RetailData({
    this.applicationLotSizeMin,
    this.applicationLotSizeMax,
    this.applicationShareSizeMin,
    this.applicationShareSizeMax,
  });

  factory RetailData.fromJson(Map<String, dynamic> json) {
    return RetailData(
      applicationLotSizeMin: json['application_lot_size_min']?.toInt(),
      applicationLotSizeMax: json['application_lot_size_max']?.toInt(),
      applicationShareSizeMin: json['application_share_size_min']?.toInt(),
      applicationShareSizeMax: json['application_share_size_max']?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'application_lot_size_min': applicationLotSizeMin,
      'application_lot_size_max': applicationLotSizeMax,
      'application_share_size_min': applicationShareSizeMin,
      'application_share_size_max': applicationShareSizeMax,
    };
  }
}

class SubscriptionRate {
  final List<SubscriptionHeader>? subscriptionHeader;
  final SubscriptionHeaderData? subscriptionHeaderData;
  final List<SubscriptionDetail>? subscriptionDetails;

  const SubscriptionRate({
    this.subscriptionHeader,
    this.subscriptionHeaderData,
    this.subscriptionDetails,
  });

  factory SubscriptionRate.fromJson(Map<String, dynamic> json) {
    return SubscriptionRate(
      subscriptionHeader: json['subscription_header'] != null
          ? (json['subscription_header'] as List)
              .map((item) => SubscriptionHeader.fromJson(item))
              .toList()
          : null,
      subscriptionHeaderData: json['subscription_header_data'] != null
          ? SubscriptionHeaderData.fromJson(json['subscription_header_data'])
          : null,
      subscriptionDetails: json['subscription_details'] != null
          ? (json['subscription_details'] as List)
              .map((item) => SubscriptionDetail.fromJson(item))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subscription_header':
          subscriptionHeader?.map((item) => item.toJson()).toList(),
      'subscription_header_data': subscriptionHeaderData?.toJson(),
      'subscription_details':
          subscriptionDetails?.map((item) => item.toJson()).toList(),
    };
  }
}

class SubscriptionHeader {
  final String name;
  final String accessor;

  const SubscriptionHeader({
    required this.name,
    required this.accessor,
  });

  factory SubscriptionHeader.fromJson(Map<String, dynamic> json) {
    return SubscriptionHeader(
      name: json['name'] ?? '',
      accessor: json['accessor'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'accessor': accessor,
    };
  }
}

class SubscriptionHeaderData {
  final String? date;
  final double? totalSubscribed;
  final double? retailIndividualInvestor;
  final double? nonInstitutionalInvestor;
  final double? qualifiedInstitutionalBuyers;

  const SubscriptionHeaderData({
    this.date,
    this.totalSubscribed,
    this.retailIndividualInvestor,
    this.nonInstitutionalInvestor,
    this.qualifiedInstitutionalBuyers,
  });

  factory SubscriptionHeaderData.fromJson(Map<String, dynamic> json) {
    return SubscriptionHeaderData(
      date: json['date'],
      totalSubscribed: json['total_subscribed']?.toDouble(),
      retailIndividualInvestor: json['retail_individual_investor']?.toDouble(),
      nonInstitutionalInvestor: json['non_institutional_investor']?.toDouble(),
      qualifiedInstitutionalBuyers:
          json['qualified_institutional_buyers']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'total_subscribed': totalSubscribed,
      'retail_individual_investor': retailIndividualInvestor,
      'non_institutional_investor': nonInstitutionalInvestor,
      'qualified_institutional_buyers': qualifiedInstitutionalBuyers,
    };
  }
}

class SubscriptionDetail {
  final String? day;
  final double? retailIndividualInvestor;
  final double? nonInstitutionalInvestor;
  final double? qualifiedInstitutionalBuyers;
  final String? modified;

  const SubscriptionDetail({
    this.day,
    this.retailIndividualInvestor,
    this.nonInstitutionalInvestor,
    this.qualifiedInstitutionalBuyers,
    this.modified,
  });

  factory SubscriptionDetail.fromJson(Map<String, dynamic> json) {
    return SubscriptionDetail(
      day: json['day'],
      retailIndividualInvestor: json['retail_individual_investor']?.toDouble(),
      nonInstitutionalInvestor: json['non_institutional_investor']?.toDouble(),
      qualifiedInstitutionalBuyers:
          json['qualified_institutional_buyers']?.toDouble(),
      modified: json['modified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'retail_individual_investor': retailIndividualInvestor,
      'non_institutional_investor': nonInstitutionalInvestor,
      'qualified_institutional_buyers': qualifiedInstitutionalBuyers,
      'modified': modified,
    };
  }
}

class OfferDate {
  final String start;
  final String end;

  const OfferDate({
    required this.start,
    required this.end,
  });

  /// Returns formatted date range like "29 Jul - 31 Jul, 2025"
  String get formatted {
    try {
      final startDate = DateTime.parse(start);
      final endDate = DateTime.parse(end);

      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];

      final startDay = startDate.day;
      final startMonth = months[startDate.month - 1];
      final endDay = endDate.day;
      final endMonth = months[endDate.month - 1];
      final year = endDate.year;

      if (startDate.month == endDate.month && startDate.year == endDate.year) {
        // Same month and year: "29 - 31 Jul, 2025"
        return '$startDay - $endDay $endMonth, $year';
      } else if (startDate.year == endDate.year) {
        // Same year, different months: "29 Jul - 31 Aug, 2025"
        return '$startDay $startMonth - $endDay $endMonth, $year';
      } else {
        // Different years: "29 Jul, 2024 - 31 Jan, 2025"
        return '$startDay $startMonth, ${startDate.year} - $endDay $endMonth, $year';
      }
    } catch (e) {
      // Fallback to original format if parsing fails
      return '$start - $end';
    }
  }

  factory OfferDate.fromJson(Map<String, dynamic> json) {
    return OfferDate(
      start: json['start'],
      end: json['end'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start': start,
      'end': end,
    };
  }
}

class OfferPrice {
  final double min;
  final double max;

  const OfferPrice({
    required this.min,
    required this.max,
  });

  String get formatted => '₹${min.toInt()} - ₹${max.toInt()}';

  factory OfferPrice.fromJson(Map<String, dynamic> json) {
    return OfferPrice(
      min: json['min'].toDouble(),
      max: json['max'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'min': min,
      'max': max,
    };
  }
}

class Subscription {
  final double? times;
  final double? retail;
  final double? hni;
  final double? qib;
  final double? employee;

  const Subscription({
    this.times,
    this.retail,
    this.hni,
    this.qib,
    this.employee,
  });

  /// Returns the subscription times with fallback to 0.0 if null
  double get displayTimes => times ?? 0.0;

  /// Returns true if subscription data is available
  bool get hasSubscriptionData => times != null && times! > 0;

  /// Returns formatted subscription times for display
  String get formattedTimes =>
      hasSubscriptionData ? '${displayTimes.toStringAsFixed(1)}x' : '-';

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      times: json['times']?.toDouble(),
      retail: json['retail']?.toDouble(),
      hni: json['hni']?.toDouble(),
      qib: json['qib']?.toDouble(),
      employee: json['employee']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'times': times,
      'retail': retail,
      'hni': hni,
      'qib': qib,
      'employee': employee,
    };
  }
}

class GMP {
  final double? premium;
  final double? percentage;

  const GMP({
    this.premium,
    this.percentage,
  });

  /// Returns true if GMP data is available
  bool get hasGMPData => premium != null && percentage != null;

  /// Returns formatted premium with fallback
  String get formattedPremium => premium != null ? '₹${premium!.toInt()}' : '-';

  /// Returns formatted percentage with fallback
  String get formattedPercentage =>
      percentage != null ? '${percentage!.toStringAsFixed(1)}%' : '-';

  /// Returns safe premium value for calculations
  double get safePremium => premium ?? 0.0;

  /// Returns safe percentage value for calculations
  double get safePercentage => percentage ?? 0.0;

  factory GMP.fromJson(Map<String, dynamic> json) {
    return GMP(
      premium: json['premium']?.toDouble(),
      percentage: json['percentage']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'premium': premium,
      'percentage': percentage,
    };
  }
}

class Financial {
  final String year;
  final double? revenue;
  final double? profit;
  final double? assets;
  final double? netWorth;
  final double? totalBorrowing;
  final double? cashFlowFromOperations;
  final double? freeCashFlow;
  final double? margins;

  const Financial({
    required this.year,
    this.revenue,
    this.profit,
    this.assets,
    this.netWorth,
    this.totalBorrowing,
    this.cashFlowFromOperations,
    this.freeCashFlow,
    this.margins,
  });

  /// Returns formatted revenue with fallback
  String get formattedRevenue =>
      revenue != null ? '₹${revenue!.toStringAsFixed(2)} Cr' : '-';

  /// Returns formatted profit with fallback
  String get formattedProfit =>
      profit != null ? '₹${profit!.toStringAsFixed(2)} Cr' : '-';

  /// Returns formatted assets with fallback
  String get formattedAssets =>
      assets != null ? '₹${assets!.toStringAsFixed(2)} Cr' : '-';

  /// Returns formatted net worth with fallback
  String get formattedNetWorth =>
      netWorth != null ? '₹${netWorth!.toStringAsFixed(2)} Cr' : '-';

  /// Returns formatted total borrowing with fallback
  String get formattedTotalBorrowing => totalBorrowing != null
      ? '₹${totalBorrowing!.toStringAsFixed(2)} Cr'
      : '-';

  /// Returns formatted cash flow from operations with fallback
  String get formattedCashFlowFromOperations => cashFlowFromOperations != null
      ? '₹${cashFlowFromOperations!.toStringAsFixed(2)} Cr'
      : '-';

  /// Returns formatted free cash flow with fallback
  String get formattedFreeCashFlow =>
      freeCashFlow != null ? '₹${freeCashFlow!.toStringAsFixed(2)} Cr' : '-';

  /// Returns formatted margins with fallback
  String get formattedMargins =>
      margins != null ? '${margins!.toStringAsFixed(1)}%' : '-';

  factory Financial.fromJson(Map<String, dynamic> json) {
    return Financial(
      year: json['year'],
      revenue: json['revenue']?.toDouble(),
      profit: json['profit']?.toDouble(),
      assets: json['assets']?.toDouble(),
      netWorth: json['netWorth']?.toDouble(),
      totalBorrowing: json['totalBorrowing']?.toDouble(),
      cashFlowFromOperations: json['cashFlowFromOperations']?.toDouble(),
      freeCashFlow: json['freeCashFlow']?.toDouble(),
      margins: json['margins']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'year': year,
      'revenue': revenue,
      'profit': profit,
      'assets': assets,
      'netWorth': netWorth,
      'totalBorrowing': totalBorrowing,
      'cashFlowFromOperations': cashFlowFromOperations,
      'freeCashFlow': freeCashFlow,
      'margins': margins,
    };
  }
}

class Valuations {
  final double? epsPreIpo;
  final double? epsPostIpo;
  final double? pePreIpo;
  final double? pePostIpo;
  final double? roe;
  final double? roce;
  final double? patMargin;
  final double? debtEquity;
  final double? priceToBook;
  final double? ronw;

  const Valuations({
    this.epsPreIpo,
    this.epsPostIpo,
    this.pePreIpo,
    this.pePostIpo,
    this.roe,
    this.roce,
    this.patMargin,
    this.debtEquity,
    this.priceToBook,
    this.ronw,
  });

  factory Valuations.fromJson(Map<String, dynamic> json) {
    return Valuations(
      epsPreIpo: json['epsPreIpo']?.toDouble(),
      epsPostIpo: json['epsPostIpo']?.toDouble(),
      pePreIpo: json['pePreIpo']?.toDouble(),
      pePostIpo: json['pePostIpo']?.toDouble(),
      roe: json['roe']?.toDouble(),
      roce: json['roce']?.toDouble(),
      patMargin: json['patMargin']?.toDouble(),
      debtEquity: json['debtEquity']?.toDouble(),
      priceToBook: json['priceToBook']?.toDouble(),
      ronw: json['ronw']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'epsPreIpo': epsPreIpo,
      'epsPostIpo': epsPostIpo,
      'pePreIpo': pePreIpo,
      'pePostIpo': pePostIpo,
      'roe': roe,
      'roce': roce,
      'patMargin': patMargin,
      'debtEquity': debtEquity,
      'priceToBook': priceToBook,
      'ronw': ronw,
    };
  }
}

class Promoters {
  final double? preIssueHolding;
  final double? postIssueHolding;
  final List<String> names;

  const Promoters({
    this.preIssueHolding,
    this.postIssueHolding,
    required this.names,
  });

  factory Promoters.fromJson(Map<String, dynamic> json) {
    return Promoters(
      preIssueHolding: json['preIssueHolding']?.toDouble(),
      postIssueHolding: json['postIssueHolding']?.toDouble(),
      names: List<String>.from(json['names']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'preIssueHolding': preIssueHolding,
      'postIssueHolding': postIssueHolding,
      'names': names,
    };
  }
}

class ExpectedPremium {
  final String? range;
  final String note;

  const ExpectedPremium({
    this.range,
    required this.note,
  });

  /// Returns the range with fallback to "-" if null
  String get displayRange => range ?? '-';

  /// Returns true if range data is available
  bool get hasRange => range != null && range!.isNotEmpty;

  factory ExpectedPremium.fromJson(Map<String, dynamic> json) {
    return ExpectedPremium(
      range: json['range'],
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'range': range,
      'note': note,
    };
  }
}

class CompanyDetails {
  final int? foundedYear;
  final String? headquarters;
  final int? employees;
  final String? website;
  final String? email;
  final String? phone;
  final Map<String, dynamic>? businessOperations;

  const CompanyDetails({
    this.foundedYear,
    this.headquarters,
    this.employees,
    this.website,
    this.email,
    this.phone,
    this.businessOperations,
  });

  factory CompanyDetails.fromJson(Map<String, dynamic> json) {
    return CompanyDetails(
      foundedYear: json['foundedYear'],
      headquarters: json['headquarters'],
      employees: json['employees'],
      website: json['website'],
      email: json['email'],
      phone: json['phone'],
      businessOperations: json['businessOperations'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'foundedYear': foundedYear,
      'headquarters': headquarters,
      'employees': employees,
      'website': website,
      'email': email,
      'phone': phone,
      'businessOperations': businessOperations,
    };
  }
}

class RegistrarDetails {
  final String name;
  final String? phone;
  final String? email;
  final String? address;
  final String? website;

  const RegistrarDetails({
    required this.name,
    this.phone,
    this.email,
    this.address,
    this.website,
  });

  factory RegistrarDetails.fromJson(Map<String, dynamic> json) {
    return RegistrarDetails(
      name: json['name'] ?? json.toString(),
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
      website: json['website'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'website': website,
    };
  }
}

class IPODocument {
  final String title;
  final String url;
  final String type;
  final String? size;
  final DateTime? uploadDate;

  const IPODocument({
    required this.title,
    required this.url,
    required this.type,
    this.size,
    this.uploadDate,
  });

  factory IPODocument.fromJson(Map<String, dynamic> json) {
    return IPODocument(
      title: json['title'],
      url: json['url'],
      type: json['type'],
      size: json['size'],
      uploadDate: json['uploadDate'] != null
          ? DateTime.parse(json['uploadDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'url': url,
      'type': type,
      'size': size,
      'uploadDate': uploadDate?.toIso8601String(),
    };
  }
}

class FreshIssue {
  final int shares;
  final String amount;

  const FreshIssue({
    required this.shares,
    required this.amount,
  });

  factory FreshIssue.fromJson(Map<String, dynamic> json) {
    return FreshIssue(
      shares: json['shares'],
      amount: json['amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shares': shares,
      'amount': amount,
    };
  }
}

class OFS {
  final int shares;
  final String amount;

  const OFS({
    required this.shares,
    required this.amount,
  });

  factory OFS.fromJson(Map<String, dynamic> json) {
    return OFS(
      shares: json['shares'],
      amount: json['amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shares': shares,
      'amount': amount,
    };
  }
}

class MarketLotDetails {
  final int shares;
  final int amount;
  final int applications;

  const MarketLotDetails({
    required this.shares,
    required this.amount,
    required this.applications,
  });

  factory MarketLotDetails.fromJson(Map<String, dynamic> json) {
    return MarketLotDetails(
      shares: json['shares'] ?? 0,
      amount: json['amount'] ?? 0,
      applications: json['applications'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shares': shares,
      'amount': amount,
      'applications': applications,
    };
  }
}

class MarketLot {
  final MarketLotDetails retail;
  final MarketLotDetails sHni;
  final MarketLotDetails bHni;

  const MarketLot({
    required this.retail,
    required this.sHni,
    required this.bHni,
  });

  factory MarketLot.fromJson(Map<String, dynamic> json) {
    return MarketLot(
      retail: MarketLotDetails.fromJson(json['retail']),
      sHni: MarketLotDetails.fromJson(json['sHni']),
      bHni: MarketLotDetails.fromJson(json['bHni']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'retail': retail.toJson(),
      'sHni': sHni.toJson(),
      'bHni': bHni.toJson(),
    };
  }
}

class SharesOffered {
  final int qib;
  final int nii;
  final int bNii;
  final int sNii;
  final int retail;
  final int total;

  const SharesOffered({
    required this.qib,
    required this.nii,
    required this.bNii,
    required this.sNii,
    required this.retail,
    required this.total,
  });

  factory SharesOffered.fromJson(Map<String, dynamic> json) {
    return SharesOffered(
      qib: json['qib'],
      nii: json['nii'],
      bNii: json['bNii'],
      sNii: json['sNii'],
      retail: json['retail'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'qib': qib,
      'nii': nii,
      'bNii': bNii,
      'sNii': sNii,
      'retail': retail,
      'total': total,
    };
  }
}

class AnchorInvestors {
  final String? totalAmount;
  final List<String> investors;

  const AnchorInvestors({
    this.totalAmount,
    required this.investors,
  });

  factory AnchorInvestors.fromJson(Map<String, dynamic> json) {
    return AnchorInvestors(
      totalAmount: json['totalAmount'],
      investors: List<String>.from(json['investors']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalAmount': totalAmount,
      'investors': investors,
    };
  }
}

class Peer {
  final String name;
  final double? pbRatio;
  final double? peRatio;
  final double? ronw;
  final double? netWorth;

  const Peer({
    required this.name,
    this.pbRatio,
    this.peRatio,
    this.ronw,
    this.netWorth,
  });

  factory Peer.fromJson(Map<String, dynamic> json) {
    return Peer(
      name: json['name'],
      pbRatio: json['pbRatio']?.toDouble(),
      peRatio: json['peRatio']?.toDouble(),
      ronw: json['ronw']?.toDouble(),
      netWorth: json['netWorth']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'pbRatio': pbRatio,
      'peRatio': peRatio,
      'ronw': ronw,
      'netWorth': netWorth,
    };
  }
}

class ProductPortfolio {
  final List<String> mainProducts;
  final String goldType;
  final List<String> occasions;
  final String priceSegments;

  const ProductPortfolio({
    required this.mainProducts,
    required this.goldType,
    required this.occasions,
    required this.priceSegments,
  });

  factory ProductPortfolio.fromJson(Map<String, dynamic> json) {
    return ProductPortfolio(
      mainProducts: List<String>.from(json['mainProducts']),
      goldType: json['goldType'],
      occasions: List<String>.from(json['occasions']),
      priceSegments: json['priceSegments'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mainProducts': mainProducts,
      'goldType': goldType,
      'occasions': occasions,
      'priceSegments': priceSegments,
    };
  }
}

class BiddingTimings {
  final String hni;
  final String retail;

  const BiddingTimings({
    required this.hni,
    required this.retail,
  });

  factory BiddingTimings.fromJson(Map<String, dynamic> json) {
    return BiddingTimings(
      hni: json['hni'],
      retail: json['retail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hni': hni,
      'retail': retail,
    };
  }
}

// New Firebase models for additional data structures
class SharesOnOffer {
  final int? totalSharesOffered;
  final int? freshIssue;
  final int? offerForSale;
  final double? postIssuePromoterHoldingPercent;

  const SharesOnOffer({
    this.totalSharesOffered,
    this.freshIssue,
    this.offerForSale,
    this.postIssuePromoterHoldingPercent,
  });

  factory SharesOnOffer.fromJson(Map<String, dynamic> json) {
    return SharesOnOffer(
      totalSharesOffered: json['total_shares_offered']?.toInt(),
      freshIssue: json['fresh_issue']?.toInt(),
      offerForSale: json['offer_for_sale']?.toInt(),
      postIssuePromoterHoldingPercent:
          json['post_issue_promoter_holding_percent']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_shares_offered': totalSharesOffered,
      'fresh_issue': freshIssue,
      'offer_for_sale': offerForSale,
      'post_issue_promoter_holding_percent': postIssuePromoterHoldingPercent,
    };
  }
}

class ImportantDates {
  final String? allotmentDate;
  final String? refundDate;
  final String? dematCreditDate;
  final String? listingDate;
  final String? openDate;
  final String? closeDate;
  final String? exchangeFlags;

  const ImportantDates({
    this.allotmentDate,
    this.refundDate,
    this.dematCreditDate,
    this.listingDate,
    this.openDate,
    this.closeDate,
    this.exchangeFlags,
  });

  factory ImportantDates.fromJson(Map<String, dynamic> json) {
    return ImportantDates(
      allotmentDate: json['allotment_date'],
      refundDate: json['refund_date'],
      dematCreditDate: json['demat_credit_date'],
      listingDate: json['listing_date'],
      openDate: json['open_date'],
      closeDate: json['close_date'],
      exchangeFlags: json['exchange_flags'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'allotment_date': allotmentDate,
      'refund_date': refundDate,
      'demat_credit_date': dematCreditDate,
      'listing_date': listingDate,
      'open_date': openDate,
      'close_date': closeDate,
      'exchange_flags': exchangeFlags,
    };
  }
}

class ListingGains {
  final double? adjustedIssuePrice;
  final double? listingOpenPrice;
  final double? listingClosePrice;
  final double? listingGainPercent;
  final double? currentGainPercent;

  const ListingGains({
    this.adjustedIssuePrice,
    this.listingOpenPrice,
    this.listingClosePrice,
    this.listingGainPercent,
    this.currentGainPercent,
  });

  factory ListingGains.fromJson(Map<String, dynamic> json) {
    return ListingGains(
      adjustedIssuePrice: json['adjusted_issue_price']?.toDouble(),
      listingOpenPrice: json['listing_open_price']?.toDouble(),
      listingClosePrice: json['listing_close_price']?.toDouble(),
      listingGainPercent: json['listing_gain_percent']?.toDouble(),
      currentGainPercent: json['current_gain_percent']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'adjusted_issue_price': adjustedIssuePrice,
      'listing_open_price': listingOpenPrice,
      'listing_close_price': listingClosePrice,
      'listing_gain_percent': listingGainPercent,
      'current_gain_percent': currentGainPercent,
    };
  }
}

class CompanyInformation {
  final String? aboutTheCompany;
  final String? objectOfTheIssue;
  final List<String>? promoters;
  final List<ManagementMember>? management;

  const CompanyInformation({
    this.aboutTheCompany,
    this.objectOfTheIssue,
    this.promoters,
    this.management,
  });

  factory CompanyInformation.fromJson(Map<String, dynamic> json) {
    return CompanyInformation(
      aboutTheCompany: json['about_the_company'],
      objectOfTheIssue: json['object_of_the_issue'],
      promoters: json['promoters'] != null
          ? List<String>.from(json['promoters'])
          : null,
      management: json['management'] != null
          ? (json['management'] as List)
              .map((item) => ManagementMember.fromJson(item))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'about_the_company': aboutTheCompany,
      'object_of_the_issue': objectOfTheIssue,
      'promoters': promoters,
      'management': management?.map((item) => item.toJson()).toList(),
    };
  }
}

class ManagementMember {
  final String name;
  final String designation;

  const ManagementMember({
    required this.name,
    required this.designation,
  });

  factory ManagementMember.fromJson(Map<String, dynamic> json) {
    return ManagementMember(
      name: json['n'] ?? '',
      designation: json['d'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'n': name,
      'd': designation,
    };
  }
}

class StrengthsAndRisks {
  final List<StrengthRisk>? strengths;
  final List<StrengthRisk>? risks;

  const StrengthsAndRisks({
    this.strengths,
    this.risks,
  });

  factory StrengthsAndRisks.fromJson(Map<String, dynamic> json) {
    return StrengthsAndRisks(
      strengths: json['strengths'] != null
          ? (json['strengths'] as List)
              .map((item) => StrengthRisk.fromJson(item))
              .toList()
          : null,
      risks: json['risks'] != null
          ? (json['risks'] as List)
              .map((item) => StrengthRisk.fromJson(item))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'strengths': strengths?.map((item) => item.toJson()).toList(),
      'risks': risks?.map((item) => item.toJson()).toList(),
    };
  }
}

class StrengthRisk {
  final String title;
  final String description;

  const StrengthRisk({
    required this.title,
    required this.description,
  });

  factory StrengthRisk.fromJson(Map<String, dynamic> json) {
    return StrengthRisk(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
    };
  }
}

class LeadManagerRegistrar {
  final String name;
  final String? email;
  final String designation;
  final String? address;

  const LeadManagerRegistrar({
    required this.name,
    this.email,
    required this.designation,
    this.address,
  });

  factory LeadManagerRegistrar.fromJson(Map<String, dynamic> json) {
    return LeadManagerRegistrar(
      name: json['name'] ?? '',
      email: json['email'],
      designation: json['designation'] ?? '',
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'designation': designation,
      'address': address,
    };
  }
}

class FAQ {
  final String question;
  final String answer;

  const FAQ({
    required this.question,
    required this.answer,
  });

  factory FAQ.fromJson(Map<String, dynamic> json) {
    return FAQ(
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
    };
  }
}

class StockData {
  final int? stockId;
  final String? nseCode;
  final String? bseCode;
  final String? isin;
  final String? nseNumber;
  final String? bseScriptCode;
  final String? industryName;
  final String? sectorName;
  final bool? isSme;
  final bool? isShowFundamentalTable;

  const StockData({
    this.stockId,
    this.nseCode,
    this.bseCode,
    this.isin,
    this.nseNumber,
    this.bseScriptCode,
    this.industryName,
    this.sectorName,
    this.isSme,
    this.isShowFundamentalTable,
  });

  factory StockData.fromJson(Map<String, dynamic> json) {
    return StockData(
      stockId: json['stock_id']?.toInt(),
      nseCode: json['NSEcode'],
      bseCode: json['BSEcode'],
      isin: json['ISIN'],
      nseNumber: json['NSENumber'],
      bseScriptCode: json['BSEScriptCode'],
      industryName: json['industry_name'],
      sectorName: json['sector_name'],
      isSme: json['is_sme'],
      isShowFundamentalTable: json['is_show_fundamental_table'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stock_id': stockId,
      'NSEcode': nseCode,
      'BSEcode': bseCode,
      'ISIN': isin,
      'NSENumber': nseNumber,
      'BSEScriptCode': bseScriptCode,
      'industry_name': industryName,
      'sector_name': sectorName,
      'is_sme': isSme,
      'is_show_fundamental_table': isShowFundamentalTable,
    };
  }
}

class AllotmentData {
  final List<AllotmentHeader>? tableHeader;
  final AllotmentTableData? tableData;

  const AllotmentData({
    this.tableHeader,
    this.tableData,
  });

  factory AllotmentData.fromJson(Map<String, dynamic> json) {
    return AllotmentData(
      tableHeader: json['tableHeader'] != null
          ? (json['tableHeader'] as List)
              .map((item) => AllotmentHeader.fromJson(item))
              .toList()
          : null,
      tableData: json['tableData'] != null
          ? AllotmentTableData.fromJson(json['tableData'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tableHeader': tableHeader?.map((item) => item.toJson()).toList(),
      'tableData': tableData?.toJson(),
    };
  }
}

class AllotmentHeader {
  final String name;
  final String accessor;

  const AllotmentHeader({
    required this.name,
    required this.accessor,
  });

  factory AllotmentHeader.fromJson(Map<String, dynamic> json) {
    return AllotmentHeader(
      name: json['name'] ?? '',
      accessor: json['accessor'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'accessor': accessor,
    };
  }
}

class AllotmentTableData {
  final int? retailIndividualInvestor;
  final int? nonInstitutionalInvestor;
  final int? qualifiedInstitutionalBuyers;
  final int? employees;

  const AllotmentTableData({
    this.retailIndividualInvestor,
    this.nonInstitutionalInvestor,
    this.qualifiedInstitutionalBuyers,
    this.employees,
  });

  factory AllotmentTableData.fromJson(Map<String, dynamic> json) {
    return AllotmentTableData(
      retailIndividualInvestor: json['retail_individual_investor']?.toInt(),
      nonInstitutionalInvestor: json['non_institutional_investor']?.toInt(),
      qualifiedInstitutionalBuyers:
          json['qualified_institutional_buyers']?.toInt(),
      employees: json['employees']?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'retail_individual_investor': retailIndividualInvestor,
      'non_institutional_investor': nonInstitutionalInvestor,
      'qualified_institutional_buyers': qualifiedInstitutionalBuyers,
      'employees': employees,
    };
  }
}
