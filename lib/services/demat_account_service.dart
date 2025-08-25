import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/demat_account.dart';

class DematAccountService {
  static DematAccountService? _instance;

  // Firebase instances
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Singleton pattern
  static DematAccountService get instance {
    _instance ??= DematAccountService._internal();
    return _instance!;
  }

  DematAccountService._internal();

  // In-memory cache for better performance
  List<DematAccount>? _cachedAccounts;

  // Get current user ID
  String? get _currentUserId => _auth.currentUser?.uid;

  // Get user's accounts collection reference
  CollectionReference? get _userAccountsCollection {
    final userId = _currentUserId;
    if (userId == null) return null;
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('demat_accounts');
  }

  // Get all demat accounts
  Future<List<DematAccount>> getAllAccounts() async {
    try {
      // If user is authenticated, get from Firebase
      if (_currentUserId != null && _userAccountsCollection != null) {
        final querySnapshot = await _userAccountsCollection!
            .orderBy('createdAt', descending: false)
            .get();

        final accounts = querySnapshot.docs
            .map((doc) => DematAccount.fromFirestore(doc))
            .toList();

        // Update cache
        _cachedAccounts = accounts;
        return accounts;
      } else {
        // Return empty list for unauthenticated users - only show Firebase data
        return [];
      }
    } catch (e) {
      // If Firebase fails, return empty list - only show Firebase data
      return [];
    }
  }

  // Add a new demat account
  Future<bool> addAccount(DematAccount account) async {
    try {
      // Only allow adding accounts for authenticated users with Firebase
      if (_currentUserId != null && _userAccountsCollection != null) {
        // Check for existing accounts with same PAN or identifiers
        final existingAccounts = await getAllAccounts();
        final hasConflict = existingAccounts.any((acc) =>
            acc.panNumber == account.panNumber ||
            (account.dpType == DPType.cdsl &&
                acc.dematId == account.dematId &&
                account.dematId != null) ||
            (account.dpType == DPType.nsdl &&
                acc.dpId == account.dpId &&
                acc.clientId == account.clientId &&
                account.dpId != null &&
                account.clientId != null));

        if (hasConflict) {
          return false; // Account already exists
        }

        // Add to Firebase
        await _userAccountsCollection!
            .doc(account.id)
            .set(account.toFirestore());

        // Clear cache to force refresh
        _cachedAccounts = null;
        return true;
      } else {
        // Return false for unauthenticated users - only Firebase data allowed
        return false;
      }
    } catch (e) {
      // If Firebase fails, return false - only Firebase data allowed
      return false;
    }
  }

  // Update an existing demat account
  Future<bool> updateAccount(DematAccount updatedAccount) async {
    try {
      // Only allow updating accounts for authenticated users with Firebase
      if (_currentUserId != null && _userAccountsCollection != null) {
        // Check for conflicts with other accounts
        final existingAccounts = await getAllAccounts();
        final hasConflict = existingAccounts.any((acc) =>
            acc.id != updatedAccount.id &&
            (acc.panNumber == updatedAccount.panNumber ||
                (updatedAccount.dpType == DPType.cdsl &&
                    acc.dematId == updatedAccount.dematId &&
                    updatedAccount.dematId != null) ||
                (updatedAccount.dpType == DPType.nsdl &&
                    acc.dpId == updatedAccount.dpId &&
                    acc.clientId == updatedAccount.clientId &&
                    updatedAccount.dpId != null &&
                    updatedAccount.clientId != null)));

        if (hasConflict) {
          return false; // Conflict with existing account
        }

        // Update in Firebase
        final accountWithUpdatedTime =
            updatedAccount.copyWith(updatedAt: DateTime.now());
        await _userAccountsCollection!
            .doc(updatedAccount.id)
            .set(accountWithUpdatedTime.toFirestore());

        // Clear cache to force refresh
        _cachedAccounts = null;
        return true;
      } else {
        // Return false for unauthenticated users - only Firebase data allowed
        return false;
      }
    } catch (e) {
      // If Firebase fails, return false - only Firebase data allowed
      return false;
    }
  }

