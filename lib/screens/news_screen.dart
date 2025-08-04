import 'package:flutter/material.dart';
import '../widgets/common_app_bar.dart';
import '../widgets/news_card.dart';
import '../widgets/loading_shimmer.dart';
import '../data/mock_news_data.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Simulate loading delay for demonstration
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
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

    return Container(
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: mockNewsData.length,
        itemBuilder: (context, index) {
          final newsItem = mockNewsData[index];
          return NewsCard(
            newsItem: newsItem,
            onTap: () => _onNewsItemTap(newsItem),
          );
        },
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
