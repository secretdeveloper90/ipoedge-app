enum OrderStatus {
  applied,
  allotted,
  notAllotted,
  refunded,
  cancelled,
}

enum OrderType {
  retail,
  hni,
  institutional,
}

extension OrderStatusExtension on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.applied:
        return 'Applied';
      case OrderStatus.allotted:
        return 'Allotted';
      case OrderStatus.notAllotted:
        return 'Not Allotted';
      case OrderStatus.refunded:
        return 'Refunded';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get description {
    switch (this) {
      case OrderStatus.applied:
        return 'Application submitted successfully';
      case OrderStatus.allotted:
        return 'Shares have been allotted';
      case OrderStatus.notAllotted:
        return 'No shares allotted';
      case OrderStatus.refunded:
        return 'Amount refunded to account';
      case OrderStatus.cancelled:
        return 'Application cancelled';
    }
  }
}

extension OrderTypeExtension on OrderType {
  String get displayName {
    switch (this) {
      case OrderType.retail:
        return 'Retail';
      case OrderType.hni:
        return 'HNI';
      case OrderType.institutional:
        return 'Institutional';
    }
  }
}

class IpoOrder {
  final String id;
  final String ipoName;
  final String companyName;
  final OrderStatus status;
  final OrderType orderType;
  final int appliedQuantity;
  final int? allottedQuantity;
  final double pricePerShare;
  final double totalAmount;
  final double? refundAmount;
  final DateTime applicationDate;
  final DateTime? allotmentDate;
  final String? allotmentNumber;
  final String dematAccountId;
  final String applicantName;

  IpoOrder({
    required this.id,
    required this.ipoName,
    required this.companyName,
    required this.status,
    required this.orderType,
    required this.appliedQuantity,
    this.allottedQuantity,
    required this.pricePerShare,
    required this.totalAmount,
    this.refundAmount,
    required this.applicationDate,
    this.allotmentDate,
    this.allotmentNumber,
    required this.dematAccountId,
    required this.applicantName,
  });

  bool get isCurrent {
    return status == OrderStatus.applied;
  }

  bool get isPast {
    return status != OrderStatus.applied;
  }

  String get formattedApplicationDate {
    return '${applicationDate.day}/${applicationDate.month}/${applicationDate.year}';
  }

  String get formattedAllotmentDate {
    if (allotmentDate == null) return 'N/A';
    return '${allotmentDate!.day}/${allotmentDate!.month}/${allotmentDate!.year}';
  }

  factory IpoOrder.fromJson(Map<String, dynamic> json) {
    return IpoOrder(
      id: json['id'],
      ipoName: json['ipoName'],
      companyName: json['companyName'],
      status: OrderStatus.values[json['status']],
      orderType: OrderType.values[json['orderType']],
      appliedQuantity: json['appliedQuantity'],
      allottedQuantity: json['allottedQuantity'],
      pricePerShare: json['pricePerShare'].toDouble(),
      totalAmount: json['totalAmount'].toDouble(),
      refundAmount: json['refundAmount']?.toDouble(),
      applicationDate: DateTime.parse(json['applicationDate']),
      allotmentDate: json['allotmentDate'] != null 
          ? DateTime.parse(json['allotmentDate']) 
          : null,
      allotmentNumber: json['allotmentNumber'],
      dematAccountId: json['dematAccountId'],
      applicantName: json['applicantName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ipoName': ipoName,
      'companyName': companyName,
      'status': status.index,
      'orderType': orderType.index,
      'appliedQuantity': appliedQuantity,
      'allottedQuantity': allottedQuantity,
      'pricePerShare': pricePerShare,
      'totalAmount': totalAmount,
      'refundAmount': refundAmount,
      'applicationDate': applicationDate.toIso8601String(),
      'allotmentDate': allotmentDate?.toIso8601String(),
      'allotmentNumber': allotmentNumber,
      'dematAccountId': dematAccountId,
      'applicantName': applicantName,
    };
  }
}
