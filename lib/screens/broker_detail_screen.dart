import 'package:flutter/material.dart';
import '../models/broker.dart';
import '../theme/app_theme.dart';

class BrokerDetailScreen extends StatefulWidget {
  final Broker broker;

  const BrokerDetailScreen({
    super.key,
    required this.broker,
  });

  @override
  State<BrokerDetailScreen> createState() => _BrokerDetailScreenState();
}

class _BrokerDetailScreenState extends State<BrokerDetailScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                fontSize: 14,
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
                Tab(text: 'Charges'),
                Tab(text: 'Features'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildChargesTab(),
                _buildFeaturesTab(),
              ],
            ),
          ),
        ],
      ),
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
                        onTap: () => _shareBroker(),
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
              const SizedBox(height: 5),
              // Broker logo and info section
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
                    // Broker logo
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          widget.broker.logo,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.business,
                              size: 22,
                              color: Colors.grey,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Broker info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.broker.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              // Rating container with background
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 0.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.star_rounded,
                                      size: 14,
                                      color: Colors.amber[300],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      widget.broker.formattedRating,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Active clients info
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 0.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.people_rounded,
                                      size: 14,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      widget.broker.activeClients,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
        children: [
          _buildDescriptionCard(),
          const SizedBox(height: 10),
          _buildKeyMetricsCard(),
          const SizedBox(height: 10),
          _buildServicesCard(),
          const SizedBox(height: 10),
          _buildOtherInvestmentsCard(),
          const SizedBox(height: 10),
          _buildProsConsCard(),
        ],
      ),
    );
  }

  Widget _buildChargesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        children: [
          _buildAccountChargesCard(),
          const SizedBox(height: 10),
          _buildBrokerageChargesCard(),
          const SizedBox(height: 10),
          _buildMarginRatesCard(),
          const SizedBox(height: 10),
          _buildDetailedChargesCard(),
        ],
      ),
    );
  }

  Widget _buildFeaturesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        children: [
          _buildPlatformsCard(),
          const SizedBox(height: 10),
          _buildFeaturesListCard(),
          const SizedBox(height: 10),
          _buildAdditionalFeaturesCard(),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard() {
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
              'About',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              widget.broker.description,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
          ],
        ),
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
                    'Active Clients',
                    widget.broker.activeClients,
                    AppColors.primary,
                    Icons.people,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _buildMetricItem(
                    'Rating',
                    widget.broker.formattedRating,
                    AppColors.warning,
                    Icons.star,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    'Account Opening',
                    widget.broker.accountOpening,
                    AppColors.success,
                    Icons.account_balance_wallet,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _buildMetricItem(
                    'Maintenance',
                    widget.broker.accountMaintenance,
                    AppColors.info,
                    Icons.settings,
                  ),
                ),
              ],
            ),
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

  Widget _buildServicesCard() {
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
              'Trading Services',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.broker.services.map((service) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      service.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtherInvestmentsCard() {
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
              'Other Investment Options',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.broker.otherInvestments.map((investment) {
                  return _buildInvestmentOption(investment);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvestmentOption(String investment) {
    IconData icon;
    Color color;

    // Assign icons and colors based on investment type
    switch (investment.toLowerCase()) {
      case 'mutual funds':
        icon = Icons.pie_chart;
        color = AppColors.primary;
        break;
      case 'ipo platform':
        icon = Icons.trending_up;
        color = AppColors.success;
        break;
      case 'bonds debt':
        icon = Icons.account_balance;
        color = AppColors.info;
        break;
      case 'exchange traded funds':
        icon = Icons.show_chart;
        color = AppColors.warning;
        break;
      case 'insurance':
        icon = Icons.security;
        color = AppColors.error;
        break;
      default:
        icon = Icons.monetization_on;
        color = AppColors.secondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            _formatInvestmentName(investment).toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _formatInvestmentName(String investment) {
    // Convert to title case and handle special cases for horizontal layout
    switch (investment.toLowerCase()) {
      case 'mutual funds':
        return 'Mutual Funds';
      case 'ipo platform':
        return 'IPO';
      case 'bonds debt':
        return 'Bonds';
      case 'exchange traded funds':
        return 'ETFs';
      case 'insurance':
        return 'Insurance';
      default:
        return investment
            .split(' ')
            .map((word) => word[0].toUpperCase() + word.substring(1))
            .join(' ');
    }
  }

  Widget _buildProsConsCard() {
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
              'Pros & Cons',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            // Pros Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.success.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: AppColors.success,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Pros',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...widget.broker.pros.map((pro) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 6),
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.success,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              pro,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Cons Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.error.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.cancel,
                        color: AppColors.error,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Cons',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.error,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...widget.broker.cons.map((con) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 6),
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              con,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                height: 1.4,
                              ),
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
        ),
      ),
    );
  }

  Widget _buildAccountChargesCard() {
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
              'Account Charges',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            _buildChargeItem('Account Opening', widget.broker.accountOpening),
            _buildChargeItem(
                'Account Maintenance', widget.broker.accountMaintenance),
            _buildChargeItem('Call & Trade', widget.broker.callTrade),
          ],
        ),
      ),
    );
  }

  Widget _buildBrokerageChargesCard() {
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
              'Brokerage Charges',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            _buildChargeItem(
                'Equity Delivery', widget.broker.brokerage.equityDelivery),
            _buildChargeItem(
                'Equity Intraday', widget.broker.brokerage.equityIntraday),
            _buildChargeItem(
                'Equity Futures', widget.broker.brokerage.equityFutures),
            _buildChargeItem(
                'Equity Options', widget.broker.brokerage.equityOptions),
            _buildChargeItem(
                'Currency Futures', widget.broker.brokerage.currencyFutures),
            _buildChargeItem(
                'Currency Options', widget.broker.brokerage.currencyOptions),
            _buildChargeItem(
                'Commodity Futures', widget.broker.brokerage.commodityFutures),
            _buildChargeItem(
                'Commodity Options', widget.broker.brokerage.commodityOptions),
          ],
        ),
      ),
    );
  }

  Widget _buildMarginRatesCard() {
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
              'Margin Rates',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            _buildChargeItem(
                'Equity Delivery', widget.broker.margins.equityDelivery),
            _buildChargeItem(
                'Equity Intraday', widget.broker.margins.equityIntraday),
            _buildChargeItem(
                'Equity Futures', widget.broker.margins.equityFutures),
            _buildChargeItem(
                'Equity Options', widget.broker.margins.equityOptions),
            _buildChargeItem(
                'Currency Futures', widget.broker.margins.currencyFutures),
            _buildChargeItem(
                'Currency Options', widget.broker.margins.currencyOptions),
            _buildChargeItem(
                'Commodity Futures', widget.broker.margins.commodityFutures),
            _buildChargeItem(
                'Commodity Options', widget.broker.margins.commodityOptions),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedChargesCard() {
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
              'Detailed Charges Breakdown',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            _buildChargeSection(
                'Delivery Trading', widget.broker.charges.delivery),
            const SizedBox(height: 14),
            _buildChargeSection(
                'Intraday Trading', widget.broker.charges.intraday),
            const SizedBox(height: 14),
            _buildChargeSection(
                'Futures Trading', widget.broker.charges.futures),
            const SizedBox(height: 14),
            _buildChargeSection(
                'Options Trading', widget.broker.charges.options),
          ],
        ),
      ),
    );
  }

  Widget _buildChargeSection(String title, dynamic charges) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          if (charges.transactionCharges != null) ...[
            _buildSubChargeItem(
                'BSE Transaction', charges.transactionCharges['BSE'] ?? 'N/A'),
            _buildSubChargeItem(
                'NSE Transaction', charges.transactionCharges['NSE'] ?? 'N/A'),
          ],
          _buildSubChargeItem(
              'Clearing Charges', charges.clearingCharges ?? 'N/A'),
          _buildSubChargeItem(
              'DP Charges', charges.dpCharges ?? charges.dpCharge ?? 'N/A'),
          _buildSubChargeItem('GST', charges.gst ?? 'N/A'),
          _buildSubChargeItem('STT', charges.stt ?? 'N/A'),
          _buildSubChargeItem('SEBI Charges', charges.sebiCharges ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildSubChargeItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 1,
            child: Text(
              value.isEmpty ? 'N/A' : value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.end,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChargeItem(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 120,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.end,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformsCard() {
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
              'Trading Platforms',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            ...widget.broker.platforms.map((platform) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.computer,
                      color: AppColors.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        platform,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesListCard() {
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
              'Key Features',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            ...widget.broker.features.map((feature) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.info.withOpacity(0.1),
                      AppColors.info.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.info.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: AppColors.info,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        feature,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalFeaturesCard() {
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
              'Additional Features',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            _buildFeatureToggle(
                '3-in-1 Account', widget.broker.additionalFeatures.account3in1),
            _buildFeatureToggle('Free Trading Calls',
                widget.broker.additionalFeatures.freeTradingCalls),
            _buildFeatureToggle(
                'Free Research', widget.broker.additionalFeatures.freeResearch),
            _buildFeatureToggle(
                'SMS Alerts', widget.broker.additionalFeatures.smsAlerts),
            _buildFeatureToggle('Margin Funding',
                widget.broker.additionalFeatures.marginFunding),
            _buildFeatureToggle('Margin Against Shares',
                widget.broker.additionalFeatures.marginAgainstShare),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureToggle(String label, bool isAvailable) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isAvailable
            ? AppColors.success.withOpacity(0.05)
            : AppColors.error.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isAvailable
              ? AppColors.success.withOpacity(0.2)
              : AppColors.error.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            isAvailable ? Icons.check_circle : Icons.cancel,
            color: isAvailable ? AppColors.success : AppColors.error,
            size: 20,
          ),
        ],
      ),
    );
  }

  void _shareBroker() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality will be implemented soon'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
