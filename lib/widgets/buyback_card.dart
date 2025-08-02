import 'package:flutter/material.dart';
import '../models/buyback_model.dart';
import '../screens/buyback_detail_screen.dart';
import '../theme/app_theme.dart';

class BuybackCard extends StatelessWidget {
  final Buyback buyback;

  const BuybackCard({
    Key? key,
    required this.buyback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: -2,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.08),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BuybackDetailScreen(buyback: buyback),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          splashColor: Colors.blue.withOpacity(0.04),
          highlightColor: Colors.blue.withOpacity(0.02),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCompactHeader(),
                const SizedBox(height: 12),
                Divider(
                  color: Colors.grey.withOpacity(0.12),
                  thickness: 0.8,
                  height: 1,
                ),
                const SizedBox(height: 12),
                _buildDateSection(),
                const SizedBox(height: 12),
                Divider(
                  color: Colors.grey.withOpacity(0.12),
                  thickness: 0.8,
                  height: 1,
                ),
                const SizedBox(height: 12),
                _buildIssueSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Enhanced Company logo with better styling and Hero animation
        Hero(
          tag: 'buyback-logo-${buyback.id}',
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: _getLogoBackgroundColor(),
              boxShadow: [
                BoxShadow(
                  color: _getLogoBackgroundColor().withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                buyback.logo,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/ipo-edge-logo.jpeg',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          color: _getLogoBackgroundColor(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.business_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Company name and buyback info beside the image
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${buyback.companyName} Buyback 2025',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                  height: 1.3,
                  letterSpacing: -0.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: Colors.green.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'Buyback Price: ${buyback.formattedBuybackPrice}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateSection() {
    return Row(
      children: [
        Expanded(
          child: _buildDateItem(
            'Record Date',
            _formatDisplayDate(buyback.recordDate ?? 'TBA'),
          ),
        ),
        _buildVerticalDivider(),
        Expanded(
          child: _buildDateItem(
            'Open Date',
            _formatDisplayDate(buyback.issueDate ?? 'TBA'),
          ),
        ),
        _buildVerticalDivider(),
        Expanded(
          child: _buildDateItem(
            'Close Date',
            _formatDisplayDate(buyback.closeDate ?? 'TBA'),
          ),
        ),
      ],
    );
  }

  Widget _buildDateItem(String label, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          date,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildIssueSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Issue Size (Shares)',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                  children: [
                    TextSpan(
                        text:
                            '${buyback.formattedSharesCount}( ${buyback.formattedPercentage} of\n'),
                    const TextSpan(text: 'Total number of equity\n'),
                    const TextSpan(text: 'Shares)'),
                  ],
                ),
              ),
            ],
          ),
        ),
        _buildVerticalDivider(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Issue Size (Amount)',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                buyback.issueSize,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(0.5),
      ),
    );
  }

  Color _getStatusColor() {
    switch (buyback.status.toLowerCase()) {
      case 'upcoming':
        return AppColors.info;
      case 'open':
        return AppColors.success;
      case 'closed':
        return AppColors.textSecondary;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _getStatusIcon() {
    switch (buyback.status.toLowerCase()) {
      case 'upcoming':
        return Icons.schedule_rounded;
      case 'open':
        return Icons.play_arrow_rounded;
      case 'closed':
        return Icons.check_circle_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  Color _getLogoBackgroundColor() {
    // Generate a color based on company name for consistency
    final colors = [
      const Color(0xFFE53E3E), // Red
      const Color(0xFF3182CE), // Blue
      const Color(0xFF38A169), // Green
      const Color(0xFFD69E2E), // Orange
      const Color(0xFF805AD5), // Purple
      const Color(0xFF319795), // Teal
    ];

    final index = buyback.companyName.hashCode.abs() % colors.length;
    return colors[index];
  }

  String _formatDisplayDate(String date) {
    if (date == 'TBA' || date.isEmpty) {
      return date;
    }

    try {
      final DateTime parsedDate = DateTime.parse(date);
      return '${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return date;
    }
  }
}
