import 'package:cloud_firestore/cloud_firestore.dart';

class DematAccount {
  final String id;
  final String applicantName;
  final String panNumber;
  final DPType dpType;
  // For CDSL: 16-digit Demat ID
  final String? dematId;
  // For NSDL: 8-digit DP ID + 8-digit Client ID
  final String? dpId;
  final String? clientId;
  final String upiId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DematAccount({
    required this.id,
    required this.applicantName,
    required this.panNumber,
    required this.dpType,
    this.dematId,
    this.dpId,
    this.clientId,
    required this.upiId,
    required this.createdAt,
    required this.updatedAt,
  });

  // Create a copy with updated fields
  DematAccount copyWith({
    String? id,
    String? applicantName,
    String? panNumber,
    DPType? dpType,
    String? dematId,
    String? dpId,
    String? clientId,
    String? upiId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DematAccount(
      id: id ?? this.id,
      applicantName: applicantName ?? this.applicantName,
      panNumber: panNumber ?? this.panNumber,
      dpType: dpType ?? this.dpType,
      dematId: dematId ?? this.dematId,
      dpId: dpId ?? this.dpId,
      clientId: clientId ?? this.clientId,
      upiId: upiId ?? this.upiId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'applicantName': applicantName,
      'panNumber': panNumber,
      'dpType': dpType.name,
      'dematId': dematId,
      'dpId': dpId,
      'clientId': clientId,
      'upiId': upiId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create from JSON
  factory DematAccount.fromJson(Map<String, dynamic> json) {
    return DematAccount(
      id: json['id'] ?? '',
      applicantName: json['applicantName'] ?? '',
      panNumber: json['panNumber'] ?? '',
      dpType: DPType.values.firstWhere(
        (type) => type.name == json['dpType'],
        orElse: () => DPType.cdsl,
      ),
      dematId: json['dematId'],
      dpId: json['dpId'],
      clientId: json['clientId'],
      upiId: json['upiId'] ?? '',
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  // Create from Firestore document
  factory DematAccount.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DematAccount(
      id: doc.id,
      applicantName: data['applicantName'] ?? '',
      panNumber: data['panNumber'] ?? '',
      dpType: DPType.values.firstWhere(
        (type) => type.name == data['dpType'],
        orElse: () => DPType.cdsl,
      ),
      dematId: data['dematId'],
      dpId: data['dpId'],
      clientId: data['clientId'],
      upiId: data['upiId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Convert to Firestore document data
  Map<String, dynamic> toFirestore() {
    return {
      'applicantName': applicantName,
      'panNumber': panNumber,
      'dpType': dpType.name,
      'dematId': dematId,
      'dpId': dpId,
      'clientId': clientId,
      'upiId': upiId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Validation methods
  bool get isValid {
    final baseValid = applicantName.isNotEmpty &&
        panNumber.isNotEmpty &&
        upiId.isNotEmpty &&
        isValidPAN(panNumber) &&
        isValidUPI(upiId);

    if (dpType == DPType.cdsl) {
      return baseValid &&
          dematId != null &&
          dematId!.isNotEmpty &&
          isValidDematId(dematId!);
    } else {
      return baseValid &&
          dpId != null &&
          dpId!.isNotEmpty &&
          clientId != null &&
          clientId!.isNotEmpty &&
          isValidDpId(dpId!) &&
          isValidClientId(clientId!);
    }
  }

  static bool isValidPAN(String pan) {
    // PAN format: 5 letters, 4 digits, 1 letter (e.g., ABCDE1234F)
    final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
    return panRegex.hasMatch(pan.toUpperCase());
  }

  static bool isValidUPI(String upi) {
    // Enhanced UPI validation following NPCI guidelines
    if (upi.isEmpty) return false;

    // Trim whitespace and convert to lowercase for validation
    upi = upi.trim().toLowerCase();

    // Basic format validation: username@provider
    // UPI ID can contain letters, numbers, dots, hyphens, underscores
    // Username: 3-50 characters, Provider: 3-50 characters
    final upiRegex = RegExp(r'^[a-zA-Z0-9.\-_]{3,50}@[a-zA-Z0-9.\-_]{3,50}$',
        caseSensitive: false);
    if (!upiRegex.hasMatch(upi)) return false;

    // Split to get provider
    final parts = upi.split('@');
    if (parts.length != 2) return false;

    final username = parts[0];
    final provider = parts[1];

    // Username validation
    if (username.length < 3 || username.length > 50) return false;

    // Username cannot start or end with special characters
    if (username.startsWith('.') ||
        username.startsWith('-') ||
        username.startsWith('_') ||
        username.endsWith('.') ||
        username.endsWith('-') ||
        username.endsWith('_')) {
      return false;
    }

    // Special case: Phone number based UPI (10 digits)
    final phoneRegex = RegExp(r'^[6-9][0-9]{9}$');
    if (phoneRegex.hasMatch(username)) {
      // For phone number UPIs, we're more lenient with providers
      return _isValidUPIProvider(provider);
    }

    // Regular UPI validation
    return _isValidUPIProvider(provider);
  }

  // Helper method to validate UPI providers
  static bool _isValidUPIProvider(String provider) {
    // Provider validation - comprehensive list of UPI handles
    final validProviders = {
      // Payment Apps
      'paytm', 'gpay', 'phonepe', 'amazonpay', 'mobikwik', 'freecharge',
      'bharatpe', 'cred', 'slice', 'jupiter', 'navi', 'groww', 'zerodha',

      // Telecom
      'airtel', 'jio', 'vodafone', 'bsnl', 'mtnl',

      // Major Banks - Standard handles
      'sbi', 'icici', 'hdfc', 'axis', 'kotak', 'pnb', 'bob', 'canara',
      'union', 'indian', 'central', 'syndicate', 'allahabad', 'vijaya',
      'dena', 'corporation', 'oriental', 'uco', 'idbi',

      // Major Banks - OK handles (common format)
      'oksbi', 'okicici', 'okhdfcbank', 'okaxis', 'okkotak', 'okpnb',
      'okbob', 'okcanara', 'okunion', 'okindian', 'okcentral',

      // Private Banks
      'federal', 'rbl', 'yes', 'indusind', 'bandhan', 'equitas',
      'fino', 'jana', 'ujjivan', 'esaf', 'suryoday', 'idfc', 'dcb',
      'karur', 'lakshmi', 'nainital', 'city', 'dhanlaxmi', 'catholic',
      'saraswat', 'cosmos', 'capital', 'bassein', 'kalyan', 'janata',

      // Regional Banks and States
      'mehsana', 'rajkot', 'surat', 'ahmedabad', 'baroda', 'punjab',
      'kashmir', 'himachal', 'uttarakhand', 'haryana', 'rajasthan',
      'gujarat', 'maharashtra', 'goa', 'karnataka', 'kerala', 'tamilnadu',
      'andhra', 'telangana', 'odisha', 'westbengal', 'jharkhand',
      'bihar', 'uttar', 'madhya', 'chhattisgarh', 'assam', 'manipur',
      'meghalaya', 'mizoram', 'nagaland', 'sikkim', 'tripura', 'arunachal',

      // Co-operative Banks (unique entries only)
      'apgb', 'kgb', 'mgb', 'tgb', 'wgb', 'jkgb', 'hpgb', 'ugb',
      'hgb', 'rgb', 'ggb', 'gogb', 'tngb', 'tsgb', 'ogb', 'wbgb',
      'jgb', 'bgb', 'upgb', 'mpgb', 'cgb', 'agb', 'ngb', 'sgb',

      // Payment Banks
      'airtelbank', 'paytmbank', 'jiobank', 'indiapost',

      // Small Finance Banks
      'northeast', 'fincare', 'utkarsh',

      // Common variations and abbreviations
      'upi', 'bhim', 'npci', 'ippb', 'psb', 'ybl', 'ibl', 'axl',
      'hdfcbank', 'icicibank', 'sbibank', 'kotakbank', 'pnbbank',
      'bobbank', 'canarabank', 'unionbank', 'indianbank',

      // Additional common handles
      'bajaj', 'mahindra', 'tata', 'lic'
    };

    return validProviders.contains(provider);
  }

  static bool isValidDematId(String dematId) {
    // CDSL Demat ID: 16 digits
    final dematRegex = RegExp(r'^[0-9]{16}$');
    return dematRegex.hasMatch(dematId);
  }

  static bool isValidDpId(String dpId) {
    // NSDL DP ID: 8 digits
    final dpRegex = RegExp(r'^[0-9]{8}$');
    return dpRegex.hasMatch(dpId);
  }

  static bool isValidClientId(String clientId) {
    // NSDL Client ID: 8 digits
    final clientRegex = RegExp(r'^[0-9]{8}$');
    return clientRegex.hasMatch(clientId);
  }

  @override
  String toString() {
    if (dpType == DPType.cdsl) {
      return 'DematAccount(id: $id, applicantName: $applicantName, panNumber: $panNumber, dpType: $dpType, dematId: $dematId, upiId: $upiId)';
    } else {
      return 'DematAccount(id: $id, applicantName: $applicantName, panNumber: $panNumber, dpType: $dpType, dpId: $dpId, clientId: $clientId, upiId: $upiId)';
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DematAccount && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

enum DPType {
  cdsl('CDSL'),
  nsdl('NSDL');

  const DPType(this.displayName);
  final String displayName;
}
