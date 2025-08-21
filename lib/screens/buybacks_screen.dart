import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_app_bar.dart';
import '../widgets/buyback_search.dart';
import '../widgets/buyback_card.dart';
import '../widgets/loading_shimmer.dart';
import '../services/firebase_buyback_service.dart';
import '../models/buyback_model.dart';

class BuybacksScreen extends StatefulWidget {
  const BuybacksScreen({super.key});

  @override
  State<BuybacksScreen> createState() => _BuybacksScreenState();
}

class _BuybacksScreenState extends State<BuybacksScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  List<Buyback> _allBuybacks = [];
  String _error = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final buybacks = await FirebaseBuybackService.getAllBuybacks();

      if (mounted) {
        setState(() {
          _allBuybacks = buybacks;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load buybacks: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Buybacks',
        showSearch: true,
        searchType: SearchType.buybacks,
        searchHint: 'Search buybacks...',
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {
              showSearch(
                context: context,
                delegate: BuybackSearchDelegate(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Refresh',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.25),
                  Colors.white.withOpacity(0.15),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 24,
                  offset: const Offset(0, 6),
                  spreadRadius: -2,
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.1),
                  blurRadius: 1,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.white, Color(0xFFF8F9FA)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                      spreadRadius: -1,
                    ),
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                indicatorPadding: const EdgeInsets.all(4),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: AppColors.primary,
                unselectedLabelColor: Colors.white.withOpacity(0.85),
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                  letterSpacing: 0.3,
                  height: 1.1,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 9,
                  letterSpacing: 0.2,
                  height: 1.1,
                ),
                dividerColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                tabs: [
                  Tab(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      child: const Text(
                        'ACTIVE',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      child: const Text(
                        'CLOSED',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBuybacksList('current_upcoming'),
          _buildBuybacksList('closed'),
        ],
      ),
    );
  }

  Widget _buildBuybacksList(String status) {
    if (_isLoading) {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 3,
        itemBuilder: (context, index) {
          return const LoadingShimmer(
            isLoading: true,
            child: BuybackShimmerCard(),
          );
        },
      );
    }

    if (_error.isNotEmpty) {
      return Center(
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
              onPressed: _loadData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    List<Buyback> buybacks;

    if (status == 'current_upcoming') {
      buybacks = _allBuybacks
          .where((buyback) =>
              buyback.status.toLowerCase() == 'upcoming' ||
              buyback.status.toLowerCase() == 'open')
          .toList();
    } else {
      buybacks = _allBuybacks
          .where((buyback) => buyback.status.toLowerCase() == 'closed')
          .toList();
    }

    if (buybacks.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                children: [
                  Icon(
                    status == 'current_upcoming'
                        ? Icons.trending_up_rounded
                        : Icons.history_rounded,
                    size: 64,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    status == 'current_upcoming'
                        ? 'No Active Buybacks'
                        : 'No Closed Buybacks',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    status == 'current_upcoming'
                        ? 'There are currently no active or upcoming buybacks available.'
                        : 'No closed buybacks to display at the moment.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
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

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: buybacks.length,
        itemBuilder: (context, index) {
          return BuybackCard(buyback: buybacks[index]);
        },
      ),
    );
  }
}
