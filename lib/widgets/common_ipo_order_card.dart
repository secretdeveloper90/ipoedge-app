import 'package:flutter/material.dart';
import '../models/ipo_order.dart';
import '../theme/app_theme.dart';
import 'celebration_animation.dart';

class CommonIpoOrderCard extends StatelessWidget {
  final IpoOrder order;
  final bool isCompact;

  const CommonIpoOrderCard({
    super.key,
    required this.order,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final isAllotted = order.status == OrderStatus.allotted;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isAllotted ? Colors.green.withOpacity(0.3) : AppColors.cardBorder,
          width: isAllotted ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isAllotted
                ? Colors.green.withOpacity(0.2)
                : Colors.black.withOpacity(0.04),
            blurRadius: isAllotted ? 12 : 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CelebrationAnimation(
          isVisible: isAllotted,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: isCompact
                ? _buildCompactCard(context)
                : _buildFullCard(context),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactCard(BuildContext context) {
    return Row(
      children: [
        // IPO Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.ipoName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  _buildStatusBadge(),
                  const SizedBox(width: 8),
                  Text(
                    '₹${order.totalAmount.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Action Button
        IconButton(
          onPressed: () => _showOrderDetails(context),
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
      ],
    );
  }

  Widget _buildFullCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildOrderHeader(),
        const SizedBox(height: 12),
        _buildOrderDetails(),
        const SizedBox(height: 12),
        _buildOrderActions(context),
      ],
    );
  }

  Widget _buildOrderHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.ipoName,
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
                order.companyName,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        _buildStatusBadge(),
      ],
    );
  }

  Widget _buildStatusBadge() {
    Color backgroundColor;
    Color textColor;

    switch (order.status) {
      case OrderStatus.applied:
        backgroundColor = AppColors.warning.withOpacity(0.1);
        textColor = AppColors.warning;
        break;
      case OrderStatus.allotted:
        backgroundColor = AppColors.success.withOpacity(0.1);
        textColor = AppColors.success;
        break;
      case OrderStatus.notAllotted:
      case OrderStatus.refunded:
        backgroundColor = AppColors.error.withOpacity(0.1);
        textColor = AppColors.error;
        break;
      case OrderStatus.cancelled:
        backgroundColor = AppColors.textSecondary.withOpacity(0.1);
        textColor = AppColors.textSecondary;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (order.status == OrderStatus.allotted) ...[
            FirecrackerAnimation(
              isVisible: true,
              duration: const Duration(seconds: 2),
            ),
            const SizedBox(width: 4),
          ],
          Text(
            order.status.displayName,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderDetails() {
    return Column(
      children: [
        _buildDetailRow('Applied Quantity', '${order.appliedQuantity} shares'),
        const SizedBox(height: 8),
        _buildDetailRow(
            'Price per Share', '₹${order.pricePerShare.toStringAsFixed(0)}'),
        const SizedBox(height: 8),
        _buildDetailRow(
            'Total Amount', '₹${order.totalAmount.toStringAsFixed(0)}'),
        if (order.allottedQuantity != null) ...[
          const SizedBox(height: 8),
          _buildDetailRow(
              'Allotted Quantity', '${order.allottedQuantity} shares'),
        ],
        if (order.refundAmount != null) ...[
          const SizedBox(height: 8),
          _buildDetailRow(
              'Refund Amount', '₹${order.refundAmount!.toStringAsFixed(0)}'),
        ],
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderActions(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _showOrderDetails(context),
        icon: const Icon(Icons.visibility_outlined),
        label: const Text('View Details'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.secondary,
          side: BorderSide(color: AppColors.secondary),
          padding: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  void _showOrderDetails(BuildContext context) {
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
                Icons.receipt_long_rounded,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Order Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              if (order.status == OrderStatus.allotted) ...[
                const SizedBox(width: 8),
                FirecrackerAnimation(
                  isVisible: true,
                  duration: const Duration(seconds: 3),
                ),
              ],
            ],
          ),
          content: SingleChildScrollView(
            child: CelebrationAnimation(
              isVisible: order.status == OrderStatus.allotted,
              duration: const Duration(seconds: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildModalDetailRow('IPO Name', order.ipoName),
                  const SizedBox(height: 12),
                  _buildModalDetailRow('Company', order.companyName),
                  const SizedBox(height: 12),
                  _buildModalDetailRow('Status', order.status.displayName),
                  const SizedBox(height: 12),
                  _buildModalDetailRow(
                      'Order Type', order.orderType.displayName),
                  const SizedBox(height: 12),
                  _buildModalDetailRow(
                      'Applied Quantity', '${order.appliedQuantity} shares'),
                  const SizedBox(height: 12),
                  _buildModalDetailRow('Price per Share',
                      '₹${order.pricePerShare.toStringAsFixed(0)}'),
                  const SizedBox(height: 12),
                  _buildModalDetailRow('Total Amount',
                      '₹${order.totalAmount.toStringAsFixed(0)}'),
                  if (order.allottedQuantity != null) ...[
                    const SizedBox(height: 12),
                    _buildModalDetailRow('Allotted Quantity',
                        '${order.allottedQuantity} shares'),
                  ],
                  if (order.refundAmount != null) ...[
                    const SizedBox(height: 12),
                    _buildModalDetailRow('Refund Amount',
                        '₹${order.refundAmount!.toStringAsFixed(0)}'),
                  ],
                  const SizedBox(height: 12),
                  _buildModalDetailRow(
                      'Application Date', order.formattedApplicationDate),
                  if (order.allotmentDate != null) ...[
                    const SizedBox(height: 12),
                    _buildModalDetailRow(
                        'Allotment Date', order.formattedAllotmentDate),
                  ],
                  if (order.allotmentNumber != null) ...[
                    const SizedBox(height: 12),
                    _buildModalDetailRow(
                        'Allotment Number', order.allotmentNumber!),
                  ],
                  const SizedBox(height: 12),
                  _buildModalDetailRow('Applicant Name', order.applicantName),
                ],
              ),
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
