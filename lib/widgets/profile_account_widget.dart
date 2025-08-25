import 'package:flutter/material.dart';
import '../models/demat_account.dart';
import '../services/demat_account_service.dart';
import '../theme/app_theme.dart';
import '../screens/add_edit_account_screen.dart';
import '../screens/account_list_screen.dart';
import 'common_account_card.dart';

class ProfileAccountWidget extends StatefulWidget {
  const ProfileAccountWidget({super.key});

  @override
  State<ProfileAccountWidget> createState() => _ProfileAccountWidgetState();
}

class _ProfileAccountWidgetState extends State<ProfileAccountWidget> {
  List<DematAccount> _accounts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    // Load only Firebase data, no demo data
    _loadAccounts();
  }

  Future<void> _loadAccounts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final accounts = await DematAccountService.instance.getAllAccounts();
      setState(() {
        _accounts = accounts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        const SizedBox(height: 16),
        if (_isLoading)
          _buildLoadingState()
        else if (_accounts.isEmpty)
          _buildEmptyState()
        else
          _buildAccountsList(),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          Icons.account_balance_rounded,
          color: AppColors.primary,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          _accounts.isNotEmpty
              ? 'Demat Accounts (${_accounts.length})'
              : 'Demat Accounts',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const Spacer(),
        if (_accounts.isNotEmpty)
          Container(
            height: 28,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primary.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _navigateToAddAccount,
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.add_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Add Account',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.cardBorder,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.account_balance_outlined,
                size: 48,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 16),
              Text(
                'No Accounts Added',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Add your first demat account to get started',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _navigateToAddAccount,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add Account'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAccountsList() {
    // Show only first 2 accounts in profile
    final displayAccounts = _accounts.take(2).toList();
    final hasMoreAccounts = _accounts.length > 2;

    return Column(
      children: [
        ...displayAccounts.map((account) => CommonAccountCard(
              account: account,
              isCompact: true,
              onEdit: () => _navigateToEditAccount(account),
              onDelete: () => _deleteAccount(account),
            )),
        const SizedBox(height: 12),
        if (hasMoreAccounts) ...[
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _navigateToAccountList,
              icon: const Icon(Icons.visibility_rounded),
              label: Text('View All (${_accounts.length})'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.secondary,
                side: BorderSide(color: AppColors.secondary),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ] else ...[
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _navigateToAddAccount,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add Account'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _navigateToAddAccount() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEditAccountScreen(),
      ),
    );

    if (result == true) {
      _loadAccounts();
    }
  }

  Future<void> _navigateToAccountList() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AccountListScreen(),
      ),
    );

    // Refresh accounts when returning from account list
    _loadAccounts();
  }

  Future<void> _navigateToEditAccount(DematAccount account) async {
    final confirmed = await _showEditConfirmationDialog(account);

    if (confirmed == true && mounted) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddEditAccountScreen(account: account),
        ),
      );

      if (result == true) {
        _loadAccounts();
      }
    }
  }

  Future<bool?> _showEditConfirmationDialog(DematAccount account) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Are you sure',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'You want to edit this account?',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Please make sure to cancel any order/bid associated with this account. Once Edited, order associated with this account cannot be cancelled.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.error,
                  height: 1.4,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'No',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                'Yes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.error,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount(DematAccount account) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: Text(
              'Are you sure you want to delete ${account.applicantName}\'s account?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.error,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        await DematAccountService.instance.deleteAccount(account.id);
        _loadAccounts();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account deleted successfully'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete account: $e'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }
}
