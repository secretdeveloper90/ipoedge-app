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
    // Handle Firebase data structure with nested buybackHeaderInfo
    final buybackHeaderInfo =
        json['buybackHeaderInfo'] as Map<String, dynamic>?;
    final participation = json['participation'] as Map<String, dynamic>?;
    final steps = participation?['steps'] as List<dynamic>? ?? [];

    // Extract company name from buybackHeaderInfo
    String companyName = '';
    if (buybackHeaderInfo != null) {
      companyName = buybackHeaderInfo['name'] ?? '';
      // Remove "Buyback" suffix if present for cleaner display
      companyName = companyName.replaceAll(
          RegExp(r'\s+Buyback.*$', caseSensitive: false), '');
    }

    // Extract buyback price from string format "₹750.00"
    double buybackPrice = 0.0;
    if (buybackHeaderInfo != null) {
      final priceString = buybackHeaderInfo['buybackPrice'] ?? '';
      final priceMatch = RegExp(r'₹([\d,]+\.?\d*)').firstMatch(priceString);
      if (priceMatch != null) {
        buybackPrice =
            double.tryParse(priceMatch.group(1)?.replaceAll(',', '') ?? '0') ??
                0.0;
      }
    }

    // Extract dates from participation steps
    String? recordDate;
    String? issueDate;
    String? closeDate;

    for (final step in steps) {
      final stepText = step.toString();

      // Extract record date
      final recordDateMatch =
          RegExp(r'record date (\w+ \d+, \d+)').firstMatch(stepText);
      if (recordDateMatch != null && recordDate == null) {
        recordDate = _parseDate(recordDateMatch.group(1) ?? '');
      }

      // Extract issue/opening date
      final issueDateMatch =
          RegExp(r'opening from (\w+ \d+, \d+)').firstMatch(stepText);
      if (issueDateMatch != null && issueDate == null) {
        issueDate = _parseDate(issueDateMatch.group(1) ?? '');
      }

      // Extract close/payment date
      final closeDateMatch =
          RegExp(r'on (\w+ \d+, \d+), the payment').firstMatch(stepText);
      if (closeDateMatch != null && closeDate == null) {
        closeDate = _parseDate(closeDateMatch.group(1) ?? '');
      }
    }

    // Determine status based on dates
    String status = 'upcoming';
    final now = DateTime.now();
    if (issueDate != null) {
      final issueDateTime = DateTime.tryParse(issueDate);
      if (issueDateTime != null && issueDateTime.isBefore(now)) {
        status = 'open';
      }
    }
    if (closeDate != null) {
      final closeDateTime = DateTime.tryParse(closeDate);
      if (closeDateTime != null && closeDateTime.isBefore(now)) {
        status = 'closed';
      }
    }

    return Buyback(
      id: json['id'] ?? '',
      companyName: companyName,
      logo: buybackHeaderInfo?['logoUrl'] ?? '',
      recordDate: recordDate,
      issueDate: issueDate,
      closeDate: closeDate,
      buybackPrice: buybackPrice,
      issueSize:
          '₹${(buybackPrice * 1000000 / 1000000).toStringAsFixed(0)} Cr', // Estimated
      sharesCount: 1000000, // Default value
      percentage: 2.5, // Default value
      status: status,
      method: 'tender', // Default method
    );
  }

  // Helper method to parse date strings like "Aug 27, 2024" to ISO format
  static String? _parseDate(String dateStr) {
    try {
      final months = {
        'Jan': '01',
        'Feb': '02',
        'Mar': '03',
        'Apr': '04',
        'May': '05',
        'Jun': '06',
        'Jul': '07',
        'Aug': '08',
        'Sep': '09',
        'Oct': '10',
        'Nov': '11',
        'Dec': '12'
      };

      final parts = dateStr.split(' ');
      if (parts.length == 3) {
        final month = months[parts[0]];
        final day = parts[1].replaceAll(',', '').padLeft(2, '0');
        final year = parts[2];

        if (month != null) {
          return '$year-$month-$day';
        }
      }
    } catch (e) {
      // Return null if parsing fails
    }
    return null;
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