  // Delete a demat account
  Future<bool> deleteAccount(String accountId) async {
    try {
      // Only allow deleting accounts for authenticated users with Firebase
      if (_currentUserId != null && _userAccountsCollection != null) {
        await _userAccountsCollection!.doc(accountId).delete();

        // Clear cache to force refresh
        _cachedAccounts = null;
        return true;
      } else {
        // Return false for unauthenticated users - only Firebase data allowed
        return false;
      }
    } catch (e) {
      // If Firebase fails, return false - only Firebase data allowed
      return false;
    }
  }

  // Get account by ID
  Future<DematAccount?> getAccountById(String accountId) async {
    try {
      final accounts = await getAllAccounts();
      return accounts.firstWhere(
        (acc) => acc.id == accountId,
        orElse: () => DematAccount(
          id: '',
          applicantName: '',
          panNumber: '',
          dpType: DPType.cdsl,
          clientId: '',
          upiId: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
    } catch (e) {
      return null;
    }
  }

  // Check if PAN number already exists
  Future<bool> isPANExists(String panNumber, {String? excludeAccountId}) async {
    try {
      final accounts = await getAllAccounts();
      return accounts.any((acc) =>
          acc.panNumber == panNumber &&
          (excludeAccountId == null || acc.id != excludeAccountId));
    } catch (e) {
      return false;
    }
  }

  // Check if Demat ID already exists (for CDSL)
  Future<bool> isDematIdExists(String dematId,
      {String? excludeAccountId}) async {
    try {
      final accounts = await getAllAccounts();
      return accounts.any((acc) =>
          acc.dematId == dematId &&
          (excludeAccountId == null || acc.id != excludeAccountId));
    } catch (e) {
      return false;
    }
  }

  // Check if DP ID + Client ID combination already exists (for NSDL)
  Future<bool> isDpClientComboExists(String dpId, String clientId,
      {String? excludeAccountId}) async {
    try {
      final accounts = await getAllAccounts();
      return accounts.any((acc) =>
          acc.dpId == dpId &&
          acc.clientId == clientId &&
          (excludeAccountId == null || acc.id != excludeAccountId));
    } catch (e) {
      return false;
    }
  }

  // Check if Client ID already exists (legacy method for backward compatibility)
  Future<bool> isClientIdExists(String clientId,
      {String? excludeAccountId}) async {
    try {
      final accounts = await getAllAccounts();
      return accounts.any((acc) =>
          acc.clientId == clientId &&
          (excludeAccountId == null || acc.id != excludeAccountId));
    } catch (e) {
      return false;
    }
  }

  // Clear all accounts (for testing or reset)
  Future<void> clearAllAccounts() async {
    try {
      // Only clear Firebase accounts for authenticated users
      if (_currentUserId != null && _userAccountsCollection != null) {
        final querySnapshot = await _userAccountsCollection!.get();
        for (final doc in querySnapshot.docs) {
          await doc.reference.delete();
        }
        _cachedAccounts = [];
      }
    } catch (e) {
      // Handle error silently
    }
  }

  // Generate unique ID for new accounts
  String generateAccountId() {
    return 'acc_${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().microsecond}';
  }

  // Add demo data for testing (call this once to populate sample accounts)
  // This method is now deprecated and should not be called automatically
  @deprecated
  Future<void> addDemoData() async {
    // This method no longer adds demo data automatically
    // Only Firebase data should be displayed
    return;
  }

  // Force refresh demo data (for testing/debugging)
  // This method is now deprecated and should not be used
  @deprecated
  Future<void> forceRefreshDemoData() async {
    // This method no longer adds demo data
    // Only Firebase data should be displayed
    return;
  }
}
