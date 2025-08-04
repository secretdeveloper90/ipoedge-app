import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_theme.dart';

class NewsCard extends StatelessWidget {
  final Map<String, dynamic> newsItem;
  final VoidCallback? onTap;

  const NewsCard({
    super.key,
    required this.newsItem,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: AppColors.primary.withOpacity(0.04),
          highlightColor: AppColors.primary.withOpacity(0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNewsImage(),
              _buildNewsContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewsImage() {
    // Generate a placeholder image URL based on the sector
    final String imageUrl = _getImageForSector(newsItem['sector'] ?? '');

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      child: Container(
        height: 200,
        width: double.infinity,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withOpacity(0.1),
                  AppColors.primary.withOpacity(0.05),
                ],
              ),
            ),
            child: Center(
              child: Icon(
                _getIconForSector(newsItem['sector'] ?? ''),
                size: 48,
                color: AppColors.primary.withOpacity(0.6),
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withOpacity(0.1),
                  AppColors.primary.withOpacity(0.05),
                ],
              ),
            ),
            child: Center(
              child: Icon(
                _getIconForSector(newsItem['sector'] ?? ''),
                size: 48,
                color: AppColors.primary.withOpacity(0.6),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNewsContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectorTag(),
          const SizedBox(height: 12),
          _buildHeadline(),
          const SizedBox(height: 8),
          _buildDateAndSource(),
          const SizedBox(height: 12),
          _buildSummary(),
          const SizedBox(height: 12),
          _buildImpact(),
        ],
      ),
    );
  }

  Widget _buildSectorTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _getSectorColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getSectorColor().withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        newsItem['sector'] ?? 'General',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: _getSectorColor(),
        ),
      ),
    );
  }

  Widget _buildHeadline() {
    return Text(
      newsItem['headline'] ?? '',
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.3,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDateAndSource() {
    return Row(
      children: [
        Icon(
          Icons.schedule_rounded,
          size: 14,
          color: AppColors.textSecondary.withOpacity(0.8),
        ),
        const SizedBox(width: 4),
        Text(
          _formatDate(newsItem['date'] ?? ''),
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 12),
        Icon(
          Icons.article_rounded,
          size: 14,
          color: AppColors.textSecondary.withOpacity(0.8),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            newsItem['source'] ?? '',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildSummary() {
    return Text(
      newsItem['summary'] ?? '',
      style: const TextStyle(
        fontSize: 14,
        color: AppColors.textSecondary,
        height: 1.4,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildImpact() {
    final impact = newsItem['impact'] ?? '';
    if (impact.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.cardBorder.withOpacity(0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: _getImpactColor().withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              _getImpactIcon(),
              size: 14,
              color: _getImpactColor(),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              impact,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _getImageForSector(String sector) {
    // Return placeholder images based on sector
    switch (sector.toLowerCase()) {
      case 'energy / renewables':
      case 'energy':
        return 'https://images.unsplash.com/photo-1466611653911-95081537e5b7?w=400&h=200&fit=crop';
      case 'it services':
        return 'https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=400&h=200&fit=crop';
      case 'banking / fintech':
      case 'banking':
        return 'https://images.unsplash.com/photo-1563013544-824ae1b704d3?w=400&h=200&fit=crop';
      case 'conglomerate / energy':
        return 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=400&h=200&fit=crop';
      case 'tech / food delivery':
        return 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=200&fit=crop';
      case 'automobile / ev':
        return 'https://images.unsplash.com/photo-1593941707882-a5bac6861d75?w=400&h=200&fit=crop';
      case 'fmcg':
        return 'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=400&h=200&fit=crop';
      case 'index summary':
        return 'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?w=400&h=200&fit=crop';
      default:
        return 'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?w=400&h=200&fit=crop';
    }
  }

  IconData _getIconForSector(String sector) {
    switch (sector.toLowerCase()) {
      case 'energy / renewables':
      case 'energy':
        return Icons.energy_savings_leaf_rounded;
      case 'it services':
        return Icons.computer_rounded;
      case 'banking / fintech':
      case 'banking':
        return Icons.account_balance_rounded;
      case 'conglomerate / energy':
        return Icons.business_rounded;
      case 'tech / food delivery':
        return Icons.delivery_dining_rounded;
      case 'automobile / ev':
        return Icons.electric_car_rounded;
      case 'fmcg':
        return Icons.shopping_basket_rounded;
      case 'index summary':
        return Icons.trending_up_rounded;
      default:
        return Icons.article_rounded;
    }
  }

  Color _getSectorColor() {
    final sector = newsItem['sector'] ?? '';
    switch (sector.toLowerCase()) {
      case 'energy / renewables':
      case 'energy':
        return const Color(0xFF4CAF50);
      case 'it services':
        return const Color(0xFF2196F3);
      case 'banking / fintech':
      case 'banking':
        return const Color(0xFF1565C0);
      case 'conglomerate / energy':
        return const Color(0xFF795548);
      case 'tech / food delivery':
        return const Color(0xFFFF5722);
      case 'automobile / ev':
        return const Color(0xFF9C27B0);
      case 'fmcg':
        return const Color(0xFFFF9800);
      case 'index summary':
        return const Color(0xFF607D8B);
      default:
        return AppColors.primary;
    }
  }

  Color _getImpactColor() {
    final impact = newsItem['impact'] ?? '';
    if (impact.contains('rose') ||
        impact.contains('gained') ||
        impact.contains('surged') ||
        impact.contains('up ')) {
      return AppColors.success;
    } else if (impact.contains('fell') ||
        impact.contains('dropped') ||
        impact.contains('declined')) {
      return AppColors.error;
    }
    return AppColors.textSecondary;
  }

  IconData _getImpactIcon() {
    final impact = newsItem['impact'] ?? '';
    if (impact.contains('rose') ||
        impact.contains('gained') ||
        impact.contains('surged') ||
        impact.contains('up ')) {
      return Icons.trending_up_rounded;
    } else if (impact.contains('fell') ||
        impact.contains('dropped') ||
        impact.contains('declined')) {
      return Icons.trending_down_rounded;
    }
    return Icons.info_outline_rounded;
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final difference = now.difference(date).inDays;

      if (difference == 0) {
        return 'Today';
      } else if (difference == 1) {
        return 'Yesterday';
      } else if (difference < 7) {
        return '$difference days ago';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return dateStr;
    }
  }
}
