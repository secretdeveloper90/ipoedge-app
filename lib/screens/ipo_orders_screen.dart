import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/ipo_order.dart';
import '../services/ipo_order_service.dart';
import '../widgets/common_ipo_order_card.dart';

class IpoOrdersScreen extends StatefulWidget {
  const IpoOrdersScreen({super.key});

  @override
  State<IpoOrdersScreen> createState() => _IpoOrdersScreenState();
}

class _IpoOrdersScreenState extends State<IpoOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<IpoOrder> _currentOrders = [];
  List<IpoOrder> _pastOrders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializeData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    // Add demo data if no orders exist
    await IpoOrderService.instance.addDemoData();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final currentOrders = await IpoOrderService.instance.getCurrentOrders();
      final pastOrders = await IpoOrderService.instance.getPastOrders();
      
      setState(() {
        _currentOrders = currentOrders;
        _pastOrders = pastOrders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'IPO Orders/Bids',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          tabs: [
            Tab(
              text: 'Current (${_currentOrders.length})',
            ),
            Tab(
              text: 'Past (${_pastOrders.length})',
            ),
          ],
        ),
      ),
      body: Container(
        color: AppColors.background,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildCurrentOrdersTab(),
            _buildPastOrdersTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentOrdersTab() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_currentOrders.isEmpty) {
      return _buildEmptyState(
        icon: Icons.hourglass_empty_rounded,
        title: 'No Current Orders',
        subtitle: 'You don\'t have any pending IPO applications',
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Current Applications', _currentOrders.length),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _currentOrders.length,
              itemBuilder: (context, index) {
                return CommonIpoOrderCard(
                  order: _currentOrders[index],
                  isCompact: true,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPastOrdersTab() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_pastOrders.isEmpty) {
      return _buildEmptyState(
        icon: Icons.history_rounded,
        title: 'No Past Orders',
        subtitle: 'Your completed IPO applications will appear here',
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Order History', _pastOrders.length),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _pastOrders.length,
              itemBuilder: (context, index) {
                return CommonIpoOrderCard(
                  order: _pastOrders[index],
                  isCompact: true,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Row(
      children: [
        Icon(
          Icons.receipt_long_rounded,
          color: AppColors.primary,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
