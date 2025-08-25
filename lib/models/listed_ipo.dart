class ListedIpo {
  final String id;
  final String ipoName;
  final String companyName;
  final DateTime listingDate;
  final String registrarName;
  final String registrarLink;
  final String logoUrl;
  final double listingPrice;
  final double issuePrice;
  final String status; // 'Listed', 'Allotment Finalized', etc.

  ListedIpo({
    required this.id,
    required this.ipoName,
    required this.companyName,
    required this.listingDate,
    required this.registrarName,
    required this.registrarLink,
    required this.logoUrl,
    required this.listingPrice,
    required this.issuePrice,
    required this.status,
  });

  String get formattedListingDate {
    return '${listingDate.day}/${listingDate.month}/${listingDate.year}';
  }

  double get listingGainPercent {
    if (issuePrice == 0) return 0;
    return ((listingPrice - issuePrice) / issuePrice) * 100;
  }

  bool get isGainer {
    return listingGainPercent > 0;
  }

  factory ListedIpo.fromJson(Map<String, dynamic> json) {
    return ListedIpo(
      id: json['id'],
      ipoName: json['ipoName'],
      companyName: json['companyName'],
      listingDate: DateTime.parse(json['listingDate']),
      registrarName: json['registrarName'],
      registrarLink: json['registrarLink'],
      logoUrl: json['logoUrl'],
      listingPrice: json['listingPrice'].toDouble(),
      issuePrice: json['issuePrice'].toDouble(),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ipoName': ipoName,
      'companyName': companyName,
      'listingDate': listingDate.toIso8601String(),
      'registrarName': registrarName,
      'registrarLink': registrarLink,
      'logoUrl': logoUrl,
      'listingPrice': listingPrice,
      'issuePrice': issuePrice,
      'status': status,
    };
  }
}
