import 'package:flutter/material.dart';
import '../models/broker.dart';
import '../theme/app_theme.dart';

class BrokerCard extends StatelessWidget {
  final Broker broker;
  final VoidCallback? onTap;

  const BrokerCard({
    super.key,
    required this.broker,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  const Color(0xFFFAFBFF),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.1),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.12),
                  blurRadius: 32,
                  offset: const Offset(0, 12),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  // Subtle background pattern
                  Positioned(
                    top: -50,
                    right: -50,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.primary.withOpacity(0.03),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Main content
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Modern header with enhanced layout
                        Row(
                          children: [
                            // Enhanced broker logo
                            Hero(
                              tag: 'broker-logo-${broker.id}',
                              child: Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white,
                                      Colors.grey[50]!,
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          AppColors.primary.withOpacity(0.15),
                                      blurRadius: 16,
                                      offset: const Offset(0, 6),
                                      spreadRadius: 0,
                                    ),
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                      spreadRadius: 0,
                                    ),
                                  ],
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                padding: const EdgeInsets.all(12),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    broker.logo,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.primary
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Icon(
                                          Icons.business_rounded,
                                          color: AppColors.primary,
                                          size: 28,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            // Enhanced broker info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Broker name with better typography
                                  Text(
                                    broker.name,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                      height: 1.2,
                                      letterSpacing: -0.5,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  // Compact rating display
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.amber[50],
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.amber[200]!,
                                        width: 0.5,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.star_rounded,
                                          size: 14,
                                          color: Colors.amber[600],
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          broker.formattedRating,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.amber[800],
                                          ),
                                        ),
                                        const SizedBox(width: 3),
                                        Text(
                                          '(${_formatReviewCount(broker.reviewCount)})',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.amber[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Key metrics with icons and dividers
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.cardBorder.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              // Top divider
                              Container(
                                height: 1,
                                color: Colors.grey.withOpacity(0.3),
                                margin: const EdgeInsets.only(bottom: 8),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildMetricItemWithIcon(
                                      'Account Opening',
                                      broker.accountOpening,
                                      Icons.account_balance_wallet,
                                      AppColors.primary,
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 35,
                                    color: Colors.grey.withOpacity(0.3),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                  ),
                                  Expanded(
                                    child: _buildMetricItemWithIcon(
                                      'AMC',
                                      broker.accountMaintenance,
                                      Icons.account_balance,
                                      AppColors.success,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 1,
                                color: Colors.grey.withOpacity(0.3),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 6),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildMetricItemWithIcon(
                                      'Equity Delivery',
                                      broker.brokerage.equityDelivery,
                                      Icons.trending_up,
                                      AppColors.info,
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 35,
                                    color: Colors.grey.withOpacity(0.3),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                  ),
                                  Expanded(
                                    child: _buildMetricItemWithIcon(
                                      'Equity Intraday',
                                      broker.brokerage.equityIntraday,
                                      Icons.flash_on,
                                      AppColors.warning,
                                    ),
                                  ),
                                ],
                              ),
                              // Bottom divider
                              Container(
                                height: 1,
                                color: Colors.grey.withOpacity(0.3),
                                margin: const EdgeInsets.only(top: 8),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Modern services tags
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: broker.services.take(4).map((service) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primary.withOpacity(0.1),
                                    AppColors.primary.withOpacity(0.05),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.primary.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                service,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatReviewCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  Widget _buildMetricItemWithIcon(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 14,
              color: color,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
