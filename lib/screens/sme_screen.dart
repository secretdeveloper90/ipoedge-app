import 'package:flutter/material.dart';
import '../models/ipo_model.dart';
import '../services/ipo_service.dart';
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
  final IPOService _ipoService = IPOService();

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
      appBar: CommonAppBar(
        title: 'SME IPOs',
        showSearch: true,
        searchType: SearchType.sme,
        searchHint: 'Search SME IPOs...',
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                indicatorPadding: const EdgeInsets.all(4),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: AppColors.primary,
                unselectedLabelColor: Colors.white.withOpacity(0.8),
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  letterSpacing: 0.5,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  letterSpacing: 0.3,
                ),
                dividerColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                tabs: const [
                  Tab(
                    height: 56,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.storefront_rounded, size: 20),
                        SizedBox(height: 4),
                        Text('CURRENT'),
                      ],
                    ),
                  ),
                  Tab(
                    height: 56,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.schedule_rounded, size: 20),
                        SizedBox(height: 4),
                        Text('UPCOMING'),
                      ],
                    ),
                  ),
                  Tab(
                    height: 56,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.list_alt_rounded, size: 20),
                        SizedBox(height: 4),
                        Text('LISTED'),
                      ],
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
          SMEIPOStatusListView(
            category: 'sme',
            status: 'current',
            ipoService: _ipoService,
          ),
          SMEIPOStatusListView(
            category: 'sme',
            status: 'upcoming',
            ipoService: _ipoService,
          ),
          SMEIPOStatusListView(
            category: 'sme',
            status: 'listed',
            ipoService: _ipoService,
          ),
        ],
      ),
    );
  }
}

class SMEIPOStatusListView extends StatefulWidget {
  final String category;
  final String status;
  final IPOService ipoService;

  const SMEIPOStatusListView({
    super.key,
    required this.category,
    required this.status,
    required this.ipoService,
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
      final ipos = await widget.ipoService.getIPOsByCategoryAndStatus(
        widget.category,
        widget.status,
      );

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
