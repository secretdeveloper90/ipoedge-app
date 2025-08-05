import 'package:flutter/material.dart';
import '../models/ipo_model.dart';
import '../services/firebase_ipo_service.dart';
import '../theme/app_theme.dart';
import '../widgets/ipo_card.dart';
import '../widgets/loading_shimmer.dart';
import 'ipo_detail_screen.dart';

class IPOListScreen extends StatefulWidget {
  final String category;

  const IPOListScreen({
    super.key,
    required this.category,
  });

  @override
  State<IPOListScreen> createState() => _IPOListScreenState();
}

class _IPOListScreenState extends State<IPOListScreen> {
  List<IPO> _ipos = [];
  bool _isLoading = true;
  String _error = '';

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
      if (widget.category == 'all') {
        ipos = await FirebaseIPOService.getAllIPOs();
      } else {
        ipos = await FirebaseIPOService.getIPOsByCategory(widget.category);
      }

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

  String _getAppBarTitle() {
    switch (widget.category) {
      case 'all':
        return 'IPO Edge';
      case 'mainboard':
        return 'Mainboard IPOs';
      case 'sme':
        return 'SME IPOs';
      default:
        return 'IPOs';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle()),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadIPOs,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
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
              'No IPOs found',
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
