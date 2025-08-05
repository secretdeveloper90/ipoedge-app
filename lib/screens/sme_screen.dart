import 'package:flutter/material.dart';
import '../models/ipo_model.dart';
import '../services/firebase_ipo_service.dart';
import '../theme/app_theme.dart';
import '../widgets/ipo_card.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/common_app_bar.dart';
import 'ipo_detail_screen.dart';

class SMEScreen extends StatefulWidget {
  const SMEScreen({super.key});

  @override
  State<SMEScreen> createState() => _SMEScreenState();
}

class _SMEScreenState extends State<SMEScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
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
        title: 'SME IPOs',
        showSearch: true,
        searchType: SearchType.sme,
        searchHint: 'Search SME IPOs...',
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
                        'CURRENT',
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
                        'UPCOMING',
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
                        'LISTED',
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
          const SMEIPOStatusListView(
            category: 'sme',
            status: 'current',
          ),
          const SMEIPOStatusListView(
            category: 'sme',
            status: 'upcoming',
          ),
          const SMEIPOStatusListView(
            category: 'sme',
            status: 'listed',
          ),
        ],
      ),
    );
  }
}

class SMEIPOStatusListView extends StatefulWidget {
  final String category;
  final String status;

  const SMEIPOStatusListView({
    super.key,
    required this.category,
    required this.status,
  });

  @override
  State<SMEIPOStatusListView> createState() => _SMEIPOStatusListViewState();
}

class _SMEIPOStatusListViewState extends State<SMEIPOStatusListView>
    with AutomaticKeepAliveClientMixin {
  List<IPO> _ipos = [];
  bool _isLoading = true;
  String _error = '';

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadIPOs();
  }

  Future<void> _loadIPOs() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      List<IPO> ipos;

      // Get IPOs by category first
      final allIPOs =
          await FirebaseIPOService.getIPOsByCategory(widget.category);

      // Filter by status
      ipos = allIPOs
          .where(
              (ipo) => ipo.status.toLowerCase() == widget.status.toLowerCase())
          .toList();

      setState(() {
        _ipos = ipos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load IPOs: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_isLoading) {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 3,
        itemBuilder: (context, index) {
          return const LoadingShimmer(
            isLoading: true,
            child: ShimmerCard(),
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
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              _error,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadIPOs,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_ipos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.inbox_outlined,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'No ${widget.status} IPOs found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Check back later for new IPO listings',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadIPOs,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _ipos.length,
        itemBuilder: (context, index) {
          final ipo = _ipos[index];
          return IPOCard(
            ipo: ipo,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => IPODetailScreen(ipo: ipo),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
