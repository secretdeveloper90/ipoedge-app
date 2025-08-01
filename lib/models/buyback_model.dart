class Buyback {
  final String id;
  final String companyName;
  final String logo;
  final String? recordDate;
  final String? issueDate;
  final String? closeDate;
  final double buybackPrice;
  final String issueSize;
  final int sharesCount;
  final double percentage;
  final String status;
  final String method;

  Buyback({
    required this.id,
    required this.companyName,
    required this.logo,
    this.recordDate,
    this.issueDate,
    this.closeDate,
    required this.buybackPrice,
    required this.issueSize,
    required this.sharesCount,
    required this.percentage,
    required this.status,
    required this.method,
  });

  factory Buyback.fromJson(Map<String, dynamic> json) {
    return Buyback(
      id: json['id'] ?? '',
      companyName: json['companyName'] ?? '',
      logo: json['logo'] ?? '',
      recordDate: json['recordDate'],
      issueDate: json['issueDate'],
      closeDate: json['closeDate'],
      buybackPrice: (json['buybackPrice'] ?? 0.0).toDouble(),
      issueSize: json['issueSize'] ?? '',
      sharesCount: json['sharesCount'] ?? 0,
      percentage: (json['percentage'] ?? 0.0).toDouble(),
      status: json['status'] ?? '',
      method: json['method'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyName': companyName,
      'logo': logo,
      'recordDate': recordDate,
      'issueDate': issueDate,
      'closeDate': closeDate,
      'buybackPrice': buybackPrice,
      'issueSize': issueSize,
      'sharesCount': sharesCount,
      'percentage': percentage,
      'status': status,
      'method': method,
    };
  }

  // Helper getters
  String get statusDisplayName {
    switch (status.toLowerCase()) {
      case 'upcoming':
        return 'Upcoming';
      case 'open':
        return 'Open';
      case 'closed':
        return 'Closed';
      default:
        return status;
    }
  }

  String get methodDisplayName {
    switch (method.toLowerCase()) {
      case 'tender':
        return 'Tender Offer';
      case 'open_market':
        return 'Open Market';
      default:
        return method;
    }
  }

  String get formattedBuybackPrice {
    return '₹${buybackPrice.toStringAsFixed(2)}';
  }

  String get formattedSharesCount {
    if (sharesCount >= 10000000) {
      return '${(sharesCount / 10000000).toStringAsFixed(2)}Cr';
    } else if (sharesCount >= 100000) {
      return '${(sharesCount / 100000).toStringAsFixed(2)}L';
    } else if (sharesCount >= 1000) {
      return '${(sharesCount / 1000).toStringAsFixed(2)}K';
    }
    return sharesCount.toString();
  }

  String get formattedPercentage {
    return '${percentage.toStringAsFixed(2)}%';
  }

  bool get isUpcoming => status.toLowerCase() == 'upcoming';
  bool get isOpen => status.toLowerCase() == 'open';
  bool get isClosed => status.toLowerCase() == 'closed';
}
