import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_app_bar.dart';
import '../widgets/broker_card.dart';
import '../widgets/loading_shimmer.dart';
import '../models/broker.dart';
import '../services/firebase_broker_service.dart';
import 'broker_detail_screen.dart';

class BrokersScreen extends StatefulWidget {
  const BrokersScreen({super.key});

  @override
  State<BrokersScreen> createState() => _BrokersScreenState();
}

class _BrokersScreenState extends State<BrokersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const CommonAppBar(
        title: 'Brokers',
      ),
      body: _buildBrokersList('all'),
    );
  }

  Widget _buildBrokersList(String category) {
    return FutureBuilder<List<Broker>>(
      future: _loadBrokers(category),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 3,
            itemBuilder: (context, index) {
              return const LoadingShimmer(
                isLoading: true,
                child: BrokerShimmerCard(),
              );
            },
          );
        }

        if (snapshot.hasError) {
          return _buildErrorState();
        }

        final brokers = snapshot.data ?? [];

        if (brokers.isEmpty) {
          return _buildEmptyState(category);
        }

        return RefreshIndicator(
          onRefresh: () => _loadBrokers(category),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: brokers.length,
            itemBuilder: (context, index) {
              final broker = brokers[index];
              return BrokerCard(
                broker: broker,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BrokerDetailScreen(broker: broker),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Future<List<Broker>> _loadBrokers(String category) async {
    if (category == 'all') {
      return await FirebaseBrokerService.getAllBrokers();
    } else {
      return await FirebaseBrokerService.getBrokersByType(category);
    }
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 64,
            color: AppColors.error.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'Failed to load brokers',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Please check your connection and try again',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => setState(() {}),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String category) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.business_rounded,
            size: 64,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No ${category == 'all' ? '' : category} brokers found',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'We\'re working on adding more brokers to our platform',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
