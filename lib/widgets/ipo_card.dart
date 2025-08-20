import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import '../models/ipo.dart';
import '../models/ipo_model.dart';
import '../models/firebase_ipo_model.dart';
import '../theme/app_theme.dart';

class IPOCard extends StatelessWidget {
  final IPO? ipo;
  final FirebaseIPO? firebaseIpo;
  final VoidCallback? onTap;

  const IPOCard({
    super.key,
    this.ipo,
    this.firebaseIpo,
    this.onTap,
  }) : assert(ipo != null || firebaseIpo != null,
            'Either ipo or firebaseIpo must be provided');

  // Helper getters to work with both data structures
  String get companyName =>
      firebaseIpo?.companyHeaders.companyName ?? ipo?.name ?? '';
  String? get companyLogo =>
      firebaseIpo?.companyHeaders.companyLogo ?? ipo?.logo;
  String get offerDateFormatted {
    if (firebaseIpo != null) {
      final openDate = firebaseIpo!.importantDates.openDate ?? '';
      final closeDate = firebaseIpo!.importantDates.closeDate ?? '';
      return '$openDate - $closeDate';
    }
    return ipo?.offerDate.formatted ?? '';
  }

  String get offerPriceFormatted {
    if (firebaseIpo != null) {
      final min = firebaseIpo!.companyIpoOverview.priceRangeMin;
      final max = firebaseIpo!.companyIpoOverview.priceRangeMax;
      if (min != null && max != null && min > 0 && max > 0) {
        return '₹$min - ₹$max';
      }
      return 'Price TBA';
    }
    return ipo?.offerPrice.formatted ?? 'Price TBA';
  }

  String get lotSizeFormatted {
    if (firebaseIpo != null) {
      return '${firebaseIpo!.companyIpoOverview.lotSize ?? 0}';
    }
    return '${ipo?.lotSize ?? 0}';
  }

  String get subscriptionFormatted {
    if (firebaseIpo != null) {
      final totalSubs =
          firebaseIpo!.subscriptionRate.subscriptionHeaderData?.totalSubscribed;
      return totalSubs != null ? '${totalSubs.toStringAsFixed(1)}x' : '-';
    }
    return ipo?.subscription.formattedTimes ?? '-';
  }

  double get subscriptionTimes {
    if (firebaseIpo != null) {
      return firebaseIpo!
              .subscriptionRate.subscriptionHeaderData?.totalSubscribed ??
          0.0;
    }
    return ipo?.subscription.displayTimes ?? 0.0;
  }

  bool get hasListingData {
    if (firebaseIpo != null) {
      return firebaseIpo!.listingGains?.listingOpenPrice != null;
    }
    return false; // For now, only Firebase IPOs have listing data
  }

  bool get shouldShowListingSection {
    if (firebaseIpo != null) {
      // Show listing section for recently listed and gain/loss analysis IPOs
      final status = _getIPOStatus();
      final hasListing = hasListingData;
      return hasListing &&
          (status == 'recently_listed' || status == 'gain_loss_analysis');
    }
    return false;
  }

  String _getIPOStatus() {
    if (firebaseIpo != null) {
      return firebaseIpo!.category ?? 'upcoming';
    }
    return 'upcoming';
  }

  String get listingPriceFormatted {
    if (firebaseIpo != null) {
      final listingOpen = firebaseIpo!.listingGains?.listingOpenPrice;
      if (listingOpen != null) {
        return '₹${listingOpen.toStringAsFixed(1)}';
      }
    }
    return '₹0.0';
  }

  String get premiumMessage {
    if (firebaseIpo != null) {
      final gainPercent = firebaseIpo!.listingGains?.currentGainPercent;
      if (gainPercent != null) {
        final isPositive = gainPercent >= 0;
        final premiumText = isPositive ? 'premium' : 'discount';
        return 'at a $premiumText of ${gainPercent.abs().toStringAsFixed(1)}%';
      }
    }
    return 'at listing price';
  }

  double get listingGainPercentage {
    if (firebaseIpo != null) {
      return firebaseIpo!.listingGains?.currentGainPercent ?? 0.0;
    }
    return 0.0;
  }

  bool get shouldShowExpectedPremiumSection {
    if (firebaseIpo != null) {
      final status = _getIPOStatus();
      return hasExpectedPremiumData &&
          (status == 'upcoming_open' || status == 'listing_soon');
    }
    return false;
  }

  bool get hasExpectedPremiumData {
    if (firebaseIpo != null) {
      // Check if expectedPremium field exists and is not empty
      return firebaseIpo!.expectedPremium != null &&
          firebaseIpo!.expectedPremium!.isNotEmpty;
    }
    return false;
  }

