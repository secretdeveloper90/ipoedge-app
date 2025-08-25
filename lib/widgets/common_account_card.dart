import 'package:flutter/material.dart';
import '../models/demat_account.dart';
import '../theme/app_theme.dart';

class CommonAccountCard extends StatelessWidget {
  final DematAccount account;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isCompact;

  const CommonAccountCard({
    super.key,
    required this.account,
    this.onEdit,
    this.onDelete,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.cardBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: isCompact ? _buildCompactCard(context) : _buildFullCard(context),
      ),
    );
  }

  Widget _buildCompactCard(BuildContext context) {
    return Row(
      children: [
        // Account Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                account.applicantName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: account.dpType == DPType.cdsl
                      ? AppColors.success.withOpacity(0.1)
                      : AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  account.dpType.displayName,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: account.dpType == DPType.cdsl
                        ? AppColors.success
                        : AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Action Buttons
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => _showAccountDetails(context),
              icon: Icon(
                Icons.visibility_outlined,
                color: AppColors.secondary,
                size: 20,
              ),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.secondary.withOpacity(0.1),
                padding: const EdgeInsets.all(8),
              ),
            ),
            if (onEdit != null) ...[
              const SizedBox(width: 8),
              IconButton(
                onPressed: onEdit,
                icon: Icon(
                  Icons.edit_outlined,
                  color: AppColors.warning,
                  size: 20,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.warning.withOpacity(0.1),
                  padding: const EdgeInsets.all(8),
                ),
              ),
            ],
            if (onDelete != null) ...[
              const SizedBox(width: 8),
              IconButton(
                onPressed: onDelete,
                icon: Icon(
                  Icons.delete_outline,
                  color: AppColors.error,
                  size: 20,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.error.withOpacity(0.1),
                  padding: const EdgeInsets.all(8),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildFullCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAccountHeader(),
        const SizedBox(height: 12),
        _buildAccountDetails(),
        const SizedBox(height: 12),
        _buildAccountActions(context),
      ],
    );
  }

  Widget _buildAccountHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                account.applicantName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                account.panNumber,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: account.dpType == DPType.cdsl
                ? AppColors.success.withOpacity(0.1)
                : AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            account.dpType.displayName,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: account.dpType == DPType.cdsl
                  ? AppColors.success
                  : AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAccountDetails() {
    if (account.dpType == DPType.cdsl) {
      return Column(
        children: [
          _buildDetailRow('Demat ID', account.dematId ?? 'N/A'),
          const SizedBox(height: 8),
          _buildDetailRow('UPI ID', account.upiId ?? 'N/A'),
        ],
      );
    } else {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildDetailRow('DP ID', account.dpId ?? 'N/A')),
              const SizedBox(width: 16),
              Expanded(
                  child:
                      _buildDetailRow('Client ID', account.clientId ?? 'N/A')),
            ],
          ),
          const SizedBox(height: 8),
          _buildDetailRow('UPI ID', account.upiId ?? 'N/A'),
        ],
      );
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildAccountActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _showAccountDetails(context),
            icon: const Icon(Icons.visibility_outlined),
            label: const Text('View'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.secondary,
              side: BorderSide(color: AppColors.secondary),
              padding: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        if (onEdit != null) ...[
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Edit'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.warning,
                side: BorderSide(color: AppColors.warning),
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
        if (onDelete != null) ...[
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
              label: const Text('Delete'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: BorderSide(color: AppColors.error),
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _showAccountDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.account_balance_rounded,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Account Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildModalDetailRow('Applicant Name', account.applicantName),
                const SizedBox(height: 12),
                _buildModalDetailRow('PAN Number', account.panNumber),
                const SizedBox(height: 12),
                _buildModalDetailRow('DP Type', account.dpType.displayName),
                const SizedBox(height: 12),
                if (account.dpType == DPType.cdsl) ...[
                  _buildModalDetailRow('Demat ID', account.dematId ?? 'N/A'),
                ] else ...[
                  _buildModalDetailRow('DP ID', account.dpId ?? 'N/A'),
                  const SizedBox(height: 12),
                  _buildModalDetailRow('Client ID', account.clientId ?? 'N/A'),
                ],
                const SizedBox(height: 12),
                _buildModalDetailRow('UPI ID', account.upiId ?? 'N/A'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
              child: const Text(
                'Close',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildModalDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.cardBorder.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
