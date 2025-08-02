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
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
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
                    padding: const EdgeInsets.all(12),
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
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
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
                                padding: const EdgeInsets.all(8),
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
                            const SizedBox(width: 14),
                            // Enhanced broker info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Broker name with better typography
                                  Text(
                                    broker.name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                      height: 1.2,
                                      letterSpacing: -0.5,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  // Service tags below broker name
                                  Wrap(
                                    spacing: 4,
                                    runSpacing: 4,
                                    children:
                                        broker.services.take(3).map((service) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              AppColors.primary
                                                  .withOpacity(0.1),
                                              AppColors.primary
                                                  .withOpacity(0.05),
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: AppColors.primary
                                                .withOpacity(0.2),
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          service,
                                          style: const TextStyle(
                                            fontSize: 8,
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
                            // Modern rating button
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color(0xFFFFD700), // Gold
                                    const Color(0xFFFFA500), // Orange
                                    const Color(0xFFFF8C00), // Dark orange
                                  ],
                                  stops: const [0.0, 0.5, 1.0],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFFD700)
                                        .withOpacity(0.4),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                    spreadRadius: 0,
                                  ),
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 0.5,
                                ),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    // Show rating details
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  splashColor: Colors.white.withOpacity(0.3),
                                  highlightColor:
                                      Colors.white.withOpacity(0.15),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.white.withOpacity(0.2),
                                          Colors.transparent,
                                        ],
                                        stops: const [0.0, 0.5],
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Star icon
                                        Icon(
                                          Icons.star_rounded,
                                          size: 12,
                                          color: Colors.white,
                                          shadows: const [
                                            Shadow(
                                              color: Colors.black26,
                                              offset: Offset(0, 1),
                                              blurRadius: 2,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 1),
                                        // Rating text
                                        Text(
                                          broker.formattedRating,
                                          style: const TextStyle(
                                            fontSize: 8,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white,
                                            shadows: [
                                              Shadow(
                                                color: Colors.black26,
                                                offset: Offset(0, 1),
                                                blurRadius: 2,
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
                          ],
                        ),
                        const SizedBox(height: 6),
                        // Key metrics with icons and dividers
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              // Top divider
                              Container(
                                height: 1,
                                color: Colors.grey.withOpacity(0.2),
                                margin: const EdgeInsets.only(bottom: 6),
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
                                    color: Colors.grey.withOpacity(0.2),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4),
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
                              const SizedBox(height: 6),
                              Container(
                                height: 1,
                                color: Colors.grey.withOpacity(0.2),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                              ),
                              const SizedBox(height: 6),
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
                                    color: Colors.grey.withOpacity(0.2),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4),
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
                                color: Colors.grey.withOpacity(0.2),
                                margin: const EdgeInsets.only(top: 6),
                              ),
                            ],
                          ),
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

  Widget _buildMetricItemWithIcon(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 12,
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
            fontSize: 11,
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
