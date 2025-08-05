import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/ipo_model.dart';
import '../models/ipo.dart';
import '../theme/app_theme.dart';
import '../services/firebase_ipo_service.dart';

class IPODetailScreen extends StatefulWidget {
  final IPO ipo;

  const IPODetailScreen({
    super.key,
    required this.ipo,
  });

  @override
  State<IPODetailScreen> createState() => _IPODetailScreenState();
}

class _IPODetailScreenState extends State<IPODetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  IPO? _currentIPO;
  bool _isLoading = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _currentIPO = widget.ipo;
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
      final freshIPO = await FirebaseIPOService.getIPOById(widget.ipo.id);
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
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load IPO details: $e';
          _isLoading = false;
        });
      }
    }
  }

  IPO get ipo => _currentIPO ?? widget.ipo;

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
                      child: ipo.logo != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: ipo.logo!,
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
                            ipo.name,
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
                            ipo.sector,
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
          _buildKeyMetricsCard(),
          const SizedBox(height: 10),
          _buildSubscriptionCard(),
          const SizedBox(height: 10),
          _buildDatesCard(),
          const SizedBox(height: 10),
          _buildCompanyInfoCard(),
          const SizedBox(height: 10),
          _buildProductPortfolioCard(),
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
          _buildValuationsCard(),
          const SizedBox(height: 10),
          _buildFinancialPerformanceCard(),
          const SizedBox(height: 10),
          _buildPromoterInfoCard(),
          const SizedBox(height: 10),
          _buildAnchorInvestorsCard(),
          const SizedBox(height: 10),
          _buildPeerComparisonCard(),
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
          _buildIssueDetailsCard(),
          const SizedBox(height: 10),
          _buildObjectivesCard(),
          const SizedBox(height: 10),
          _buildRegistrarCard(),
          const SizedBox(height: 10),
          _buildFreshIssueOFSCard(),
          const SizedBox(height: 10),
          _buildMarketLotCard(),
          const SizedBox(height: 10),
          _buildSharesOfferedCard(),
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
          _buildRecommendationCard(),
        ],
      ),
    );
  }

  Widget _buildKeyMetricsCard() {
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
              'Key Metrics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    'GMP',
                    '${ipo.gmp.formattedPremium} (${ipo.gmp.formattedPercentage})',
                    AppTheme.getGMPColor(ipo.gmp.safePercentage),
                    Icons.trending_up,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _buildMetricItem(
                    'Expected Prem',
                    ipo.expectedPremium.displayRange,
                    AppColors.info,
                    Icons.analytics,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    'Face Value',
                    '₹${ipo.faceValue}',
                    AppColors.primary,
                    Icons.account_balance_wallet,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _buildMetricItem(
                    'Issue Size',
                    ipo.issueSize,
                    AppColors.secondary,
                    Icons.account_balance,
                  ),
                ),
              ],
            ),
            // Expected Premium Note
            if (ipo.expectedPremium.note.isNotEmpty) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.info.withOpacity(0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppColors.info,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        ipo.expectedPremium.note,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                          height: 1.3,
                        ),
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

  Widget _buildSubscriptionCard() {
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
              'Subscription Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            _buildSubscriptionBar(
                'Overall', ipo.subscription.times, AppColors.primary),
            const SizedBox(height: 8),
            _buildSubscriptionBar(
                'Retail', ipo.subscription.retail, AppColors.secondary),
            const SizedBox(height: 8),
            _buildSubscriptionBar(
                'HNI', ipo.subscription.hni, AppColors.warning),
            const SizedBox(height: 8),
            _buildSubscriptionBar('QIB', ipo.subscription.qib, AppColors.info),
            if (ipo.subscription.employee != null) ...[
              const SizedBox(height: 8),
              _buildSubscriptionBar(
                  'Employee', ipo.subscription.employee, AppColors.success),
            ],
          ],
        ),
      ),
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
            _buildDateItem(
                'Open Date',
                '${ipo.offerDate.start} - ${ipo.offerDate.end}',
                Icons.calendar_today),
            const SizedBox(height: 8),
            _buildDateItem(
                'Listing Date', ipo.listingDate ?? 'Coming Soon', Icons.list),
            const SizedBox(height: 8),
            _buildDateItem('Allotment Date', ipo.allotmentDate ?? 'Coming Soon',
                Icons.assignment_turned_in),
          ],
        ),
      ),
    );
  }

  Widget _buildDateItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
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
            Text(
              ipo.companyDescription,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
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

  Widget _buildValuationsCard() {
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
              'Valuations & Ratios',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            // EPS Row
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    'EPS (Pre-IPO)',
                    ipo.valuations.epsPreIpo?.toStringAsFixed(2) ?? '-',
                    AppColors.primary,
                    Icons.trending_up,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricItem(
                    'EPS (Post-IPO)',
                    ipo.valuations.epsPostIpo?.toStringAsFixed(2) ?? '-',
                    AppColors.secondary,
                    Icons.trending_up,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // P/E Row
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    'P/E (Pre-IPO)',
                    ipo.valuations.pePreIpo?.toStringAsFixed(1) ?? '-',
                    AppColors.warning,
                    Icons.analytics,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricItem(
                    'P/E (Post-IPO)',
                    ipo.valuations.pePostIpo?.toStringAsFixed(1) ?? '-',
                    AppColors.info,
                    Icons.analytics,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // ROE and ROCE Row
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    'ROE',
                    ipo.valuations.roe != null
                        ? '${ipo.valuations.roe!.toStringAsFixed(1)}%'
                        : '-',
                    AppColors.success,
                    Icons.percent,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricItem(
                    'ROCE',
                    ipo.valuations.roce != null
                        ? '${ipo.valuations.roce!.toStringAsFixed(1)}%'
                        : '-',
                    AppColors.primary,
                    Icons.percent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // PAT Margin and Debt-to-Equity Row
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    'PAT Margin',
                    ipo.valuations.patMargin != null
                        ? '${ipo.valuations.patMargin!.toStringAsFixed(1)}%'
                        : '-',
                    AppColors.info,
                    Icons.trending_up,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricItem(
                    'Debt/Equity',
                    ipo.valuations.debtEquity?.toStringAsFixed(2) ?? '-',
                    AppColors.warning,
                    Icons.balance,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Price-to-Book and RONW Row
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    'Price/Book',
                    ipo.valuations.priceToBook?.toStringAsFixed(2) ?? '-',
                    AppColors.secondary,
                    Icons.book,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricItem(
                    'RONW',
                    ipo.valuations.ronw != null
                        ? '${ipo.valuations.ronw!.toStringAsFixed(1)}%'
                        : '-',
                    AppColors.success,
                    Icons.account_balance_wallet,
                  ),
                ),
              ],
            ),
          ],
        ),
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
              // Financial data table header
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Year',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Revenue (₹Cr)',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Profit (₹Cr)',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              // Financial data rows
              ...ipo.financials.map((financial) => Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    margin: const EdgeInsets.only(bottom: 3),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            financial.year,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            financial.revenue?.toStringAsFixed(2) ?? '-',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            financial.profit?.toStringAsFixed(2) ?? '-',
                            style: TextStyle(
                              fontSize: 13,
                              color: financial.profit != null &&
                                      financial.profit! > 0
                                  ? AppColors.success
                                  : financial.profit != null &&
                                          financial.profit! < 0
                                      ? AppColors.error
                                      : AppColors.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 14),
              // Additional financial metrics
              if (ipo.financials.isNotEmpty) ...[
                const Text(
                  'Additional Metrics',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                ...ipo.financials.take(1).map((financial) => Column(
                      children: [
                        if (financial.assets != null ||
                            financial.netWorth != null)
                          Row(
                            children: [
                              if (financial.assets != null)
                                Expanded(
                                  child: _buildMetricItem(
                                    'Total Assets',
                                    financial.formattedAssets,
                                    AppColors.info,
                                    Icons.account_balance,
                                  ),
                                ),
                              if (financial.assets != null &&
                                  financial.netWorth != null)
                                const SizedBox(width: 12),
                              if (financial.netWorth != null)
                                Expanded(
                                  child: _buildMetricItem(
                                    'Net Worth',
                                    financial.formattedNetWorth,
                                    AppColors.success,
                                    Icons.account_balance_wallet,
                                  ),
                                ),
                            ],
                          ),
                        if (financial.totalBorrowing != null) ...[
                          const SizedBox(height: 8),
                          _buildMetricItem(
                            'Total Borrowing',
                            financial.formattedTotalBorrowing,
                            AppColors.warning,
                            Icons.credit_card,
                          ),
                        ],
                      ],
                    )),
              ],
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

  // Remaining placeholder methods for Details and Analysis tabs
  Widget _buildIssueDetailsCard() {
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
              'Issue Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            _buildInfoRow('Issue Size', ipo.issueSize),
            const SizedBox(height: 6),
            _buildInfoRow('Face Value', '₹${ipo.faceValue}'),
            const SizedBox(height: 6),
            _buildInfoRow('Lot Size', '${ipo.lotSize} shares'),
            const SizedBox(height: 6),
            _buildInfoRow('Category',
                ipo.category == IPOCategory.sme ? 'SME' : 'Mainboard'),
            const SizedBox(height: 6),
            _buildInfoRow('Offer Price', ipo.offerPrice.formatted),
            const SizedBox(height: 6),
            _buildInfoRow('Exchange', ipo.exchange),
            const SizedBox(height: 6),
            _buildInfoRow('Status', ipo.status.toUpperCase()),
          ],
        ),
      ),
    );
  }

  Widget _buildObjectivesCard() {
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
              'Issue Objectives',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            if (ipo.issueObjectives.isNotEmpty)
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
                'Issue objectives will be updated soon.',
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
              'Registrar & Lead Managers',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),

            // Registrar Information
            const Text(
              'Registrar',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            if (ipo.registrarDetails != null) ...[
              _buildInfoRow('Name', ipo.registrarDetails!.name),
              const SizedBox(height: 8),
              if (ipo.registrarDetails!.phone != null) ...[
                _buildContactRow(
                    Icons.phone, 'Phone', ipo.registrarDetails!.phone!),
                const SizedBox(height: 8),
              ],
              if (ipo.registrarDetails!.email != null) ...[
                _buildContactRow(
                    Icons.email, 'Email', ipo.registrarDetails!.email!),
                const SizedBox(height: 8),
              ],
              if (ipo.registrarDetails!.website != null) ...[
                _buildContactRow(
                    Icons.language, 'Website', ipo.registrarDetails!.website!),
                const SizedBox(height: 8),
              ],
              if (ipo.registrarDetails!.address != null) ...[
                _buildContactRow(Icons.location_on, 'Address',
                    ipo.registrarDetails!.address!),
                const SizedBox(height: 8),
              ],
            ] else ...[
              _buildInfoRow('Name', ipo.registrar ?? 'Not Available'),
              const SizedBox(height: 8),
            ],

            // Lead Managers
            const SizedBox(height: 12),
            const Text(
              'Lead Managers',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            if (ipo.leadManagers.isNotEmpty) ...[
              ...ipo.leadManagers.asMap().entries.map((entry) {
                final index = entry.key;
                final manager = entry.value;
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: index < ipo.leadManagers.length - 1 ? 8 : 0),
                  child: Row(
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
                  ),
                );
              }),
            ] else ...[
              const Text(
                'Lead managers information not available.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFreshIssueOFSCard() {
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
                Icon(Icons.account_balance, color: AppColors.primary, size: 24),
                SizedBox(width: 8),
                Text(
                  'Issue Structure',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Fresh Issue Section
            if (ipo.freshIssue != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.success.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.add_circle,
                            color: AppColors.success, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Fresh Issue',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricItem(
                            'Shares',
                            ipo.freshIssue!.shares > 0
                                ? '${(ipo.freshIssue!.shares / 1000000).toStringAsFixed(2)}M'
                                : '-',
                            AppColors.success,
                            Icons.share,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildMetricItem(
                            'Amount',
                            ipo.freshIssue!.amount.isNotEmpty
                                ? ipo.freshIssue!.amount
                                : '-',
                            AppColors.success,
                            Icons.currency_rupee,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: AppColors.textSecondary, size: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Fresh issue details will be available soon.',
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
              const SizedBox(height: 16),
            ],

            // OFS Section
            if (ipo.ofs != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.warning.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.swap_horiz,
                            color: AppColors.warning, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Offer for Sale (OFS)',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.warning,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricItem(
                            'Shares',
                            ipo.ofs!.shares > 0
                                ? '${(ipo.ofs!.shares / 1000000).toStringAsFixed(2)}M'
                                : 'None',
                            AppColors.warning,
                            Icons.share,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildMetricItem(
                            'Amount',
                            ipo.ofs!.amount.isNotEmpty ? ipo.ofs!.amount : '-',
                            AppColors.warning,
                            Icons.currency_rupee,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: AppColors.textSecondary, size: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'OFS details will be available soon.',
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

            // Retail Portion
            if (ipo.retailPortion != null && ipo.retailPortion!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.info.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.people, color: AppColors.info, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Retail Portion:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      ipo.retailPortion!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.info,
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

  Widget _buildMarketLotCard() {
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
                Icon(Icons.shopping_cart, color: AppColors.primary, size: 24),
                SizedBox(width: 8),
                Text(
                  'Market Lot Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (ipo.marketLot != null) ...[
              // Table Header
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Category',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Shares',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Amount(₹)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Applications',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Retail Row
              _buildMarketLotRow(
                'Retail',
                ipo.marketLot!.retail,
                AppColors.success,
              ),
              const SizedBox(height: 4),

              // sHNI Row
              _buildMarketLotRow(
                'sHNI',
                ipo.marketLot!.sHni,
                AppColors.warning,
              ),
              const SizedBox(height: 4),

              // bHNI Row
              _buildMarketLotRow(
                'bHNI',
                ipo.marketLot!.bHni,
                AppColors.info,
              ),
            ] else ...[
              const Text(
                'Market lot details not available.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMarketLotRow(
      String category, MarketLotDetails details, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              category,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              details.shares > 0 ? details.shares.toString() : '-',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              details.amount > 0
                  ? '₹${details.amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'
                  : '-',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              details.applications > 0
                  ? details.applications.toString().replaceAllMapped(
                      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                      (Match m) => '${m[1]},')
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
  }

  Widget _buildSharesOfferedCard() {
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
                Icon(Icons.pie_chart, color: AppColors.primary, size: 22),
                SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'Shares Offered Breakdown',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            if (ipo.sharesOffered != null) ...[
              // Total Shares
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Flexible(
                      child: Text(
                        'Total Shares Offered',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${(ipo.sharesOffered!.total / 1000000).toStringAsFixed(2)}M',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Breakdown Grid - Using Wrap for better responsiveness
              LayoutBuilder(
                builder: (context, constraints) {
                  // Calculate optimal item width based on available space
                  final availableWidth = constraints.maxWidth;
                  final itemWidth =
                      (availableWidth - 8) / 2; // 2 columns with 8px gap

                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      SizedBox(
                        width: itemWidth,
                        child: _buildSharesOfferedItem(
                          'QIB',
                          ipo.sharesOffered!.qib,
                          ipo.sharesOffered!.total,
                          AppColors.primary,
                        ),
                      ),
                      SizedBox(
                        width: itemWidth,
                        child: _buildSharesOfferedItem(
                          'NII',
                          ipo.sharesOffered!.nii,
                          ipo.sharesOffered!.total,
                          AppColors.secondary,
                        ),
                      ),
                      SizedBox(
                        width: itemWidth,
                        child: _buildSharesOfferedItem(
                          'bNII',
                          ipo.sharesOffered!.bNii,
                          ipo.sharesOffered!.total,
                          AppColors.warning,
                        ),
                      ),
                      SizedBox(
                        width: itemWidth,
                        child: _buildSharesOfferedItem(
                          'sNII',
                          ipo.sharesOffered!.sNii,
                          ipo.sharesOffered!.total,
                          AppColors.info,
                        ),
                      ),
                      SizedBox(
                        width: itemWidth,
                        child: _buildSharesOfferedItem(
                          'Retail',
                          ipo.sharesOffered!.retail,
                          ipo.sharesOffered!.total,
                          AppColors.success,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ] else ...[
              const Text(
                'Shares offered breakdown not available.',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSharesOfferedItem(
      String category, int shares, int total, Color color) {
    final percentage =
        total > 0 ? (shares / total * 100).toStringAsFixed(1) : '0.0';
    final sharesInM =
        shares > 0 ? (shares / 1000000).toStringAsFixed(2) : '0.00';

    return Container(
      height: 70, // Fixed height to prevent overflow
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              category,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 1),
          Flexible(
            child: Text(
              shares > 0 ? '${sharesInM}M' : '-',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Flexible(
            child: Text(
              shares > 0 ? '($percentage%)' : '(-)',
              style: TextStyle(
                fontSize: 10,
                color: color,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductPortfolioCard() {
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
                Icon(Icons.inventory, color: AppColors.primary, size: 24),
                SizedBox(width: 8),
                Text(
                  'Product Portfolio',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (ipo.productPortfolio != null) ...[
              // Gold Type
              if (ipo.productPortfolio!.goldType.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: AppColors.warning.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.diamond,
                          color: AppColors.warning, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Gold Type',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              ipo.productPortfolio!.goldType,
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
              ],

              // Main Products
              if (ipo.productPortfolio!.mainProducts.isNotEmpty) ...[
                const Text(
                  'Main Products',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ipo.productPortfolio!.mainProducts
                      .map((product) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: AppColors.primary.withOpacity(0.3)),
                            ),
                            child: Text(
                              product.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 16),
              ],

              // Occasions
              if (ipo.productPortfolio!.occasions.isNotEmpty) ...[
                const Text(
                  'Target Occasions',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ipo.productPortfolio!.occasions
                      .map((occasion) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: AppColors.success.withOpacity(0.3)),
                            ),
                            child: Text(
                              occasion.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.success,
                              ),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 16),
              ],

              // Price Segments
              if (ipo.productPortfolio!.priceSegments.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.info.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.price_change,
                          color: AppColors.info, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Price Segments',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              ipo.productPortfolio!.priceSegments,
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
              ],
            ] else ...[
              const Text(
                'Product portfolio information not available.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAnchorInvestorsCard() {
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
                Icon(Icons.anchor, color: AppColors.primary, size: 24),
                SizedBox(width: 8),
                Text(
                  'Anchor Investors',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (ipo.anchorInvestors != null &&
                ipo.anchorInvestors!.investors.isNotEmpty) ...[
              // Total Amount
              if (ipo.anchorInvestors!.totalAmount != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: AppColors.success.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Anchor Investment',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        ipo.anchorInvestors!.totalAmount!,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Investors List
              const Text(
                'Anchor Investors List',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: ipo.anchorInvestors!.investors
                      .asMap()
                      .entries
                      .map((entry) {
                    final index = entry.key;
                    final investor = entry.value;
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom:
                              index < ipo.anchorInvestors!.investors.length - 1
                                  ? 12
                                  : 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: AppColors.primary.withOpacity(0.3)),
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              investor,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textPrimary,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ] else ...[
              const Text(
                'Anchor investor information not available.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPeerComparisonCard() {
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
                Icon(Icons.compare_arrows, color: AppColors.primary, size: 24),
                SizedBox(width: 8),
                Text(
                  'Peer Comparison',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (ipo.peers.isNotEmpty) ...[
              // Table Header
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Company',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'P/B Ratio',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'P/E Ratio',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'RONW (%)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Current IPO Row
              _buildPeerRow(
                ipo.name,
                ipo.valuations.priceToBook,
                ipo.valuations.pePostIpo,
                ipo.valuations.ronw,
                AppColors.primary,
                isCurrentIPO: true,
              ),
              const SizedBox(height: 4),

              // Peer Rows
              ...ipo.peers.map((peer) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: _buildPeerRow(
                      peer.name,
                      peer.pbRatio,
                      peer.peRatio,
                      peer.ronw,
                      AppColors.textSecondary,
                    ),
                  )),
            ] else ...[
              const Text(
                'Peer comparison data not available.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPeerRow(
      String name, double? pbRatio, double? peRatio, double? ronw, Color color,
      {bool isCurrentIPO = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: isCurrentIPO ? color.withOpacity(0.1) : Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCurrentIPO ? color.withOpacity(0.3) : Colors.grey[200]!,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              name.isNotEmpty ? name : 'N/A',
              style: TextStyle(
                fontSize: 14,
                fontWeight: isCurrentIPO ? FontWeight.bold : FontWeight.w600,
                color: isCurrentIPO ? color : AppColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              pbRatio != null && pbRatio > 0 ? pbRatio.toStringAsFixed(2) : '-',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              peRatio != null && peRatio > 0 ? peRatio.toStringAsFixed(2) : '-',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              ronw != null && ronw > 0 ? ronw.toStringAsFixed(1) : '-',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBiddingTimingsCard() {
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
            if (ipo.biddingTimings != null) ...[
              // HNI Timing
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
                            ipo.biddingTimings!.hni,
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

              // Retail Timing
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.success.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.people,
                        color: AppColors.success, size: 20),
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
                            ipo.biddingTimings!.retail,
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

              // Important Note
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
                    Icon(
                      Icons.info_outline,
                      color: AppColors.info,
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Please ensure to submit your bids before the specified cut-off times to avoid rejection.',
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
            ] else ...[
              const Text(
                'Bidding timings information not available.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentsCard() {
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
                Icon(Icons.description, color: AppColors.primary, size: 24),
                SizedBox(width: 8),
                Text(
                  'IPO Documents',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (ipo.documents.isNotEmpty) ...[
              ...ipo.documents.map((document) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.picture_as_pdf,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                document.title,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    document.type.toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  if (document.size != null) ...[
                                    const Text(' • ',
                                        style: TextStyle(
                                            color: AppColors.textSecondary)),
                                    Text(
                                      document.size!,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => _openDocument(document.url),
                          icon: const Icon(
                            Icons.open_in_new,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          tooltip: 'Open in browser',
                        ),
                      ],
                    ),
                  )),
            ] else ...[
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
                        'IPO documents will be available soon.',
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
          ],
        ),
      ),
    );
  }

  Widget _buildStrengthsCard() {
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
                Icon(Icons.thumb_up, color: AppColors.success, size: 24),
                SizedBox(width: 8),
                Text(
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
            if (ipo.strengths.isNotEmpty)
              ...ipo.strengths.map((strength) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.only(top: 6, right: 12),
                          decoration: const BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            strength,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textPrimary,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
            else
              const Text(
                'Strengths analysis will be updated soon.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeaknessesCard() {
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
                Icon(Icons.thumb_down, color: AppColors.error, size: 24),
                SizedBox(width: 8),
                Text(
                  'Weaknesses',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (ipo.weaknesses.isNotEmpty)
              ...ipo.weaknesses.map((weakness) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.only(top: 6, right: 12),
                          decoration: const BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            weakness,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textPrimary,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
            else
              const Text(
                'Weaknesses analysis will be updated soon.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
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

  void _shareIPO() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality will be implemented soon'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _applyForIPO() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Apply for ${widget.ipo.name} IPO - Feature coming soon'),
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
}