  String get expectedPremiumFormatted {
    if (firebaseIpo != null && firebaseIpo!.expectedPremium != null) {
      return firebaseIpo!.expectedPremium!;
    }
    return '-';
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
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          splashColor: AppColors.primary.withOpacity(0.04),
          highlightColor: AppColors.primary.withOpacity(0.02),
          child: Padding(
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
                  borderRadius: BorderRadius.circular(17),
                  child: CachedNetworkImage(
                    imageUrl: companyLogo!,
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
                        fontSize: 10,
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
        // Modern light blue share button
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary.withOpacity(0.12),
                AppColors.primary.withOpacity(0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.15),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.08),
                blurRadius: 6,
                offset: const Offset(0, 2),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _shareIPO(),
              borderRadius: BorderRadius.circular(12),
              splashColor: AppColors.primary.withOpacity(0.2),
              highlightColor: AppColors.primary.withOpacity(0.1),
              child: Icon(
                Icons.share_rounded,
                size: 12,
                color: AppColors.primary.withOpacity(0.8),
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
          // Listing Information with enhanced styling
          _buildListingInfoRow(),
        ],
        if (shouldShowExpectedPremiumSection) ...[
          const SizedBox(height: 12),
          // Expected Premium Information
          _buildExpectedPremiumRow(),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
            width: 28,
            height: 28,
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
                      fontWeight: FontWeight.w700,
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
    final premiumColor = hasExpectedPremiumData
        ? Colors.orange.shade600 // Use orange color for expected premium
        : Colors.grey.shade500;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
            width: 28,
            height: 28,
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
                    text: 'Expected Premium: ',
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
                      fontWeight: FontWeight.w700,
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
      if (firebaseIpo != null) {
        final allotment = firebaseIpo!.importantDates.allotmentDate;
        if (allotment != null && allotment.isNotEmpty) {
          allotmentDate = _formatDate(allotment);
        }
      } else if (ipo != null && ipo!.allotmentDate != null) {
        allotmentDate = _formatDate(ipo!.allotmentDate!);
      }
      if (allotmentDate.isNotEmpty) {
        shareMessage.writeln('🎯 Allotment Date: $allotmentDate');
      } else {
        shareMessage.writeln('🎯 Allotment Date: TBA');
      }

      // Listing Date
      String listingDate = '';
      if (firebaseIpo != null) {
        final listing = firebaseIpo!.importantDates.listingDate;
        if (listing != null && listing.isNotEmpty) {
          listingDate = _formatDate(listing);
        }
      } else if (ipo != null && ipo!.listingDate != null) {
        listingDate = _formatDate(ipo!.listingDate!);
      }
      if (listingDate.isNotEmpty) {
        shareMessage.writeln('📋 Listing Date: $listingDate');
      } else {
        shareMessage.writeln('📋 Listing Date: TBA');
      }

      // Price Range
      String priceInfo = '';
      if (firebaseIpo != null) {
        final priceMin = firebaseIpo!.companyIpoOverview.priceRangeMin;
        final priceMax = firebaseIpo!.companyIpoOverview.priceRangeMax;
        if (priceMin != null && priceMax != null) {
          priceInfo = '₹$priceMin - ₹$priceMax per share';
        } else if (firebaseIpo!.companyIpoOverview.issuePrice != null) {
          priceInfo =
              '₹${firebaseIpo!.companyIpoOverview.issuePrice} per share';
        }
      } else if (ipo != null) {
        priceInfo =
            '₹${ipo!.offerPrice.min} - ₹${ipo!.offerPrice.max} per share';
      }
      if (priceInfo.isNotEmpty) {
        shareMessage.writeln('💰 Price Range: $priceInfo');
      }

      // Lot Size
      String lotInfo = '';
      if (firebaseIpo != null &&
          firebaseIpo!.companyIpoOverview.lotSize != null) {
        lotInfo = '${firebaseIpo!.companyIpoOverview.lotSize} shares';
      } else if (ipo != null) {
        lotInfo = '${ipo!.lotSize} shares';
      }
      if (lotInfo.isNotEmpty) {
        shareMessage.writeln('📦 Lot Size: $lotInfo');
      }

      // Minimum Investment
      String minInvestment = '';
      if (firebaseIpo != null) {
        final lotSize = firebaseIpo!.companyIpoOverview.lotSize;
        final priceMin = firebaseIpo!.companyIpoOverview.priceRangeMin;
        if (lotSize != null && priceMin != null) {
          final investment = lotSize * priceMin;
          minInvestment = '₹${_formatCurrency(investment)}';
        }
      } else if (ipo != null) {
        final investment = ipo!.lotSize * ipo!.offerPrice.min;
        minInvestment = '₹${_formatCurrency(investment.toInt())}';
      }
      if (minInvestment.isNotEmpty) {
        shareMessage.writeln('💵 Min Investment: $minInvestment');
      }

      // Issue Size
      String issueSizeInfo = '';
      if (firebaseIpo != null &&
          firebaseIpo!.companyIpoOverview.issueSize != null) {
        issueSizeInfo =
            _formatIssueSize(firebaseIpo!.companyIpoOverview.issueSize!);
      } else if (ipo != null) {
        issueSizeInfo = ipo!.issueSize;
      }
      if (issueSizeInfo.isNotEmpty) {
        shareMessage.writeln('💼 Issue Size: $issueSizeInfo');
      }

      // Category
      String category = '';
      if (firebaseIpo != null) {
        if (firebaseIpo!.stockData.isSme == true) {
          category = 'SME';
        } else {
          category = 'Mainboard';
        }
      } else if (ipo != null) {
        category = ipo!.category == IPOCategory.sme ? 'SME' : 'Mainboard';
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

      debugPrint('IPO shared successfully');
    } catch (e) {
      debugPrint('Error sharing IPO: $e');
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
