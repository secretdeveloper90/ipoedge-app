import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/ipo_model.dart';
import '../theme/app_theme.dart';

class IPOCard extends StatelessWidget {
  final IPO ipo;
  final VoidCallback? onTap;

  const IPOCard({
    super.key,
    required this.ipo,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
            spreadRadius: -8,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
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
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          splashColor: AppColors.primary.withOpacity(0.04),
          highlightColor: AppColors.primary.withOpacity(0.02),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 18),
                _buildSimpleMetrics(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // Company logo with enhanced styling
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.grey.shade50,
                Colors.grey.shade100,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
                spreadRadius: -4,
              ),
            ],
            border: Border.all(
              color: Colors.grey.withOpacity(0.12),
              width: 1,
            ),
          ),
          child: ipo.logo != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(17),
                  child: CachedNetworkImage(
                    imageUrl: ipo.logo!,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.grey.shade100, Colors.grey.shade200],
                        ),
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: Icon(
                        Icons.business_rounded,
                        color: Colors.grey.shade500,
                        size: 24,
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.grey.shade100, Colors.grey.shade200],
                        ),
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: Icon(
                        Icons.business_rounded,
                        color: Colors.grey.shade500,
                        size: 24,
                      ),
                    ),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.grey.shade100, Colors.grey.shade200],
                    ),
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Icon(
                    Icons.business_rounded,
                    color: Colors.grey.shade500,
                    size: 24,
                  ),
                ),
        ),
        const SizedBox(width: 14),
        // Company info with enhanced typography
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ipo.name,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                  letterSpacing: -0.2,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.schedule_rounded,
                      size: 12,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      ipo.offerDate.formatted,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Enhanced share button
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary.withOpacity(0.1),
                AppColors.primary.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.15),
              width: 1,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _shareIPO(),
              borderRadius: BorderRadius.circular(14),
              child: const Icon(
                Icons.ios_share_rounded,
                size: 18,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSimpleMetrics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Clean metrics row with dividers
        Row(
          children: [
            Expanded(
              child: _buildSimpleMetricItem(
                '₹ Offer Price',
                ipo.offerPrice.formatted,
                null,
                const Color(0xFF2E7D32),
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: Colors.grey.withOpacity(0.2),
              margin: const EdgeInsets.symmetric(horizontal: 12),
            ),
            Expanded(
              child: _buildSimpleMetricItem(
                '📄 Lot Size',
                '${ipo.lotSize}',
                null,
                const Color(0xFFE65100),
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: Colors.grey.withOpacity(0.2),
              margin: const EdgeInsets.symmetric(horizontal: 12),
            ),
            Expanded(
              child: _buildSimpleMetricItem(
                '👥 subscriptions',
                ipo.subscription.formattedTimes,
                null,
                AppTheme.getSubscriptionColor(ipo.subscription.displayTimes),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        // Expected Premium with enhanced styling
        _buildExpectedPremiumRow(),
      ],
    );
  }

  Widget _buildSimpleMetricItem(
      String label, String value, IconData? icon, Color color) {
    return Column(
      children: [
        // Title with emoji icon - centered
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        // Value below - centered
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildExpectedPremiumRow() {
    final hasGMP = ipo.expectedPremium.hasRange;
    final gmpColor = hasGMP
        ? AppTheme.getGMPColor(ipo.gmp.safePercentage)
        : Colors.grey.shade500;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            gmpColor.withOpacity(0.08),
            gmpColor.withOpacity(0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: gmpColor.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 30,
            decoration: BoxDecoration(
              color: gmpColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              hasGMP ? Icons.trending_up_rounded : Icons.help_outline_rounded,
              color: gmpColor,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Row(
              children: [
                Text(
                  'Expected Premium: ',
                  style: TextStyle(
                    fontSize: 13,
                    color: gmpColor.withOpacity(0.8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Expanded(
                  child: Text(
                    hasGMP
                        ? '₹${ipo.expectedPremium.displayRange} (${ipo.gmp.formattedPercentage})'
                        : 'Not Available',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: gmpColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          if (hasGMP)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: gmpColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'GMP',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: gmpColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _shareIPO() {
    // Share functionality will be implemented with share_plus package
  }
}
