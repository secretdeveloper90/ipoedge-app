import 'package:flutter/material.dart';
import '../models/buyback_model.dart';
import '../theme/app_theme.dart';

class BuybackDetailScreen extends StatefulWidget {
  final Buyback buyback;

  const BuybackDetailScreen({
    Key? key,
    required this.buyback,
  }) : super(key: key);

  @override
  State<BuybackDetailScreen> createState() => _BuybackDetailScreenState();
}

class _BuybackDetailScreenState extends State<BuybackDetailScreen>
    with SingleTickerProviderStateMixin {
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
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Details'),
                Tab(text: 'Timeline'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildDetailsTab(),
                _buildTimelineTab(),
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
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Navigation button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 24),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(), // Empty space to maintain layout
                ],
              ),
              const SizedBox(height: 24),
              // Company logo and info section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    // Company logo
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          widget.buyback.logo,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.business,
                              size: 32,
                              color: Colors.grey,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Company info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.buyback.companyName,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(widget.buyback.status),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          _getStatusColor(widget.buyback.status)
                                              .withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  widget.buyback.statusDisplayName,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.buyback.methodDisplayName,
                            style: const TextStyle(
                              fontSize: 14,
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
              const SizedBox(height: 20),
              // Key metrics row
              Row(
                children: [
                  Expanded(
                    child: _buildHeaderMetric(
                      '₹ Buyback Price',
                      widget.buyback.formattedBuybackPrice,
                    ),
                  ),
                  Expanded(
                    child: _buildHeaderMetric(
                      '📊 Issue Size',
                      widget.buyback.issueSize,
                    ),
                  ),
                  Expanded(
                    child: _buildHeaderMetric(
                      '📈 Percentage',
                      widget.buyback.formattedPercentage,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'upcoming':
        return AppColors.warning;
      case 'open':
        return AppColors.success;
      case 'closed':
        return AppColors.error;
      default:
        return AppColors.info;
    }
  }

  Widget _buildMetricItem(
      String label, String value, Color color, IconData icon) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
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
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: color),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
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
              fontSize: 16,
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

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildKeyMetricsCard(),
          const SizedBox(height: 16),
          _buildCompanyInfoCard(),
          const SizedBox(height: 16),
          _buildBuybackMethodCard(),
        ],
      ),
    );
  }

  Widget _buildKeyMetricsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Key Metrics',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    'Buyback Price',
                    widget.buyback.formattedBuybackPrice,
                    AppColors.primary,
                    Icons.currency_rupee,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricItem(
                    'Issue Size',
                    widget.buyback.issueSize,
                    AppColors.secondary,
                    Icons.account_balance_wallet,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    'Shares Count',
                    widget.buyback.formattedSharesCount,
                    AppColors.warning,
                    Icons.pie_chart,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricItem(
                    'Percentage',
                    widget.buyback.formattedPercentage,
                    AppColors.info,
                    Icons.percent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSharesDetailsCard(),
          const SizedBox(height: 16),
          _buildFinancialDetailsCard(),
        ],
      ),
    );
  }

  Widget _buildTimelineTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildTimelineCard(),
        ],
      ),
    );
  }

  Widget _buildCompanyInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.business, color: AppColors.primary, size: 24),
                SizedBox(width: 8),
                Text(
                  'Company Information',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Company Name', widget.buyback.companyName),
            const SizedBox(height: 12),
            _buildInfoRow('Status', widget.buyback.statusDisplayName),
            const SizedBox(height: 12),
            _buildInfoRow('Method', widget.buyback.methodDisplayName),
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
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const Text(
          ': ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBuybackMethodCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.business_center,
                    color: AppColors.secondary, size: 24),
                SizedBox(width: 8),
                Text(
                  'Buyback Method',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    widget.buyback.method.toLowerCase() == 'tender'
                        ? Icons.gavel
                        : Icons.store,
                    color: AppColors.secondary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.buyback.methodDisplayName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.buyback.method.toLowerCase() == 'tender'
                              ? 'Shareholders can tender their shares at the specified price'
                              : 'Company will buy shares from the open market',
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
        ),
      ),
    );
  }

  Widget _buildSharesDetailsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.pie_chart, color: AppColors.warning, size: 24),
                SizedBox(width: 8),
                Text(
                  'Shares Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
                'Total Shares', widget.buyback.sharesCount.toString()),
            const SizedBox(height: 12),
            _buildInfoRow(
                'Formatted Count', widget.buyback.formattedSharesCount),
            const SizedBox(height: 12),
            _buildInfoRow(
                'Percentage of Capital', widget.buyback.formattedPercentage),
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
                  const Icon(Icons.info_outline,
                      color: AppColors.info, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'This represents ${widget.buyback.formattedPercentage} of the company\'s total share capital.',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
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

  Widget _buildFinancialDetailsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.account_balance_wallet,
                    color: AppColors.success, size: 24),
                SizedBox(width: 8),
                Text(
                  'Financial Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Buyback Price per Share',
                widget.buyback.formattedBuybackPrice),
            const SizedBox(height: 12),
            _buildInfoRow('Total Issue Size', widget.buyback.issueSize),
            const SizedBox(height: 16),
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
                      Icon(Icons.calculate, color: AppColors.success, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Calculation',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Total Value = ${widget.buyback.formattedSharesCount} shares × ${widget.buyback.formattedBuybackPrice}',
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
    );
  }

  Widget _buildTimelineCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.timeline, color: AppColors.primary, size: 24),
                SizedBox(width: 8),
                Text(
                  'Buyback Timeline',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (widget.buyback.recordDate != null ||
                widget.buyback.issueDate != null ||
                widget.buyback.closeDate != null) ...[
              _buildTimelineItem(
                'Record Date',
                widget.buyback.recordDate,
                Icons.event_note,
                AppColors.info,
                'Date to determine eligible shareholders',
              ),
              if (widget.buyback.issueDate != null) ...[
                const SizedBox(height: 16),
                _buildTimelineItem(
                  'Issue Date',
                  widget.buyback.issueDate,
                  Icons.play_arrow,
                  AppColors.success,
                  'Buyback offer opens',
                ),
              ],
              if (widget.buyback.closeDate != null) ...[
                const SizedBox(height: 16),
                _buildTimelineItem(
                  'Close Date',
                  widget.buyback.closeDate,
                  Icons.stop,
                  AppColors.error,
                  'Buyback offer closes',
                ),
              ],
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
                        'Timeline details will be available soon.',
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

  Widget _buildTimelineItem(
    String title,
    String? date,
    IconData icon,
    Color color,
    String description,
  ) {
    if (date == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(date),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
}
