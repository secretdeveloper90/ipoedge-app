import 'package:flutter/material.dart';
import '../models/ipo_order.dart';
import '../services/ipo_order_service.dart';
import '../theme/app_theme.dart';
import '../screens/ipo_orders_screen.dart';
import 'common_ipo_order_card.dart';

class ProfileIpoOrdersWidget extends StatefulWidget {
  const ProfileIpoOrdersWidget({super.key});

  @override
  State<ProfileIpoOrdersWidget> createState() => _ProfileIpoOrdersWidgetState();
}

class _ProfileIpoOrdersWidgetState extends State<ProfileIpoOrdersWidget> {
  List<IpoOrder> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
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
      final orders = await IpoOrderService.instance.getRecentOrders(limit: 2);
      setState(() {
        _orders = orders;
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
    return Column(
      children: [
        _buildHeader(),
        const SizedBox(height: 16),
        if (_isLoading)
          _buildLoadingState()
        else if (_orders.isEmpty)
          _buildEmptyState()
        else
          _buildOrdersList(),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          Icons.receipt_long_rounded,
          color: AppColors.primary,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          _orders.isNotEmpty 
              ? 'IPO Orders/Bids (${_orders.length}+)'
              : 'IPO Orders/Bids',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const Spacer(),
        if (_orders.isNotEmpty)
          Container(
            height: 28,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.secondary,
                  AppColors.secondary.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondary.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.cardBorder,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 48,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 16),
              Text(
                'No IPO Orders',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your IPO applications will appear here',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _navigateToOrdersList,
            icon: const Icon(Icons.visibility_rounded),
            label: const Text('View Orders'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.secondary,
              side: BorderSide(color: AppColors.secondary),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrdersList() {
    return Column(
      children: [
        ...(_orders.map((order) => CommonIpoOrderCard(
              order: order,
              isCompact: true,
            ))),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _navigateToOrdersList,
            icon: const Icon(Icons.visibility_rounded),
            label: const Text('View All Orders'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.secondary,
              side: BorderSide(color: AppColors.secondary),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _navigateToOrdersList() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const IpoOrdersScreen(),
      ),
    );

    // Refresh orders when returning from orders list
    _loadOrders();
  }
}
