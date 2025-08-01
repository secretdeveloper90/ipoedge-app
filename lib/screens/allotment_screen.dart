import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_app_bar.dart';

class AllotmentScreen extends StatefulWidget {
  const AllotmentScreen({super.key});

  @override
  State<AllotmentScreen> createState() => _AllotmentScreenState();
}

class _AllotmentScreenState extends State<AllotmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(
        title: 'Allotment Status',
      ),
      body: _buildAllotmentList('allotment'),
    );
  }

  Widget _buildAllotmentList(String status) {
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
                  _getStatusIcon(status),
                  size: 64,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: 16),
                Text(
                  _getStatusTitle(status),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _getStatusDescription(status),
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

  IconData _getStatusIcon(String status) {
    return Icons.assignment_rounded;
  }

  String _getStatusTitle(String status) {
    return 'Allotment Status';
  }

  String _getStatusDescription(String status) {
    return 'Check your IPO allotment status, track applications, and view allocation results here.';
  }
}
