class BrokerageRates {
  final String equityDelivery;
  final String equityIntraday;
  final String equityFutures;
  final String equityOptions;
  final String currencyFutures;
  final String currencyOptions;
  final String commodityFutures;
  final String commodityOptions;

  BrokerageRates({
    required this.equityDelivery,
    required this.equityIntraday,
    required this.equityFutures,
    required this.equityOptions,
    required this.currencyFutures,
    required this.currencyOptions,
    required this.commodityFutures,
    required this.commodityOptions,
  });

  factory BrokerageRates.fromJson(Map<String, dynamic> json) {
    return BrokerageRates(
      equityDelivery: json['equityDelivery']?.toString() ?? '',
      equityIntraday: json['equityIntraday']?.toString() ?? '',
      equityFutures: json['equityFutures']?.toString() ?? '',
      equityOptions: json['equityOptions']?.toString() ?? '',
      currencyFutures: json['currencyFutures']?.toString() ?? '',
      currencyOptions: json['currencyOptions']?.toString() ?? '',
      commodityFutures: json['commodityFutures']?.toString() ?? '',
      commodityOptions: json['commodityOptions']?.toString() ?? '',
    );
  }
}

class MarginRates {
  final String equityDelivery;
  final String equityIntraday;
  final String equityFutures;
  final String equityOptions;
  final String currencyFutures;
  final String currencyOptions;
  final String commodityFutures;
  final String commodityOptions;

  MarginRates({
    required this.equityDelivery,
    required this.equityIntraday,
    required this.equityFutures,
    required this.equityOptions,
    required this.currencyFutures,
    required this.currencyOptions,
    required this.commodityFutures,
    required this.commodityOptions,
  });

  factory MarginRates.fromJson(Map<String, dynamic> json) {
    return MarginRates(
      equityDelivery: json['equityDelivery']?.toString() ?? '',
      equityIntraday: json['equityIntraday']?.toString() ?? '',
      equityFutures: json['equityFutures']?.toString() ?? '',
      equityOptions: json['equityOptions']?.toString() ?? '',
      currencyFutures: json['currencyFutures']?.toString() ?? '',
      currencyOptions: json['currencyOptions']?.toString() ?? '',
      commodityFutures: json['commodityFutures']?.toString() ?? '',
      commodityOptions: json['commodityOptions']?.toString() ?? '',
    );
  }
}

class AdditionalFeatures {
  final bool account3in1;
  final bool freeTradingCalls;
  final bool freeResearch;
  final bool smsAlerts;
  final bool marginFunding;
  final bool marginAgainstShare;

  AdditionalFeatures({
    required this.account3in1,
    required this.freeTradingCalls,
    required this.freeResearch,
    required this.smsAlerts,
    required this.marginFunding,
    required this.marginAgainstShare,
  });

  factory AdditionalFeatures.fromJson(Map<String, dynamic> json) {
    return AdditionalFeatures(
      account3in1: json['3in1Account'] ?? false,
      freeTradingCalls: json['freeTradingCalls'] ?? false,
      freeResearch: json['freeResearch'] ?? false,
      smsAlerts: json['smsAlerts'] ?? false,
      marginFunding: json['marginFunding'] ?? false,
      marginAgainstShare: json['marginAgainstShare'] ?? false,
    );
  }
}

class ChargeDetails {
  final Map<String, String> transactionCharges;
  final String clearingCharges;
  final String dpCharges;
  final String gst;
  final String stt;
  final String sebiCharges;

  ChargeDetails({
    required this.transactionCharges,
    required this.clearingCharges,
    required this.dpCharges,
    required this.gst,
    required this.stt,
    required this.sebiCharges,
  });

  factory ChargeDetails.fromJson(Map<String, dynamic> json) {
    Map<String, String> transactionCharges = {};

    // Handle transactionCharges which might be a map or other type
    final transactionChargesData = json['transactionCharges'];
    if (transactionChargesData is Map) {
      transactionCharges = Map<String, String>.from(transactionChargesData.map(
        (key, value) => MapEntry(key.toString(), value?.toString() ?? ''),
      ));
    }

    return ChargeDetails(
      transactionCharges: transactionCharges,
      clearingCharges: json['clearingCharges']?.toString() ?? '',
      dpCharges: (json['dpCharges'] ?? json['dpCharge'])?.toString() ?? '',
      gst: json['gst']?.toString() ?? '',
      stt: json['stt']?.toString() ?? '',
      sebiCharges: json['sebiCharges']?.toString() ?? '',
    );
  }
}

class DetailedCharges {
  final ChargeDetails delivery;
  final ChargeDetails intraday;
  final ChargeDetails futures;
  final ChargeDetails options;

  DetailedCharges({
    required this.delivery,
    required this.intraday,
    required this.futures,
    required this.options,
  });

  factory DetailedCharges.fromJson(Map<String, dynamic> json) {
    return DetailedCharges(
      delivery: ChargeDetails.fromJson(json['delivery'] ?? {}),
      intraday: ChargeDetails.fromJson(json['intraday'] ?? {}),
      futures: ChargeDetails.fromJson(json['futures'] ?? {}),
      options: ChargeDetails.fromJson(json['options'] ?? {}),
    );
  }
}

class Broker {
  final String id;
  final String name;
  final String logo;
  final String type;
  final String activeClients;
  final String about;
  final String accountOpening;
  final String accountMaintenance;
  final String callTrade;
  final BrokerageRates brokerage;
  final MarginRates margins;
  final List<String> services;
  final List<String> platforms;
  final List<String> pros;
  final List<String> cons;
  final AdditionalFeatures additionalFeatures;
  final List<String> otherInvestments;
  final DetailedCharges charges;
  final double rating;
  final List<String> features;
  final String equityDelivery;
  final String equityIntraday;

