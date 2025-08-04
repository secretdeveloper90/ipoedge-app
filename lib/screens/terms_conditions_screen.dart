import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/drawer_service.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        DrawerService().openDrawer();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Terms & Conditions'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildLastUpdated(),
              const SizedBox(height: 20),
              _buildSection(
                'Acceptance of Terms',
                'By accessing and using the IPO Edge mobile application, you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to abide by the above, please do not use this service.',
              ),
              _buildSection(
                'Use License',
                'Permission is granted to temporarily download one copy of IPO Edge app for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title, and under this license you may not modify or copy the materials.',
              ),
              _buildSection(
                'Disclaimer',
                'The information on IPO Edge is provided on an "as is" basis. To the fullest extent permitted by law, this Company excludes all representations, warranties, conditions and terms whether express or implied.',
              ),
              _buildSection(
                'Investment Risks',
                'All investments involve risk, including the potential loss of principal. IPO Edge provides information for educational purposes only and does not constitute investment advice. Please consult with a qualified financial advisor before making investment decisions.',
              ),
              _buildSection(
                'Accuracy of Information',
                'While we strive to provide accurate and up-to-date information about IPOs, market conditions can change rapidly. We do not guarantee the accuracy, completeness, or timeliness of any information provided through our app.',
              ),
              _buildSection(
                'User Responsibilities',
                'Users are responsible for maintaining the confidentiality of their account information and for all activities that occur under their account. You agree to notify us immediately of any unauthorized use of your account.',
              ),
              _buildSection(
                'Prohibited Uses',
                'You may not use our app for any unlawful purpose or to solicit others to perform unlawful acts. You may not violate any local, state, national, or international law or regulation.',
              ),
              _buildSection(
                'Limitation of Liability',
                'In no event shall IPO Edge or its suppliers be liable for any damages (including, without limitation, damages for loss of data or profit, or due to business interruption) arising out of the use or inability to use the app.',
              ),
              _buildSection(
                'Modifications',
                'IPO Edge may revise these terms of service at any time without notice. By using this app, you are agreeing to be bound by the then current version of these terms of service.',
              ),
              const SizedBox(height: 24),
              _buildContactInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.gavel_rounded,
            size: 40,
            color: Colors.white,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Terms & Conditions',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Please read these terms carefully before using our app',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLastUpdated() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.warning.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.update_rounded,
            size: 16,
            color: AppColors.warning,
          ),
          SizedBox(width: 8),
          Text(
            'Last Updated: July 15, 2025',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.warning,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.cardBorder.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Questions About Terms?',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'If you have any questions about these Terms & Conditions, please contact us at legal@ipoedge.com or through our Contact Us page.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
