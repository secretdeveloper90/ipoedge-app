import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:share_plus/share_plus.dart';
import '../models/ipo_model.dart';
import '../models/ipo.dart';
import '../models/firebase_ipo_model.dart';
import '../theme/app_theme.dart';
import '../services/firebase_ipo_service.dart';
import '../widgets/ipo_timeline.dart';

class IPODetailScreen extends StatefulWidget {
  final IPO? ipo;
  final FirebaseIPO? firebaseIpo;

  const IPODetailScreen({
    super.key,
    this.ipo,
    this.firebaseIpo,
  }) : assert(ipo != null || firebaseIpo != null,
            'Either ipo or firebaseIpo must be provided');

  @override
  State<IPODetailScreen> createState() => _IPODetailScreenState();
}

class _IPODetailScreenState extends State<IPODetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  IPO? _currentIPO;
  FirebaseIPO? _currentFirebaseIPO;
  bool _isLoading = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _currentIPO = widget.ipo;
    _currentFirebaseIPO = widget.firebaseIpo;
    _refreshIPOData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshIPOData() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      // Only refresh if we have a legacy IPO (for backward compatibility)
      if (widget.ipo != null) {
        final freshIPO = await FirebaseIPOService.getIPOById(widget.ipo!.id);
        if (freshIPO != null && mounted) {
          setState(() {
            _currentIPO = freshIPO;
            _isLoading = false;
          });
        } else if (mounted) {
          setState(() {
            _error = 'IPO not found';
            _isLoading = false;
          });
        }
      } else {
        // For Firebase IPO, we already have the data
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load IPO details: $e';
          _isLoading = false;
        });
      }
    }
  }

  // Helper getters to work with both data structures
  String get companyName {
    if (_currentFirebaseIPO != null) {
      return _currentFirebaseIPO!.companyHeaders.companyName;
    }
    return _currentIPO?.name ?? widget.ipo?.name ?? '';
  }

  String? get companyLogo {
    if (_currentFirebaseIPO != null) {
      return _currentFirebaseIPO!.companyHeaders.companyLogo;
    }
    return _currentIPO?.logo ?? widget.ipo?.logo;
  }

  String get sector {
    if (_currentFirebaseIPO != null) {
      return _currentFirebaseIPO!.stockData.sectorName ?? '';
    }
    return _currentIPO?.sector ?? widget.ipo?.sector ?? '';
  }

  IPO? get legacyIPO => _currentIPO ?? widget.ipo;
  FirebaseIPO? get firebaseIPO => _currentFirebaseIPO;

  // For backward compatibility, provide an ipo getter that works with existing code
  IPO get ipo {
    if (firebaseIPO != null) {
      return firebaseIPO!.toLegacyIPO();
    }
    return legacyIPO!;
  }

  // Helper to get ImportantDates for timeline
  ImportantDates get importantDates {
    if (firebaseIPO != null) {
      return firebaseIPO!.importantDates;
    }
    // For legacy IPO, create ImportantDates from available data
    return ImportantDates(
      openDate: legacyIPO?.offerDate.start,
      closeDate: legacyIPO?.offerDate.end,
      allotmentDate: legacyIPO?.allotmentDate,
      listingDate: legacyIPO?.listingDate,
      refundDate: null,
      dematCreditDate: null,
      exchangeFlags: legacyIPO?.exchange,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_error.isNotEmpty) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text('IPO Details'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _refreshIPOData,
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                _error,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _refreshIPOData,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          _buildModernHeader(),
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              labelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Financials'),
                Tab(text: 'Details'),
                Tab(text: 'Analysis'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildFinancialsTab(),
                _buildDetailsTab(),
                _buildAnalysisTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomActionBar(),
    );
  }

  Widget _buildModernHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primaryDark,
          ],
        ),
      ),
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Navigation and action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 1),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                  // Action buttons row
                  Row(
                    children: [
                      // Refresh button
                      Container(
                        width: 34,
                        height: 34,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 0.5,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _isLoading ? null : _refreshIPOData,
                            borderRadius: BorderRadius.circular(10),
                            splashColor: Colors.white.withOpacity(0.2),
                            highlightColor: Colors.white.withOpacity(0.1),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : const Icon(
                                    Icons.refresh,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                          ),
                        ),
                      ),
                      // Modern compact share button
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 0.5,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _shareIPO(),
                            borderRadius: BorderRadius.circular(10),
                            splashColor: Colors.white.withOpacity(0.2),
                            highlightColor: Colors.white.withOpacity(0.1),
                            child: const Icon(
                              Icons.share_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 5),
              // Company logo and info section
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    // Company logo
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(3),
                      child: companyLogo != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: companyLogo!,
                                fit: BoxFit.contain,
                                placeholder: (context, url) => const Icon(
                                  Icons.business,
                                  size: 22,
                                  color: Colors.grey,
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                  Icons.business,
                                  size: 22,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : const Icon(
                              Icons.business,
                              size: 22,
                              color: Colors.grey,
                            ),
                    ),
                    const SizedBox(width: 12),
                    // Company info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            companyName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            sector,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Add timeline component
              IPOTimeline(
                importantDates: importantDates,
                status: ipo.status,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIPOOverviewCard(),
          const SizedBox(height: 10),
          _buildSubscriptionRateTable(),
          const SizedBox(height: 10),
          _buildSharesOnOfferCard(),
          const SizedBox(height: 10),
          _buildDatesCard(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildFinancialsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFinancialPerformanceCard(),
          const SizedBox(height: 10),
          _buildPromoterInfoCard(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCompanyInfoCard(),
          const SizedBox(height: 10),
          _buildObjectivesCard(),
          const SizedBox(height: 10),
          _buildRegistrarCard(),
          const SizedBox(height: 10),
          _buildLeadManagersCard(),
          const SizedBox(height: 10),
          _buildBiddingTimingsCard(),
          const SizedBox(height: 10),
          _buildDocumentsCard(),
        ],
      ),
    );
  }

  Widget _buildAnalysisTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStrengthsCard(),
          const SizedBox(height: 10),
          _buildWeaknessesCard(),
          const SizedBox(height: 10),
          _buildFAQCard(),
          const SizedBox(height: 10),
          _buildRecommendationCard(),
        ],
      ),
    );
  }

  Widget _buildMetricItem(
      String label, String value, Color color, IconData icon) {
    return Container(
      height: 72,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, size: 14, color: color),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildIPOOverviewCard() {
    // Get IPO overview data from Firebase IPO if available
    CompanyIPOOverview? ipoOverview;
    if (firebaseIPO != null) {
      ipoOverview = firebaseIPO!.companyIpoOverview;
    }

    // Check if we have IPO overview data to display
    final hasData = ipoOverview != null &&
        (ipoOverview.minInvestment != null ||
            ipoOverview.lotSize != null ||
            ipoOverview.priceRangeMin != null ||
            ipoOverview.issueSize != null ||
            ipoOverview.postIssuePromoterHoldingPercent != null);

    // Don't show the card if no data is available
    if (!hasData) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'IPO Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),

            // Minimum Investment
            if (ipoOverview!.minInvestment != null) ...[
              _buildOverviewItem(
                'Minimum Investment',
                '₹${_formatNumber(ipoOverview.minInvestment!)}',
                Icons.account_balance_wallet,
                AppColors.primary,
              ),
              const SizedBox(height: 10),
            ],

            // Lot Size
            if (ipoOverview.lotSize != null) ...[
              _buildOverviewItem(
                'Lot Size',
                '${ipoOverview.lotSize}',
                Icons.inventory,
                AppColors.secondary,
              ),
              const SizedBox(height: 10),
            ],

            // Minimum & Maximum Lot
            if (ipoOverview.minLot != null && ipoOverview.maxLot != null) ...[
              _buildOverviewItem(
                'Minimum Lot - Maximum Lot',
                '${ipoOverview.minLot} - ${ipoOverview.maxLot}',
                Icons.format_list_numbered,
                AppColors.info,
              ),
              const SizedBox(height: 10),
            ] else if (ipoOverview.minLot != null) ...[
              _buildOverviewItem(
                'Minimum Lot',
                '${ipoOverview.minLot}',
                Icons.format_list_numbered,
                AppColors.info,
              ),
              const SizedBox(height: 10),
            ] else if (ipoOverview.maxLot != null) ...[
              _buildOverviewItem(
                'Maximum Lot',
                '${ipoOverview.maxLot}',
                Icons.format_list_numbered,
                AppColors.info,
              ),
              const SizedBox(height: 10),
            ],

            // Number of Shares
            if (ipoOverview.noOfShares != null) ...[
              _buildOverviewItem(
                'Number of Shares',
                _formatShares(ipoOverview.noOfShares!),
                Icons.pie_chart,
                AppColors.success,
              ),
              const SizedBox(height: 10),
            ],

            // Issue Price Band
            if (ipoOverview.priceRangeMin != null &&
                ipoOverview.priceRangeMax != null) ...[
              _buildOverviewItem(
                'Issue Price Band',
                '₹${ipoOverview.priceRangeMin} - ₹${ipoOverview.priceRangeMax}',
                Icons.trending_up,
                AppColors.warning,
              ),
              const SizedBox(height: 10),
            ],

            // Post Issue Promoter Holding
            if (ipoOverview.postIssuePromoterHoldingPercent != null) ...[
              _buildOverviewItem(
                'Post Issue Promoter Holding',
                '${ipoOverview.postIssuePromoterHoldingPercent!.toStringAsFixed(2)}%',
                Icons.person,
                AppColors.primary,
              ),
              const SizedBox(height: 10),
            ],

            // Issue Size
            if (ipoOverview.issueSize != null) ...[
              _buildOverviewItem(
                'Issue Size',
                _formatIssueSize(ipoOverview.issueSize!),
                Icons.account_balance,
                AppColors.secondary,
              ),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewItem(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.12),
            color.withOpacity(0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.15),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 18,
              color: color,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: color.withOpacity(0.8),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: color,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 10000000) {
      return '${(number / 10000000).toStringAsFixed(1)} Cr';
    } else if (number >= 100000) {
      return '${(number / 100000).toStringAsFixed(1)} L';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)} K';
    } else {
      return number.toString();
    }
  }

  String _formatIssueSize(int issueSize) {
    if (issueSize >= 10000000) {
      return '₹${(issueSize / 10000000).toStringAsFixed(1)} Cr';
    } else if (issueSize >= 100000) {
      return '₹${(issueSize / 100000).toStringAsFixed(1)} L';
    } else {
      return '₹${issueSize.toString()}';
    }
  }

  Future<void> _launchURL(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open document'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error opening document'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildSubscriptionRateTable() {
    // Get subscription rate data from Firebase IPO if available
    SubscriptionRate? subscriptionRate;
    if (firebaseIPO != null) {
      subscriptionRate = firebaseIPO!.subscriptionRate;
    }

    // Check if we have subscription data to display
    final hasHeaderData = subscriptionRate?.subscriptionHeaderData != null;
    final hasDetails = subscriptionRate?.subscriptionDetails != null &&
        subscriptionRate!.subscriptionDetails!.isNotEmpty;

    // Don't show the card if no data is available
    if (!hasHeaderData && !hasDetails) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.table_chart, color: AppColors.primary, size: 20),
                SizedBox(width: 8),
                Text(
                  'Subscription Status',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Current subscription summary (if available)
            if (hasHeaderData) ...[
              _buildCurrentSubscriptionSummary(
                  subscriptionRate!.subscriptionHeaderData!),
              const SizedBox(height: 16),
            ],

            // Day-wise subscription table (if available)
            if (hasDetails) ...[
              _buildDayWiseSubscriptionTable(
                  subscriptionRate!.subscriptionDetails!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentSubscriptionSummary(SubscriptionHeaderData headerData) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        // color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.trending_up, color: AppColors.primary, size: 16),
              const SizedBox(width: 6),
              const Text(
                'Current Subscription',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              const Spacer(),
              if (headerData.date != null) ...[
                Text(
                  'As of ${headerData.date}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          _buildSubscriptionBar(
              'Overall', ipo.subscription.times, AppColors.primary),
          const SizedBox(height: 8),
          _buildSubscriptionBar(
              'Retail', ipo.subscription.retail, AppColors.secondary),
          const SizedBox(height: 8),
          _buildSubscriptionBar('HNI', ipo.subscription.hni, AppColors.warning),
          const SizedBox(height: 8),
          _buildSubscriptionBar('QIB', ipo.subscription.qib, AppColors.info),
          if (ipo.subscription.employee != null) ...[
            const SizedBox(height: 8),
            _buildSubscriptionBar(
                'Employee', ipo.subscription.employee, AppColors.success),
          ],
        ],
      ),
    );
  }

  Widget _buildSharesOnOfferCard() {
    // Get shares on offer data from Firebase IPO if available
    SharesOnOffer? sharesOnOffer;
    if (firebaseIPO != null) {
      sharesOnOffer = firebaseIPO!.sharesOnOffer;
    }

    // Check if we have shares on offer data to display
    final hasData = sharesOnOffer != null &&
        (sharesOnOffer.totalSharesOffered != null ||
            sharesOnOffer.freshIssue != null ||
            sharesOnOffer.offerForSale != null ||
            sharesOnOffer.postIssuePromoterHoldingPercent != null);

    // Don't show the card if no data is available
    if (!hasData) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'NUMBER OF SHARES ON OFFER',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),

            // First row: Total and Fresh Issue
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    'Total',
                    _formatShares(sharesOnOffer!.totalSharesOffered),
                    AppColors.primary,
                    Icons.pie_chart,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _buildMetricItem(
                    'Fresh Issue',
                    _formatShares(sharesOnOffer.freshIssue),
                    AppColors.secondary,
                    Icons.add_circle_outline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Second row: Offer for Sale and Promoter Holding
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    'Offer for Sale',
                    _formatShares(sharesOnOffer.offerForSale),
                    AppColors.warning,
                    Icons.swap_horiz,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _buildMetricItem(
                    'Post Issue Promoter %',
                    sharesOnOffer.postIssuePromoterHoldingPercent != null
                        ? '${sharesOnOffer.postIssuePromoterHoldingPercent!.toStringAsFixed(2)}%'
                        : '-',
                    AppColors.info,
                    Icons.person,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatShares(int? shares) {
    if (shares == null || shares == 0) return '-';

    if (shares >= 10000000) {
      // Convert to millions (M)
      final millions = shares / 1000000;
      return '${millions.toStringAsFixed(1)} M';
    } else if (shares >= 100000) {
      // Convert to lakhs (L)
      final lakhs = shares / 100000;
      return '${lakhs.toStringAsFixed(1)} L';
    } else if (shares >= 1000) {
      // Convert to thousands (K)
      final thousands = shares / 1000;
      return '${thousands.toStringAsFixed(1)} K';
    } else {
      return shares.toString();
    }
  }

  Widget _buildDayWiseSubscriptionTable(List<SubscriptionDetail> details) {
    // Get allotment data for category reservations
    AllotmentTableData? allotmentData;
    if (firebaseIPO != null) {
      allotmentData = firebaseIPO!.allotment.tableData;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.calendar_today, color: AppColors.primary, size: 16),
            SizedBox(width: 6),
            Text(
              'Day-wise Subscription',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              // Table header
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Day',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'RII',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'NII',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'QIB',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              // Category Reservation row
              if (allotmentData != null) ...[
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.05),
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        flex: 3,
                        child: Text(
                          'Category Reservation',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          allotmentData.retailIndividualInvestor != null
                              ? '${allotmentData.retailIndividualInvestor}%'
                              : '-',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          allotmentData.nonInstitutionalInvestor != null
                              ? '${allotmentData.nonInstitutionalInvestor}%'
                              : '-',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.warning,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          allotmentData.qualifiedInstitutionalBuyers != null
                              ? '${allotmentData.qualifiedInstitutionalBuyers}%'
                              : '-',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.info,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              // Table rows
              ...details.asMap().entries.map((entry) {
                final index = entry.key;
                final detail = entry.value;
                final isLastRow = index == details.length - 1;

                return Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                  decoration: BoxDecoration(
                    color: index % 2 == 0 ? Colors.white : Colors.grey[50],
                    borderRadius: isLastRow
                        ? const BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          )
                        : null,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Html(
                          data: detail.day ?? '-',
                          style: {
                            "body": Style(
                              fontSize: FontSize(12),
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                              textAlign: TextAlign.center,
                              margin: Margins.zero,
                              padding: HtmlPaddings.zero,
                            ),
                            "br": Style(
                              fontSize: FontSize(12),
                            ),
                          },
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          detail.retailIndividualInvestor != null
                              ? '${detail.retailIndividualInvestor!.toStringAsFixed(2)}x'
                              : '-',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          detail.nonInstitutionalInvestor != null
                              ? '${detail.nonInstitutionalInvestor!.toStringAsFixed(2)}x'
                              : '-',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          detail.qualifiedInstitutionalBuyers != null
                              ? '${detail.qualifiedInstitutionalBuyers!.toStringAsFixed(2)}x'
                              : '-',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubscriptionBar(String category, double? times, Color color) {
    final safeTimes = times ?? 0.0;
    final fillPercentage = (safeTimes * 100).clamp(0, 100) / 100;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              category,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              times != null ? '${safeTimes.toStringAsFixed(2)}x' : '-',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: times != null ? color : AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 7,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: fillPercentage,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatesCard() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Important Dates',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            // Use importantDates for comprehensive date information
            if (importantDates.openDate != null &&
                importantDates.closeDate != null) ...[
              _buildDateItem(
                'Open Date - close Date',
                '${_formatDate(importantDates.openDate!)} - ${_formatDate(importantDates.closeDate!)}',
                Icons.calendar_today,
              ),
              const SizedBox(height: 10),
            ] else ...[
              _buildDateItem(
                'Open Date -  close Date',
                '${ipo.offerDate.start} - ${ipo.offerDate.end}',
                Icons.calendar_today,
              ),
              const SizedBox(height: 10),
            ],
            if (importantDates.allotmentDate != null) ...[
              _buildDateItem(
                'Allotment Date',
                _formatDate(importantDates.allotmentDate!),
                Icons.assignment_turned_in,
              ),
              const SizedBox(height: 10),
            ] else if (ipo.allotmentDate != null) ...[
              _buildDateItem(
                'Allotment Date',
                ipo.allotmentDate!,
                Icons.assignment_turned_in,
              ),
              const SizedBox(height: 10),
            ] else ...[
              _buildDateItem(
                'Allotment Date',
                'To be announced',
                Icons.assignment_turned_in,
              ),
              const SizedBox(height: 10),
            ],
            if (importantDates.refundDate != null) ...[
              _buildDateItem(
                'Refund Date',
                _formatDate(importantDates.refundDate!),
                Icons.money_off,
              ),
              const SizedBox(height: 10),
            ],
            if (importantDates.dematCreditDate != null) ...[
              _buildDateItem(
                'Demat Credit Date',
                _formatDate(importantDates.dematCreditDate!),
                Icons.account_balance_wallet,
              ),
              const SizedBox(height: 10),
            ],
            if (importantDates.listingDate != null) ...[
              _buildDateItem(
                'Listing Date',
                _formatDate(importantDates.listingDate!),
                Icons.list,
              ),
              const SizedBox(height: 10),
            ] else if (ipo.listingDate != null) ...[
              _buildDateItem(
                'Listing Date',
                ipo.listingDate!,
                Icons.list,
              ),
              const SizedBox(height: 10),
            ] else ...[
              _buildDateItem(
                'Listing Date',
                'Coming Soon',
                Icons.list,
              ),
              const SizedBox(height: 10),
            ],

            // Listing on Exchange(s)
            if (importantDates.exchangeFlags != null &&
                importantDates.exchangeFlags!.isNotEmpty) ...[
              _buildDateItem(
                'Listing on Exchange(s)',
                importantDates.exchangeFlags!,
                Icons.account_balance,
              ),
            ] else if (ipo.exchange.isNotEmpty) ...[
              _buildDateItem(
                'Listing on Exchange(s)',
                ipo.exchange,
                Icons.account_balance,
              ),
            ] else ...[
              _buildDateItem(
                'Listing on Exchange(s)',
                'To be announced',
                Icons.account_balance,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDateItem(String label, String value, IconData icon) {
    // Determine if this is a placeholder/unknown date
    final isPlaceholder =
        value == 'Coming Soon' || value == 'To be announced' || value.isEmpty;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isPlaceholder
            ? Colors.grey[50]
            : AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isPlaceholder
              ? Colors.grey[200]!
              : AppColors.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isPlaceholder
                  ? Colors.grey[300]
                  : AppColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              size: 16,
              color: isPlaceholder ? Colors.grey[600] : AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: isPlaceholder
                        ? Colors.grey[600]
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isPlaceholder
                        ? Colors.grey[600]
                        : AppColors.textPrimary,
                    fontStyle:
                        isPlaceholder ? FontStyle.italic : FontStyle.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Formats a date string to a more readable format
  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final months = [
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

      return '${date.day} ${months[date.month - 1]}, ${date.year}';
    } catch (e) {
      // If parsing fails, return the original string
      return dateString;
    }
  }

  // Placeholder methods for remaining cards
  Widget _buildCompanyInfoCard() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Company Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            Html(
              data: ipo.companyDescription,
              style: {
                "body": Style(
                  fontSize: FontSize(13),
                  color: AppColors.textPrimary,
                  lineHeight: LineHeight(1.4),
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                ),
                "p": Style(
                  fontSize: FontSize(13),
                  color: AppColors.textPrimary,
                  lineHeight: LineHeight(1.4),
                  margin: Margins.only(bottom: 8),
                ),
                "div": Style(
                  fontSize: FontSize(13),
                  color: AppColors.textPrimary,
                  lineHeight: LineHeight(1.4),
                  margin: Margins.only(bottom: 8),
                ),
                "span": Style(
                  fontSize: FontSize(13),
                  color: AppColors.textPrimary,
                  lineHeight: LineHeight(1.4),
                ),
                "strong": Style(
                  fontWeight: FontWeight.bold,
                ),
                "b": Style(
                  fontWeight: FontWeight.bold,
                ),
                "em": Style(
                  fontStyle: FontStyle.italic,
                ),
                "i": Style(
                  fontStyle: FontStyle.italic,
                ),
                "ul": Style(
                  margin: Margins.only(bottom: 8),
                ),
                "ol": Style(
                  margin: Margins.only(bottom: 8),
                ),
                "li": Style(
                  fontSize: FontSize(13),
                  color: AppColors.textPrimary,
                  lineHeight: LineHeight(1.4),
                  margin: Margins.only(bottom: 4),
                ),
              },
            ),
            const SizedBox(height: 14),
            _buildInfoRow('Sector', ipo.sector),
            const SizedBox(height: 6),
            _buildInfoRow('Exchange', ipo.exchange),

            // Company Details Section
            if (ipo.companyDetails != null) ...[
              const SizedBox(height: 16),
              const Text(
                'Company Details',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              if (ipo.companyDetails!.foundedYear != null) ...[
                _buildInfoRow(
                    'Founded Year', ipo.companyDetails!.foundedYear.toString()),
                const SizedBox(height: 6),
              ],
              if (ipo.companyDetails!.employees != null) ...[
                _buildInfoRow(
                    'Employees', ipo.companyDetails!.employees.toString()),
                const SizedBox(height: 6),
              ],
              if (ipo.companyDetails!.headquarters != null) ...[
                _buildInfoRow(
                    'Headquarters', ipo.companyDetails!.headquarters!),
                const SizedBox(height: 6),
              ],

              // Contact Information
              const SizedBox(height: 10),
              const Text(
                'Contact Information',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              if (ipo.companyDetails!.phone != null) ...[
                _buildContactRow(
                    Icons.phone, 'Phone', ipo.companyDetails!.phone!),
                const SizedBox(height: 6),
              ],
              if (ipo.companyDetails!.email != null) ...[
                _buildContactRow(
                    Icons.email, 'Email', ipo.companyDetails!.email!),
                const SizedBox(height: 6),
              ],
              if (ipo.companyDetails!.website != null) ...[
                _buildContactRow(
                    Icons.language, 'Website', ipo.companyDetails!.website!),
                const SizedBox(height: 6),
              ],
            ],

            // Management Section (from Firebase data)
            if (firebaseIPO?.information.management != null &&
                firebaseIPO!.information.management!.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Key Management',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              ...firebaseIPO!.information.management!
                  .take(2) // Take only first two members
                  .map((member) => Column(
                        children: [
                          _buildManagementRow(member.name, member.designation),
                          const SizedBox(height: 8),
                        ],
                      )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 75,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 14,
          color: AppColors.primary,
        ),
        const SizedBox(width: 6),
        SizedBox(
          width: 55,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildManagementRow(String name, String designation) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.person,
              size: 16,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  designation,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialPerformanceCard() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Financial Performance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            if (ipo.financials.isNotEmpty) ...[
              // Enhanced Financial data table
              _buildFinancialTable(ipo.financials),
            ] else
              const Text(
                'Financial performance data will be updated soon.',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoterInfoCard() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Promoter Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            // Promoter Holdings
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    'Pre-Issue Holding',
                    ipo.promoters.preIssueHolding != null
                        ? '${ipo.promoters.preIssueHolding!.toStringAsFixed(1)}%'
                        : '-',
                    AppColors.primary,
                    Icons.person,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricItem(
                    'Post-Issue Holding',
                    ipo.promoters.postIssueHolding != null
                        ? '${ipo.promoters.postIssueHolding!.toStringAsFixed(1)}%'
                        : '-',
                    AppColors.secondary,
                    Icons.people,
                  ),
                ),
              ],
            ),
            // Promoter Names
            if (ipo.promoters.names.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Promoter Names',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: ipo.promoters.names.asMap().entries.map((entry) {
                    final index = entry.key;
                    final name = entry.value;
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom:
                              index < ipo.promoters.names.length - 1 ? 6 : 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 5,
                            height: 5,
                            margin: const EdgeInsets.only(top: 5, right: 10),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              name,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textPrimary,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildObjectivesCard() {
    // Get the raw object of the issue content from Firebase IPO if available
    String? objectOfTheIssue;
    if (firebaseIPO != null) {
      objectOfTheIssue = firebaseIPO!.information.objectOfTheIssue;
    }

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Object of the Issue',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            if (objectOfTheIssue != null && objectOfTheIssue.isNotEmpty)
              Html(
                data: objectOfTheIssue,
                style: {
                  "body": Style(
                    fontSize: FontSize(13),
                    color: AppColors.textPrimary,
                    lineHeight: LineHeight(1.4),
                    margin: Margins.zero,
                    padding: HtmlPaddings.zero,
                  ),
                  "p": Style(
                    fontSize: FontSize(13),
                    color: AppColors.textPrimary,
                    lineHeight: LineHeight(1.4),
                    margin: Margins.only(bottom: 8),
                  ),
                  "div": Style(
                    fontSize: FontSize(13),
                    color: AppColors.textPrimary,
                    lineHeight: LineHeight(1.4),
                    margin: Margins.only(bottom: 8),
                  ),
                  "ul": Style(
                    margin: Margins.only(bottom: 8),
                  ),
                  "ol": Style(
                    margin: Margins.only(bottom: 8),
                  ),
                  "li": Style(
                    fontSize: FontSize(13),
                    color: AppColors.textPrimary,
                    lineHeight: LineHeight(1.4),
                    margin: Margins.only(bottom: 4),
                  ),
                  "strong": Style(
                    fontWeight: FontWeight.bold,
                  ),
                  "b": Style(
                    fontWeight: FontWeight.bold,
                  ),
                  "em": Style(
                    fontStyle: FontStyle.italic,
                  ),
                  "i": Style(
                    fontStyle: FontStyle.italic,
                  ),
                },
              )
            else if (ipo.issueObjectives.isNotEmpty)
              // Fallback to legacy issue objectives display
              ...ipo.issueObjectives.asMap().entries.map((entry) {
                final index = entry.key;
                final objective = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          objective,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textPrimary,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              })
            else
              const Text(
                'Object of the issue will be updated soon.',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegistrarCard() {
    // Get registrars from Firebase data if available
    List<LeadManagerRegistrar> leadManagersAndRegistrars = [];
    if (firebaseIPO != null) {
      leadManagersAndRegistrars = firebaseIPO!.leadManagersAndRegistrars;
    }

    // Filter only registrars
    final registrars = leadManagersAndRegistrars
        .where((item) => item.designation.toLowerCase().contains('registrar'))
        .toList();

    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Modern Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.assignment_ind,
                      color: Colors.blue.shade700,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Registrar',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Registrar Information
              if (registrars.isNotEmpty) ...[
                ...registrars
                    .map((registrar) => _buildModernRegistrarItem(registrar)),
              ] else if (ipo.registrarDetails != null) ...[
                // Fallback to legacy data
                _buildModernLegacyRegistrarInfo(),
              ] else ...[
                _buildModernNoDataMessage(
                    'Registrar information will be available soon.',
                    Icons.assignment_ind),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeadManagersCard() {
    // Get lead managers from Firebase data if available
    List<LeadManagerRegistrar> leadManagersAndRegistrars = [];
    if (firebaseIPO != null) {
      leadManagersAndRegistrars = firebaseIPO!.leadManagersAndRegistrars;
    }

    // Filter only lead managers
    final leadManagers = leadManagersAndRegistrars
        .where(
            (item) => item.designation.toLowerCase().contains('lead manager'))
        .toList();

    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.green.shade50,
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Modern Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.group,
                      color: Colors.green.shade700,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Lead Managers',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Lead Managers Information
              if (leadManagers.isNotEmpty) ...[
                ...leadManagers
                    .map((manager) => _buildModernLeadManagerItem(manager)),
              ] else if (ipo.leadManagers.isNotEmpty) ...[
                // Fallback to legacy data
                ...ipo.leadManagers.asMap().entries.map((entry) {
                  final index = entry.key;
                  final manager = entry.value;
                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: index < ipo.leadManagers.length - 1 ? 12 : 0),
                    child: _buildModernSimpleManagerItem(manager),
                  );
                }),
              ] else ...[
                _buildModernNoDataMessage(
                    'Lead managers information will be available soon.',
                    Icons.group),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildLeadManagerRegistrarItem(LeadManagerRegistrar item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name and designation
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 6, right: 12),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        height: 1.3,
                      ),
                    ),
                    if (item.designation.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        item.designation,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          // Contact information
          if (item.email != null || item.address != null) ...[
            const SizedBox(height: 8),
            if (item.email != null) ...[
              _buildContactInfo(Icons.email, item.email!),
              const SizedBox(height: 4),
            ],
            if (item.address != null) ...[
              _buildContactInfo(Icons.location_on, item.address!),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String info) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 20), // Align with bullet point
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            info,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSimpleManagerItem(String manager) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(top: 6, right: 12),
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            manager,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModernRegistrarItem(LeadManagerRegistrar registrar) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.business,
                  color: Colors.blue.shade700,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      registrar.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      registrar.designation,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Additional Details Section
          if (registrar.email != null || registrar.address != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (registrar.email != null) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.email_outlined,
                          size: 16,
                          color: Colors.blue.shade600,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Email:',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            registrar.email!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (registrar.email != null && registrar.address != null) ...[
                    const SizedBox(height: 8),
                  ],
                  if (registrar.address != null) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: Colors.blue.shade600,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Address:',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            registrar.address!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textPrimary,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildModernLeadManagerItem(LeadManagerRegistrar manager) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.account_balance,
                  color: Colors.green.shade700,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      manager.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      manager.designation,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Additional Details Section
          if (manager.email != null || manager.address != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (manager.email != null) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.email_outlined,
                          size: 16,
                          color: Colors.green.shade600,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Email:',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            manager.email!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (manager.email != null && manager.address != null) ...[
                    const SizedBox(height: 8),
                  ],
                  if (manager.address != null) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: Colors.green.shade600,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Address:',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            manager.address!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textPrimary,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildModernSimpleManagerItem(String manager) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.account_balance,
              color: Colors.green.shade700,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              manager,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernLegacyRegistrarInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.business,
                  color: Colors.blue.shade700,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  ipo.registrarDetails!.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Colors.grey),
          const SizedBox(height: 12),
          if (ipo.registrarDetails!.phone != null) ...[
            _buildModernContactRow(
                Icons.phone, 'Phone', ipo.registrarDetails!.phone!),
            const SizedBox(height: 8),
          ],
          if (ipo.registrarDetails!.email != null) ...[
            _buildModernContactRow(
                Icons.email, 'Email', ipo.registrarDetails!.email!),
            const SizedBox(height: 8),
          ],
          if (ipo.registrarDetails!.website != null) ...[
            _buildModernContactRow(
                Icons.language, 'Website', ipo.registrarDetails!.website!),
            const SizedBox(height: 8),
          ],
          if (ipo.registrarDetails!.address != null) ...[
            _buildModernContactRow(
                Icons.location_on, 'Address', ipo.registrarDetails!.address!),
          ],
        ],
      ),
    );
  }

  Widget _buildModernContactRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.blue.shade600,
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.blue.shade600,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModernNoDataMessage(String message, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.grey.shade400,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegacyRegistrarInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('Name', ipo.registrarDetails!.name),
          if (ipo.registrarDetails!.phone != null) ...[
            const SizedBox(height: 8),
            _buildContactRow(
                Icons.phone, 'Phone', ipo.registrarDetails!.phone!),
          ],
          if (ipo.registrarDetails!.email != null) ...[
            const SizedBox(height: 8),
            _buildContactRow(
                Icons.email, 'Email', ipo.registrarDetails!.email!),
          ],
          if (ipo.registrarDetails!.website != null) ...[
            const SizedBox(height: 8),
            _buildContactRow(
                Icons.language, 'Website', ipo.registrarDetails!.website!),
          ],
          if (ipo.registrarDetails!.address != null) ...[
            const SizedBox(height: 8),
            _buildContactRow(
                Icons.location_on, 'Address', ipo.registrarDetails!.address!),
          ],
        ],
      ),
    );
  }

  Widget _buildNoDataMessage(String message) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline,
              size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBiddingTimingsCard() {
    //  Static IPO bidding timings for display
    const String hniTiming = "10:00 AM – 4:00 PM (or before)";
    const String retailTiming = "10:00 AM – 4:00 PM (or before)";

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.access_time, color: AppColors.primary, size: 24),
                SizedBox(width: 8),
                Text(
                  'Bidding Timings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // HNI Timing Section
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.warning.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.business,
                      color: AppColors.warning, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'HNI (High Net Worth Individual)',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          hniTiming,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Retail Timing Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.success.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.people, color: AppColors.success, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Retail Investors',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          retailTiming,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Important Note Section
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.info.withOpacity(0.3)),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: AppColors.info, size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Please ensure you submit your bids before 4:00 PM to avoid rejection.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentsCard() {
    // Get document links from Firebase IPO if available
    DocumentLinks? documentLinks;
    if (firebaseIPO != null) {
      documentLinks = firebaseIPO!.documentLinks;
    }

    // Check if we have document links to display
    final hasDocumentLinks = documentLinks?.hasAnyDocuments == true;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.grey.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.description_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'IPO Documents',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Prospectus and regulatory documents',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (hasDocumentLinks) ...[
              // Document Links from Firebase
              ...documentLinks!.toIPODocuments().asMap().entries.map((entry) {
                final index = entry.key;
                final document = entry.value;
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300 + (index * 100)),
                  curve: Curves.easeOutCubic,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _openDocument(document.url),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white,
                              Colors.grey.shade50,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey.shade200,
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
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors:
                                      _getDocumentGradientColors(document.type),
                                ),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: _getDocumentGradientColors(
                                            document.type)[0]
                                        .withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                _getDocumentIcon(document.type),
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    document.title,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _getDocumentGradientColors(
                                                  document.type)[0]
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          document.type,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: _getDocumentGradientColors(
                                                document.type)[0],
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.open_in_new_rounded,
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.grey.shade50,
                      Colors.grey.shade100,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey.shade200,
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        Icons.description_outlined,
                        color: Colors.grey.shade500,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Documents Coming Soon',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'IPO documents will be available once published by regulatory authorities.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStrengthsCard() {
    // Get strengths from Firebase IPO if available, otherwise use legacy data
    List<StrengthRisk>? strengths;
    if (firebaseIPO != null) {
      strengths = firebaseIPO!.strengthsAndRisks.strengths;
    }

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.trending_up_rounded,
                    color: AppColors.success,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Strengths',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (strengths != null && strengths.isNotEmpty)
              ...strengths.asMap().entries.map((entry) {
                final index = entry.key;
                final strength = entry.value;
                return _buildStrengthRiskItem(
                  title: strength.title,
                  description: strength.description,
                  isStrength: true,
                  index: index,
                );
              })
            else if (ipo.strengths.isNotEmpty)
              // Fallback to legacy strengths display
              ...ipo.strengths.asMap().entries.map((entry) {
                final index = entry.key;
                final strength = entry.value;
                return _buildStrengthRiskItem(
                  title: strength,
                  description: '',
                  isStrength: true,
                  index: index,
                );
              })
            else
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Strengths analysis will be updated soon.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeaknessesCard() {
    // Get risks from Firebase IPO if available, otherwise use legacy data
    List<StrengthRisk>? risks;
    if (firebaseIPO != null) {
      risks = firebaseIPO!.strengthsAndRisks.risks;
    }

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.trending_down_rounded,
                    color: AppColors.error,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Risks & Weaknesses',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (risks != null && risks.isNotEmpty)
              ...risks.asMap().entries.map((entry) {
                final index = entry.key;
                final risk = entry.value;
                return _buildStrengthRiskItem(
                  title: risk.title,
                  description: risk.description,
                  isStrength: false,
                  index: index,
                );
              })
            else if (ipo.weaknesses.isNotEmpty)
              // Fallback to legacy weaknesses display
              ...ipo.weaknesses.asMap().entries.map((entry) {
                final index = entry.key;
                final weakness = entry.value;
                return _buildStrengthRiskItem(
                  title: weakness,
                  description: '',
                  isStrength: false,
                  index: index,
                );
              })
            else
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Risk analysis will be updated soon.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStrengthRiskItem({
    required String title,
    required String description,
    required bool isStrength,
    required int index,
  }) {
    final color = isStrength ? AppColors.success : AppColors.error;
    final icon =
        isStrength ? Icons.check_circle_outline : Icons.warning_amber_rounded;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: color,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: color,
                        height: 1.3,
                      ),
                    ),
                    if (description.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Html(
                        data: description,
                        style: {
                          "body": Style(
                            fontSize: FontSize(13),
                            color: AppColors.textPrimary,
                            lineHeight: LineHeight(1.4),
                            margin: Margins.zero,
                            padding: HtmlPaddings.zero,
                          ),
                          "p": Style(
                            fontSize: FontSize(13),
                            color: AppColors.textPrimary,
                            lineHeight: LineHeight(1.4),
                            margin: Margins.zero,
                          ),
                          "div": Style(
                            fontSize: FontSize(13),
                            color: AppColors.textPrimary,
                            lineHeight: LineHeight(1.4),
                            margin: Margins.zero,
                          ),
                          "strong": Style(
                            fontWeight: FontWeight.bold,
                          ),
                          "b": Style(
                            fontWeight: FontWeight.bold,
                          ),
                          "em": Style(
                            fontStyle: FontStyle.italic,
                          ),
                          "i": Style(
                            fontStyle: FontStyle.italic,
                          ),
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recommendation',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb, color: AppColors.primary, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Investment Recommendation',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Detailed investment recommendation and analysis will be provided here based on company fundamentals, market conditions, and expert analysis.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQCard() {
    // Get FAQs from Firebase IPO if available
    List<FAQ>? faqs;
    if (firebaseIPO != null) {
      faqs = firebaseIPO!.faqs;
    }

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.help_outline_rounded,
                    color: AppColors.info,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Frequently Asked Questions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (faqs != null && faqs.isNotEmpty)
              ...faqs.asMap().entries.map((entry) {
                final index = entry.key;
                final faq = entry.value;
                return _buildFAQItem(faq, index);
              })
            else
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'FAQs will be updated soon.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(FAQ faq, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.cardBorder.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: AppColors.primary.withOpacity(0.05),
          highlightColor: AppColors.primary.withOpacity(0.02),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          leading: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'Q${index + 1}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.info,
                ),
              ),
            ),
          ),
          title: Text(
            faq.question,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              height: 1.3,
            ),
          ),
          iconColor: AppColors.info,
          collapsedIconColor: AppColors.textSecondary,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.info.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Html(
                data: faq.answer,
                style: {
                  "body": Style(
                    fontSize: FontSize(13),
                    color: AppColors.textPrimary,
                    lineHeight: LineHeight(1.5),
                    margin: Margins.zero,
                    padding: HtmlPaddings.zero,
                  ),
                  "p": Style(
                    fontSize: FontSize(13),
                    color: AppColors.textPrimary,
                    lineHeight: LineHeight(1.5),
                    margin: Margins.only(bottom: 8),
                  ),
                  "strong": Style(
                    fontWeight: FontWeight.bold,
                  ),
                  "b": Style(
                    fontWeight: FontWeight.bold,
                  ),
                  "em": Style(
                    fontStyle: FontStyle.italic,
                  ),
                  "i": Style(
                    fontStyle: FontStyle.italic,
                  ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActionBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primaryDark,
              ],
              stops: [0.0, 1.0],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _applyForIPO(),
              borderRadius: BorderRadius.circular(16),
              splashColor: Colors.white.withOpacity(0.2),
              highlightColor: Colors.white.withOpacity(0.1),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(
                      child: Text(
                        'Apply',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
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
      String offerDateFormatted = '';
      if (firebaseIPO != null) {
        final openDate = firebaseIPO!.importantDates.openDate ?? '';
        final closeDate = firebaseIPO!.importantDates.closeDate ?? '';
        offerDateFormatted = '$openDate - $closeDate';
      } else if (ipo != null) {
        offerDateFormatted = ipo!.offerDate.formatted;
      }
      if (offerDateFormatted.isNotEmpty) {
        shareMessage.writeln('📅 Offer Period: $offerDateFormatted');
      }

      // Allotment Date
      String allotmentDate = '';
      if (firebaseIPO != null) {
        final allotment = firebaseIPO!.importantDates.allotmentDate;
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
      if (firebaseIPO != null) {
        final listing = firebaseIPO!.importantDates.listingDate;
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
      if (firebaseIPO != null) {
        final priceMin = firebaseIPO!.companyIpoOverview.priceRangeMin;
        final priceMax = firebaseIPO!.companyIpoOverview.priceRangeMax;
        if (priceMin != null && priceMax != null) {
          priceInfo = '₹$priceMin - ₹$priceMax per share';
        } else if (firebaseIPO!.companyIpoOverview.issuePrice != null) {
          priceInfo =
              '₹${firebaseIPO!.companyIpoOverview.issuePrice} per share';
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
      if (firebaseIPO != null &&
          firebaseIPO!.companyIpoOverview.lotSize != null) {
        lotInfo = '${firebaseIPO!.companyIpoOverview.lotSize} shares';
      } else if (ipo != null) {
        lotInfo = '${ipo!.lotSize} shares';
      }
      if (lotInfo.isNotEmpty) {
        shareMessage.writeln('📦 Lot Size: $lotInfo');
      }

      // Minimum Investment
      String minInvestment = '';
      if (firebaseIPO != null) {
        final lotSize = firebaseIPO!.companyIpoOverview.lotSize;
        final priceMin = firebaseIPO!.companyIpoOverview.priceRangeMin;
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
      if (firebaseIPO != null &&
          firebaseIPO!.companyIpoOverview.issueSize != null) {
        issueSizeInfo =
            _formatIssueSize(firebaseIPO!.companyIpoOverview.issueSize!);
      } else if (ipo != null) {
        issueSizeInfo = ipo!.issueSize;
      }
      if (issueSizeInfo.isNotEmpty) {
        shareMessage.writeln('💼 Issue Size: $issueSizeInfo');
      }

      // Category
      String category = '';
      if (firebaseIPO != null) {
        if (firebaseIPO!.stockData.isSme == true) {
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

  void _applyForIPO() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Apply for $companyName IPO - Feature coming soon'),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _openDocument(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open document'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening document: $e'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildFinancialTable(List<Financial> financials) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: const Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Period',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Revenue\n(₹Cr)',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Net Profit\n(₹Cr)',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Cash Flow\n(₹Cr)',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Free Cash\n(₹Cr)',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Margins',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          // Table rows
          ...financials.asMap().entries.map((entry) {
            final index = entry.key;
            final financial = entry.value;
            final isLastRow = index == financials.length - 1;

            return Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              decoration: BoxDecoration(
                color: index % 2 == 0 ? Colors.white : Colors.grey[50],
                borderRadius: isLastRow
                    ? const BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      )
                    : null,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      financial.year,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      financial.revenue?.toStringAsFixed(1) ?? '-',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      financial.profit?.toStringAsFixed(1) ?? '-',
                      style: TextStyle(
                        fontSize: 11,
                        color: financial.profit != null && financial.profit! > 0
                            ? AppColors.success
                            : financial.profit != null && financial.profit! < 0
                                ? AppColors.error
                                : AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      financial.cashFlowFromOperations?.toStringAsFixed(1) ??
                          '-',
                      style: TextStyle(
                        fontSize: 11,
                        color: financial.cashFlowFromOperations != null &&
                                financial.cashFlowFromOperations! > 0
                            ? AppColors.success
                            : financial.cashFlowFromOperations != null &&
                                    financial.cashFlowFromOperations! < 0
                                ? AppColors.error
                                : AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      financial.freeCashFlow?.toStringAsFixed(1) ?? '-',
                      style: TextStyle(
                        fontSize: 11,
                        color: financial.freeCashFlow != null &&
                                financial.freeCashFlow! > 0
                            ? AppColors.success
                            : financial.freeCashFlow != null &&
                                    financial.freeCashFlow! < 0
                                ? AppColors.error
                                : AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      financial.margins?.toStringAsFixed(1) != null
                          ? '${financial.margins!.toStringAsFixed(1)}%'
                          : '-',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  /// Helper method to format currency with proper suffixes
  String _formatCurrency(int amount) {
    if (amount >= 10000000) {
      return '${(amount / 10000000).toStringAsFixed(1)} Cr';
    } else if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)} L';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)} K';
    } else {
      return amount.toString();
    }
  }

  // Helper methods for document styling
  List<Color> _getDocumentGradientColors(String documentType) {
    switch (documentType.toUpperCase()) {
      case 'ANCHOR':
        return [
          const Color(0xFF6366F1), // Indigo
          const Color(0xFF8B5CF6), // Purple
        ];
      case 'DRHP':
        return [
          const Color(0xFF059669), // Emerald
          const Color(0xFF10B981), // Green
        ];
      case 'RHP':
        return [
          const Color(0xFFDC2626), // Red
          const Color(0xFFEF4444), // Light Red
        ];
      default:
        return [
          AppColors.primary,
          AppColors.primary.withOpacity(0.8),
        ];
    }
  }

  IconData _getDocumentIcon(String documentType) {
    switch (documentType.toUpperCase()) {
      case 'ANCHOR':
        return Icons.anchor_rounded;
      case 'DRHP':
        return Icons.edit_document;
      case 'RHP':
        return Icons.description_rounded;
      default:
        return Icons.picture_as_pdf_rounded;
    }
  }
}