  Broker({
    required this.id,
    required this.name,
    required this.logo,
    required this.type,
    required this.activeClients,
    required this.about,
    required this.accountOpening,
    required this.accountMaintenance,
    required this.callTrade,
    required this.brokerage,
    required this.margins,
    required this.services,
    required this.platforms,
    required this.pros,
    required this.cons,
    required this.additionalFeatures,
    required this.otherInvestments,
    required this.charges,
    required this.rating,
    required this.features,
    required this.equityDelivery,
    required this.equityIntraday,
  });

  factory Broker.fromJson(Map<String, dynamic> json) {
    return Broker(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
      type: json['type'] ?? '',
      activeClients: json['activeClients'] ?? '',
      about: json['about'] ?? '',
      accountOpening: json['accountOpening']?.toString() ?? '',
      accountMaintenance: json['accountMaintenance']?.toString() ?? '',
      callTrade: json['callTrade']?.toString() ?? '',
      brokerage: BrokerageRates.fromJson(json['brokerage'] ?? {}),
      margins: MarginRates.fromJson(json['margins'] ?? {}),
      services: List<String>.from(json['services'] ?? []),
      platforms: List<String>.from(json['platforms'] ?? []),
      pros: List<String>.from(json['pros'] ?? []),
      cons: List<String>.from(json['cons'] ?? []),
      additionalFeatures:
          AdditionalFeatures.fromJson(json['additionalFeatures'] ?? {}),
      otherInvestments: List<String>.from(json['otherInvestments'] ?? []),
      charges: DetailedCharges.fromJson(json['charges'] ?? {}),
      rating: (json['rating'] ?? 0.0).toDouble(),
      features: List<String>.from(json['features'] ?? []),
      equityDelivery: json['equityDelivery']?.toString() ?? '',
      equityIntraday: json['equityIntraday']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
      'type': type,
      'activeClients': activeClients,
      'about': about,
      'accountOpening': accountOpening,
      'accountMaintenance': accountMaintenance,
      'callTrade': callTrade,
      'rating': rating,
      'services': services,
      'platforms': platforms,
      'pros': pros,
      'cons': cons,
      'features': features,
      'equityDelivery': equityDelivery,
      'equityIntraday': equityIntraday,
    };
  }

  // Convenience getters for backward compatibility
  String get category => type;
  String get description => about;
  int get reviewCount => int.tryParse(activeClients.replaceAll(',', '')) ?? 0;

  String get categoryDisplayName {
    switch (type.toLowerCase()) {
      case 'discount broker':
        return 'Discount Broker';
      case 'full service broker':
        return 'Full Service';
      case 'bank-based':
        return 'Bank Based';
      default:
        return type;
    }
  }

  String get formattedRating => rating.toStringAsFixed(1);

  // Convenience getters for brokerage charges
  BrokerageCharges get brokerageCharges {
    return BrokerageCharges(
      equity: brokerage.equityDelivery,
      commodity: brokerage.commodityFutures,
      currency: brokerage.currencyFutures,
      accountOpening: accountOpening,
      accountMaintenance: '₹$accountMaintenance/year',
    );
  }

  // Convenience getters for contact info
  ContactInfo get contactInfo {
    return ContactInfo(
      phone: 'Contact via website',
      email: 'Contact via website',
      customerCare: 'Contact via website',
      address: 'Contact via website',
    );
  }

  String get establishedYear => '2010'; // Default value
  String get headquarters => 'India'; // Default value
  bool get isActive => true;
  String get website => 'https://${name.toLowerCase().replaceAll(' ', '')}.com';
  List<String> get tradingPlatforms => platforms;
  AccountTypes get accountTypes => AccountTypes(
      regular: true, premium: true, pro: false, minimumBalance: '₹0');
}

class BrokerageCharges {
  final String equity;
  final String commodity;
  final String currency;
  final String accountOpening;
  final String accountMaintenance;

  BrokerageCharges({
    required this.equity,
    required this.commodity,
    required this.currency,
    required this.accountOpening,
    required this.accountMaintenance,
  });

  factory BrokerageCharges.fromJson(Map<String, dynamic> json) {
    return BrokerageCharges(
      equity: json['equity'] ?? '',
      commodity: json['commodity'] ?? '',
      currency: json['currency'] ?? '',
      accountOpening: json['accountOpening'] ?? '',
      accountMaintenance: json['accountMaintenance'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'equity': equity,
      'commodity': commodity,
      'currency': currency,
      'accountOpening': accountOpening,
      'accountMaintenance': accountMaintenance,
    };
  }
}

class ContactInfo {
  final String phone;
  final String email;
  final String address;
  final String customerCare;

  ContactInfo({
    required this.phone,
    required this.email,
    required this.address,
    required this.customerCare,
  });

  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    return ContactInfo(
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      customerCare: json['customerCare'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'email': email,
      'address': address,
      'customerCare': customerCare,
    };
  }
}

class AccountTypes {
  final bool regular;
  final bool premium;
  final bool pro;
  final String minimumBalance;

  AccountTypes({
    required this.regular,
    required this.premium,
    required this.pro,
    required this.minimumBalance,
  });

  factory AccountTypes.fromJson(Map<String, dynamic> json) {
    return AccountTypes(
      regular: json['regular'] ?? false,
      premium: json['premium'] ?? false,
      pro: json['pro'] ?? false,
      minimumBalance: json['minimumBalance'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'regular': regular,
      'premium': premium,
      'pro': pro,
      'minimumBalance': minimumBalance,
    };
  }
}
