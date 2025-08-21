import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/firebase_buyback_service.dart';
import '../models/buyback_model.dart';
import '../widgets/buyback_card.dart';

class BuybackSearchDelegate extends SearchDelegate<String> {
  List<Buyback> _allBuybacks = [];
  bool _isLoaded = false;

  Future<List<Buyback>> get allBuybacks async {
    if (!_isLoaded) {
      _allBuybacks = await FirebaseBuybackService.getAllBuybacks();
      _isLoaded = true;
    }
    return _allBuybacks;
  }

  @override
  String get searchFieldLabel => 'Search buybacks...';

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white70),
        border: InputBorder.none,
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Buyback>>(
      future: FirebaseBuybackService.searchBuybacks(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return _buildEmptyState('Error searching buybacks');
        }

        final results = snapshot.data ?? [];
        if (results.isEmpty) {
          return _buildEmptyState('No buybacks found for "$query"');
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: results.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: BuybackCard(buyback: results[index]),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<Buyback>>(
      future: query.isEmpty
          ? allBuybacks.then((buybacks) => buybacks.take(5).toList())
          : FirebaseBuybackService.searchBuybacks(query)
              .then((results) => results.take(5).toList()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return _buildEmptyState('Error loading suggestions');
        }

        final suggestions = snapshot.data ?? [];

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final buyback = suggestions[index];
            return ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    buyback.logo,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/images/ipo-edge-logo.jpeg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppColors.primary.withOpacity(0.1),
                              child: const Icon(
                                Icons.business,
                                color: AppColors.primary,
                                size: 20,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              title: Text(buyback.companyName),
              subtitle: Text(
                  '${buyback.statusDisplayName} • ${buyback.formattedBuybackPrice}'),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(buyback.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getStatusColor(buyback.status).withOpacity(0.3),
                  ),
                ),
                child: Text(
                  buyback.statusDisplayName,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(buyback.status),
                  ),
                ),
              ),
              onTap: () {
                query = buyback.companyName;
                showResults(context);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 64,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Try searching with different keywords',
            style: TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'upcoming':
        return AppColors.info;
      case 'open':
        return AppColors.success;
      case 'closed':
        return AppColors.textSecondary;
      default:
        return AppColors.textSecondary;
    }
  }
}
