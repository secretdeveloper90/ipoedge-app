import 'package:flutter/material.dart';
import '../widgets/common_app_bar.dart';
import '../widgets/news_card.dart';
import '../widgets/loading_shimmer.dart';
import '../services/firebase_news_service.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _newsData = [];
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final newsData = await FirebaseNewsService.getAllNews();
      if (mounted) {
        setState(() {
          _newsData = newsData;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load news: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(
        title: 'Market News',
      ),
      body: _buildNewsList(),
    );
  }

  Widget _buildNewsList() {
    if (_isLoading) {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 3,
        itemBuilder: (context, index) {
          return const LoadingShimmer(
            isLoading: true,
            child: NewsShimmerCard(),
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

    if (_newsData.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.article_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No news available',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Check back later for the latest market news',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: _newsData.length,
          itemBuilder: (context, index) {
            final newsItem = _newsData[index];
            return NewsCard(
              newsItem: newsItem,
              onTap: () => _onNewsItemTap(newsItem),
            );
          },
        ),
      ),
    );
  }

  void _onNewsItemTap(Map<String, dynamic> newsItem) {
    // Handle news item tap - could navigate to detail screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tapped: ${newsItem['headline']}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
