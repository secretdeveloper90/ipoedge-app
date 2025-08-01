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

  const Financial({
    required this.year,
    this.revenue,
    this.profit,
    this.assets,
    this.netWorth,
    this.totalBorrowing,
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

  factory Financial.fromJson(Map<String, dynamic> json) {
    return Financial(
      year: json['year'],
      revenue: json['revenue']?.toDouble(),
      profit: json['profit']?.toDouble(),
      assets: json['assets']?.toDouble(),
      netWorth: json['netWorth']?.toDouble(),
      totalBorrowing: json['totalBorrowing']?.toDouble(),
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
