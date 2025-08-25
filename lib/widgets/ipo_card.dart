import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import '../models/firebase_ipo_model.dart';
import '../theme/app_theme.dart';

class IPOCard extends StatefulWidget {
  final FirebaseIPO firebaseIpo;
  final VoidCallback? onTap;

  const IPOCard({
    super.key,
    required this.firebaseIpo,
    this.onTap,
  });

  @override
  State<IPOCard> createState() => _IPOCardState();
}

class _IPOCardState extends State<IPOCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Start the blinking animation
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Helper getters for Firebase IPO data
  String get companyName => widget.firebaseIpo.companyHeaders.companyName;
  String? get companyLogo => widget.firebaseIpo.companyHeaders.companyLogo;
  String get offerDateFormatted {
    final openDate = widget.firebaseIpo.importantDates.openDate ?? '';
    final closeDate = widget.firebaseIpo.importantDates.closeDate ?? '';

    if (openDate.isEmpty || closeDate.isEmpty) {
      return 'Offer Date: TBA';
    }

    try {
      final startDate = DateTime.parse(openDate);
      final endDate = DateTime.parse(closeDate);

      const List<String> months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];

      final startDay = startDate.day;
      final startMonth = months[startDate.month - 1];
      final endDay = endDate.day;
      final endMonth = months[endDate.month - 1];
      final startYear = startDate.year;
      final endYear = endDate.year;

      if (startDate.month == endDate.month && startDate.year == endDate.year) {
        // Same month and year: "22-24 Aug, 2025"
        return 'Offer Date: $startDay-$endDay $endMonth, $endYear';
      } else if (startDate.year == endDate.year) {
        // Same year, different months: "30 Aug - 1 Sept, 2025"
        return 'Offer Date: $startDay $startMonth - $endDay $endMonth, $endYear';
      } else {
        // Different years: "31 dec, 2025 - 1 jav, 2026"
        return 'Offer Date: $startDay $startMonth, $startYear - $endDay $endMonth, $endYear';
      }
    } catch (e) {
      // Fallback to original format if parsing fails
      return 'Offer Date: $openDate - $closeDate';
    }
  }

  String get offerPriceFormatted {
    final min = widget.firebaseIpo.companyIpoOverview.priceRangeMin;
    final max = widget.firebaseIpo.companyIpoOverview.priceRangeMax;
    if (min != null && max != null && min > 0 && max > 0) {
      return '₹$min - ₹$max';
    }
    return 'Price TBA';
  }

  String get lotSizeFormatted {
    return '${widget.firebaseIpo.companyIpoOverview.lotSize ?? 0}';
  }

  String get subscriptionFormatted {
    final totalSubs = widget
        .firebaseIpo.subscriptionRate.subscriptionHeaderData?.totalSubscribed;
    return totalSubs != null ? '${totalSubs.toStringAsFixed(1)}x' : '-';
  }

  double get subscriptionTimes {
    return widget.firebaseIpo.subscriptionRate.subscriptionHeaderData
            ?.totalSubscribed ??
        0.0;
  }

  bool get hasListingData {
    return widget.firebaseIpo.listingGains?.listingOpenPrice != null;
  }

  bool get shouldShowListingSection {
    // Show listing section for recently listed and gain/loss analysis IPOs
    final status = _getIPOStatus();
    final hasListing = hasListingData;
    return hasListing &&
        (status == 'recently_listed' || status == 'gain_loss_analysis');
  }

  String _getIPOStatus() {
    return widget.firebaseIpo.category ?? 'upcoming';
  }

  /// Get detailed IPO status based on important dates
  String _getDetailedIPOStatus() {
    final now = DateTime.now();

    final openDate =
        DateTime.tryParse(widget.firebaseIpo.importantDates.openDate ?? '');
    final closeDate =
        DateTime.tryParse(widget.firebaseIpo.importantDates.closeDate ?? '');
    final allotmentDate = DateTime.tryParse(
        widget.firebaseIpo.importantDates.allotmentDate ?? '');
    final listingDate =
        DateTime.tryParse(widget.firebaseIpo.importantDates.listingDate ?? '');

    // Listed - after listing date
    if (listingDate != null && now.isAfter(listingDate)) {
      return 'listed';
    }

    // Allotment Out - after allotment date 11 PM but before listing
    if (allotmentDate != null) {
      final allotmentDateWith11PM = DateTime(
        allotmentDate.year,
        allotmentDate.month,
        allotmentDate.day,
        23, // 11 PM
        0,
        0,
      );
      if (now.isAfter(allotmentDateWith11PM)) {
        return 'allotment_out';
      }
    }

    // Live - between open and close date (until 5 PM on close date)
    if (openDate != null && closeDate != null && now.isAfter(openDate)) {
      // Create close date with 5 PM cutoff
      final closeDateWith5PM = DateTime(
        closeDate.year,
        closeDate.month,
        closeDate.day,
        17, // 5 PM
        0,
        0,
      );

      if (now.isBefore(closeDateWith5PM)) {
        return 'live';
      }
    }

    // Allotment Awaited - after close date 5 PM but before allotment
    if (closeDate != null) {
      final closeDateWith5PM = DateTime(
        closeDate.year,
        closeDate.month,
        closeDate.day,
        17, // 5 PM
        0,
        0,
      );
      if (now.isAfter(closeDateWith5PM)) {
        return 'allotment_awaited';
      }
    }

    // Upcoming - before open date
    return 'upcoming';
  }

  /// Build status badge widget
  Widget _buildStatusBadge() {
    final status = _getDetailedIPOStatus();

    String text;
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (status) {
      case 'live':
        text = 'LIVE';
        backgroundColor = const Color(0xFF4CAF50);
        textColor = Colors.white;
        icon = Icons.circle;
        break;
      case 'allotment_awaited':
        text = 'ALLOTMENT AWAITED';
        backgroundColor = const Color(0xFFFF9800);
        textColor = Colors.white;
        icon = Icons.hourglass_empty;
        break;
      case 'allotment_out':
        text = 'ALLOTMENT OUT';
        backgroundColor = const Color(0xFF2196F3);
        textColor = Colors.white;
        icon = Icons.assignment_turned_in;
        break;
      case 'listed':
        text = 'LISTED';
        backgroundColor = const Color(0xFF9C27B0);
        textColor = Colors.white;
        icon = Icons.trending_up;
        break;
      default:
        text = 'UPCOMING';
        backgroundColor = const Color(0xFF607D8B);
        textColor = Colors.white;
        icon = Icons.schedule;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(8), // Match card's corner radius
          bottomLeft: Radius.circular(8), // Smooth curve for bottom-left
        ),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
            spreadRadius: -2,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
            spreadRadius: -4,
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Icon(
                  icon,
                  size: 11,
                  color: textColor,
                ),
              );
            },
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: textColor,
              letterSpacing: 0.3,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  String get listingPriceFormatted {
    final listingOpen = widget.firebaseIpo.listingGains?.listingOpenPrice;
    if (listingOpen != null) {
      return '₹${listingOpen.toStringAsFixed(1)}';
    }
    return '₹0.0';
  }

  String get premiumMessage {
    final gainPercent = widget.firebaseIpo.listingGains?.currentGainPercent;
    if (gainPercent != null) {
      final isPositive = gainPercent >= 0;
      final premiumText = isPositive ? 'premium' : 'discount';
      return 'at a $premiumText of ${gainPercent.abs().toStringAsFixed(1)}%';
    }
    return 'at listing price';
  }

  double get listingGainPercentage {
    return widget.firebaseIpo.listingGains?.currentGainPercent ?? 0.0;
  }

  bool get shouldShowExpectedPremiumSection {
    final status = _getIPOStatus();
    return (status == 'upcoming_open' || status == 'listing_soon');
  }

  bool get hasExpectedPremiumData {
    // Check if expectedPremium field exists and is not empty
    return widget.firebaseIpo.expectedPremium != null &&
        widget.firebaseIpo.expectedPremium!.isNotEmpty;
  }

  String get expectedPremiumFormatted {
    if (widget.firebaseIpo.expectedPremium != null) {
      return widget.firebaseIpo.expectedPremium!;
    }
    return 'Update Soon';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(12),
          splashColor: AppColors.primary.withOpacity(0.04),
          highlightColor: AppColors.primary.withOpacity(0.02),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 14),
                    _buildSimpleMetrics(),
                  ],
                ),
              ),
              // Status badge positioned at top-right corner with slight margin
              Positioned(
                top: 0,
                right: 0,
                child: _buildStatusBadge(),
              ),
            ],
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
            borderRadius: BorderRadius.circular(10),
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
          child: companyLogo != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: companyLogo!,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.grey.shade100, Colors.grey.shade200],
                        ),
                        borderRadius: BorderRadius.circular(10),
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
                        borderRadius: BorderRadius.circular(10),
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
                    borderRadius: BorderRadius.circular(10),
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
              Padding(
                padding: const EdgeInsets.only(
                    right:
                        120), // Increased padding to accommodate longer status badges
                child: Text(
                  companyName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                    letterSpacing: -0.2,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
                      offerDateFormatted,
                      style: const TextStyle(
                        fontSize: 11,
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
                offerPriceFormatted,
                null,
                const Color(0xFF2E7D32),
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: Colors.grey.withOpacity(0.2),
              margin: const EdgeInsets.symmetric(horizontal: 10),
            ),
            Expanded(
              child: _buildSimpleMetricItem(
                'Lot Size',
                lotSizeFormatted,
                Icons.line_weight,
                const Color(0xFFE65100),
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: Colors.grey.withOpacity(0.2),
              margin: const EdgeInsets.symmetric(horizontal: 10),
            ),
            Expanded(
              child: _buildSimpleMetricItem(
                'Subscription',
                subscriptionFormatted,
                Icons.subscriptions_outlined,
                AppTheme.getSubscriptionColor(subscriptionTimes),
              ),
            ),
          ],
        ),
        if (shouldShowListingSection) ...[
          const SizedBox(height: 12),
          // Listing Information with enhanced styling and share icon
          Row(
            children: [
              Expanded(
                flex: 4,
                child: _buildListingInfoRow(),
              ),
              const SizedBox(width: 8),
              _buildShareIcon(),
            ],
          ),
        ] else if (shouldShowExpectedPremiumSection) ...[
          const SizedBox(height: 12),
          // Expected Premium Information with share icon
          Row(
            children: [
              Expanded(
                flex: 4,
                child: _buildExpectedPremiumRow(),
              ),
              const SizedBox(width: 8),
              _buildShareIcon(),
            ],
          ),
        ] else ...[
          const SizedBox(height: 12),
          // Always show share icon even when no premium/listing sections are visible
          Row(
            children: [
              const Spacer(),
              _buildShareIcon(),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildSimpleMetricItem(
      String label, String value, IconData? icon, Color color) {
    return Column(
      children: [
        // Title with icon - centered
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 14,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 4),
            ],
            Flexible(
              child: Text(
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
            ),
          ],
        ),
        const SizedBox(height: 4),
        // Value below - centered
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
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

  Widget _buildListingInfoRow() {
    final listingColor = hasListingData
        ? AppTheme.getGMPColor(listingGainPercentage)
        : Colors.grey.shade500;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            listingColor.withOpacity(0.08),
            listingColor.withOpacity(0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: listingColor.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: listingColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              listingGainPercentage >= 0
                  ? Icons.trending_up_rounded
                  : Icons.trending_down_rounded,
              color: listingColor,
              size: 14,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Listing Price: ',
                    style: TextStyle(
                      fontSize: 12,
                      color: listingColor.withOpacity(0.8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: listingPriceFormatted,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: listingColor,
                    ),
                  ),
                  TextSpan(
                    text: ' $premiumMessage',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: listingColor.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpectedPremiumRow() {
    final premiumColor =
        hasExpectedPremiumData ? AppColors.gmpPositive : Colors.grey.shade500;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            premiumColor.withOpacity(0.08),
            premiumColor.withOpacity(0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: premiumColor.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: premiumColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.star_outline_rounded,
              color: premiumColor,
              size: 14,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Exp. Premium: ',
                    style: TextStyle(
                      fontSize: 12,
                      color: premiumColor.withOpacity(0.8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: expectedPremiumFormatted,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: premiumColor,
                    ),
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShareIcon() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () => _shareIPO(),
          borderRadius: BorderRadius.circular(8),
          splashColor: AppColors.primary.withOpacity(0.1),
          highlightColor: AppColors.primary.withOpacity(0.05),
          child: const Padding(
            padding: EdgeInsets.all(4),
            child: Icon(
              Icons.share,
              color: AppColors.primary,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }

  void _shareIPO() async {
    try {
      // Create modern, attractive share message with comprehensive IPO details
      final StringBuffer shareMessage = StringBuffer();

      // Header with attractive design
      shareMessage.writeln('🚀 IPO ALERT - $companyName 🚀');
      shareMessage.writeln();

      // Key IPO Details Section
      shareMessage.writeln('📊 KEY DETAILS');

      // Open-Close Dates
      if (offerDateFormatted.isNotEmpty) {
        shareMessage.writeln('📅 Offer Period: $offerDateFormatted');
      }

      // Allotment Date
      String allotmentDate = '';
      final allotment = widget.firebaseIpo.importantDates.allotmentDate;
      if (allotment != null && allotment.isNotEmpty) {
        allotmentDate = _formatDate(allotment);
      }
      if (allotmentDate.isNotEmpty) {
        shareMessage.writeln('🎯 Allotment Date: $allotmentDate');
      } else {
        shareMessage.writeln('🎯 Allotment Date: TBA');
      }

      // Listing Date
      String listingDate = '';
      final listing = widget.firebaseIpo.importantDates.listingDate;
      if (listing != null && listing.isNotEmpty) {
        listingDate = _formatDate(listing);
      }
      if (listingDate.isNotEmpty) {
        shareMessage.writeln('📋 Listing Date: $listingDate');
      } else {
        shareMessage.writeln('📋 Listing Date: TBA');
      }

      // Price Range
      String priceInfo = '';
      final priceMin = widget.firebaseIpo.companyIpoOverview.priceRangeMin;
      final priceMax = widget.firebaseIpo.companyIpoOverview.priceRangeMax;
      if (priceMin != null && priceMax != null) {
        priceInfo = '₹$priceMin - ₹$priceMax per share';
      } else if (widget.firebaseIpo.companyIpoOverview.issuePrice != null) {
        priceInfo =
            '₹${widget.firebaseIpo.companyIpoOverview.issuePrice} per share';
      }
      if (priceInfo.isNotEmpty) {
        shareMessage.writeln('💰 Price Range: $priceInfo');
      }

      // Lot Size
      String lotInfo = '';
      if (widget.firebaseIpo.companyIpoOverview.lotSize != null) {
        lotInfo = '${widget.firebaseIpo.companyIpoOverview.lotSize} shares';
      }
      if (lotInfo.isNotEmpty) {
        shareMessage.writeln('📦 Lot Size: $lotInfo');
      }

      // Minimum Investment
      String minInvestment = '';
      final lotSize = widget.firebaseIpo.companyIpoOverview.lotSize;
      final minPrice = widget.firebaseIpo.companyIpoOverview.priceRangeMin;
      if (lotSize != null && minPrice != null) {
        final investment = lotSize * minPrice;
        minInvestment = '₹${_formatCurrency(investment)}';
      }
      if (minInvestment.isNotEmpty) {
        shareMessage.writeln('💵 Min Investment: $minInvestment');
      }

      // Issue Size
      String issueSizeInfo = '';
      if (widget.firebaseIpo.companyIpoOverview.issueSize != null) {
        issueSizeInfo =
            _formatIssueSize(widget.firebaseIpo.companyIpoOverview.issueSize!);
      }
      if (issueSizeInfo.isNotEmpty) {
        shareMessage.writeln('💼 Issue Size: $issueSizeInfo');
      }

      // Category
      String category = '';
      if (widget.firebaseIpo.stockData.isSme == true) {
        category = 'SME';
      } else {
        category = 'Mainboard';
      }
      if (category.isNotEmpty) {
        shareMessage.writeln('🏢 Category: $category');
      }

      shareMessage.writeln();

      // Footer with app promotion and links
      shareMessage.writeln('📱 Get real-time IPO updates on IPO Edge');
      shareMessage.writeln('🔔 Never miss an IPO opportunity!');
      shareMessage.writeln();
      shareMessage.writeln('🌐 Website: www.ipoedge.in');
      shareMessage.writeln('📲 App: Coming Soon');
      shareMessage.writeln('📱 Social Media: Coming Soon');
      shareMessage.writeln();

      // Share the message using the share_plus package
      await Share.share(shareMessage.toString());
    } catch (e) {
      // Handle sharing error silently
    }
  }

  /// Helper method to format issue size in crores
  String _formatIssueSize(int issueSize) {
    if (issueSize >= 10000000) {
      return '₹${(issueSize / 10000000).toStringAsFixed(1)} Cr';
    } else if (issueSize >= 100000) {
      return '₹${(issueSize / 100000).toStringAsFixed(1)} L';
    } else {
      return '₹${issueSize.toString()}';
    }
  }

  /// Helper method to format date to readable format
  String _formatDate(String date) {
    try {
      final DateTime parsedDate = DateTime.parse(date);
      const List<String> months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return '${parsedDate.day} ${months[parsedDate.month - 1]} ${parsedDate.year}';
    } catch (e) {
      return date;
    }
  }

  /// Helper method to format currency with proper suffixes
  String _formatCurrency(int amount) {
    if (amount >= 10000000) {
      return '${(amount / 10000000).toStringAsFixed(1)} Cr';
    } else if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)} L';
    } else {
      return amount.toString();
    }
  }
}
