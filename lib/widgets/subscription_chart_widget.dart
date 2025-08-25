import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/ipo.dart';
import '../theme/app_theme.dart';

class SubscriptionChartWidget extends StatefulWidget {
  final Subscription subscription;
  final bool isLevelChart;

  const SubscriptionChartWidget({
    super.key,
    required this.subscription,
    required this.isLevelChart,
  });

  @override
  State<SubscriptionChartWidget> createState() =>
      _SubscriptionChartWidgetState();
}

class _SubscriptionChartWidgetState extends State<SubscriptionChartWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );
    _animationController.forward();
  }

  @override
  void didUpdateWidget(SubscriptionChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLevelChart != widget.isLevelChart) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Chart Content
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: widget.isLevelChart
              ? _buildLevelChart()
              : _buildDistributionChart(),
        ),
        const SizedBox(height: 16),
        // Legend
        _buildLegend(),
      ],
    );
  }

  Widget _buildLevelChart() {
    return Container(
      key: const ValueKey('level_chart'),
      height: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.05),
            AppColors.secondary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.bar_chart_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Subscription Levels',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: _getMaxValue() * 1.2,
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (group) => AppColors.surface,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                            '${_getCategoryName(group.x.toInt())}\n${rod.toY.toStringAsFixed(2)}x',
                            const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                _getCategoryShortName(value.toInt()),
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '${value.toStringAsFixed(1)}x',
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.textSecondary,
                              ),
                            );
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: _getMaxValue() / 4,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: AppColors.cardBorder.withOpacity(0.3),
                          strokeWidth: 1,
                        );
                      },
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: _buildBarGroups(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistributionChart() {
    return Container(
      key: const ValueKey('distribution_chart'),
      height: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            AppColors.secondary.withOpacity(0.05),
            AppColors.primary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.secondary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.pie_chart_rounded,
                  color: AppColors.secondary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Subscription Distribution',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            _selectedIndex = -1;
                            return;
                          }
                          _selectedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                    sections: _buildPieSections(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    final categories = _getSubscriptionCategories();
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: categories.asMap().entries.map((entry) {
        final index = entry.key;
        final category = entry.value;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: category['color'].withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: category['color'].withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: category['color'],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${category['name']}: ${category['value'].toStringAsFixed(2)}x',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: category['color'],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    final categories = _getSubscriptionCategories();
    return categories.asMap().entries.map((entry) {
      final index = entry.key;
      final category = entry.value;
      final animatedValue = category['value'] * _animation.value;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: animatedValue,
            color: category['color'],
            width: 24,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                category['color'],
                category['color'].withOpacity(0.7),
              ],
            ),
          ),
        ],
      );
    }).toList();
  }

  List<PieChartSectionData> _buildPieSections() {
    final categories = _getSubscriptionCategories();
    final total = categories.fold<double>(0, (sum, cat) => sum + cat['value']);

    if (total == 0) {
      return [
        PieChartSectionData(
          color: Colors.grey[300]!,
          value: 1,
          title: 'No Data',
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
          ),
        ),
      ];
    }

    return categories.asMap().entries.map((entry) {
      final index = entry.key;
      final category = entry.value;
      final isSelected = index == _selectedIndex;
      final percentage = (category['value'] / total * 100);
      final animatedValue = category['value'] * _animation.value;

      return PieChartSectionData(
        color: category['color'],
        value: animatedValue,
        title: isSelected ? '${percentage.toStringAsFixed(1)}%' : '',
        radius: isSelected ? 65 : 55,
        titleStyle: TextStyle(
          fontSize: isSelected ? 14 : 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            category['color'],
            category['color'].withOpacity(0.8),
          ],
        ),
      );
    }).toList();
  }

  List<Map<String, dynamic>> _getSubscriptionCategories() {
    final categories = <Map<String, dynamic>>[];

    if (widget.subscription.retail != null && widget.subscription.retail! > 0) {
      categories.add({
        'name': 'Retail',
        'value': widget.subscription.retail!,
        'color': AppColors.secondary,
      });
    }

    if (widget.subscription.hni != null && widget.subscription.hni! > 0) {
      categories.add({
        'name': 'HNI',
        'value': widget.subscription.hni!,
        'color': AppColors.warning,
      });
    }

    if (widget.subscription.qib != null && widget.subscription.qib! > 0) {
      categories.add({
        'name': 'QIB',
        'value': widget.subscription.qib!,
        'color': AppColors.info,
      });
    }

    if (widget.subscription.employee != null &&
        widget.subscription.employee! > 0) {
      categories.add({
        'name': 'Employee',
        'value': widget.subscription.employee!,
        'color': AppColors.success,
      });
    }

    return categories;
  }

  double _getMaxValue() {
    final categories = _getSubscriptionCategories();
    if (categories.isEmpty) return 1.0;
    return categories
        .map((cat) => cat['value'] as double)
        .reduce((a, b) => a > b ? a : b);
  }

  String _getCategoryName(int index) {
    final categories = _getSubscriptionCategories();
    if (index >= 0 && index < categories.length) {
      return categories[index]['name'];
    }
    return '';
  }

  String _getCategoryShortName(int index) {
    final categories = _getSubscriptionCategories();
    if (index >= 0 && index < categories.length) {
      final name = categories[index]['name'];
      switch (name) {
        case 'Employee':
          return 'EMP';
        default:
          return name;
      }
    }
    return '';
  }
}
