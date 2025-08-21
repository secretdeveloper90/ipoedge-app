import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../models/ipo.dart';

class IPOTimeline extends StatelessWidget {
  final ImportantDates importantDates;
  final String status;

  const IPOTimeline({
    super.key,
    required this.importantDates,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final timelineData = _buildTimelineData();

    if (timelineData.isEmpty) {
      return const SizedBox.shrink();
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 400;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      padding: const EdgeInsets.all(6),
      child: _buildHorizontalTimeline(timelineData, isCompact),
    );
  }

  List<TimelineItemData> _buildTimelineData() {
    final items = <TimelineItemData>[];

    if (importantDates.openDate != null) {
      items.add(TimelineItemData(
        title: 'Open',
        date: importantDates.openDate!,
        icon: Icons.play_circle_outline,
        isCompleted: _isDatePassed(importantDates.openDate!),
        isCurrent: _isCurrentPhase('open'),
      ));
    }

    if (importantDates.closeDate != null) {
      items.add(TimelineItemData(
        title: 'Close',
        date: importantDates.closeDate!,
        icon: Icons.stop_circle_outlined,
        isCompleted: _isDatePassed(importantDates.closeDate!),
        isCurrent: _isCurrentPhase('close'),
      ));
    }

    if (importantDates.allotmentDate != null) {
      items.add(TimelineItemData(
        title: 'Allotment*',
        date: importantDates.allotmentDate!,
        icon: Icons.assignment_turned_in,
        isCompleted: _isDatePassed(importantDates.allotmentDate!),
        isCurrent: _isCurrentPhase('allotment'),
      ));
    }

    if (importantDates.listingDate != null) {
      items.add(TimelineItemData(
        title: 'Listing*',
        date: importantDates.listingDate!,
        icon: Icons.trending_up,
        isCompleted: _isDatePassed(importantDates.listingDate!),
        isCurrent: _isCurrentPhase('listing'),
      ));
    }

    return items;
  }

  Widget _buildHorizontalTimeline(
      List<TimelineItemData> items, bool isCompact) {
    if (items.isEmpty) return const SizedBox.shrink();

    final indicatorSize = isCompact ? 20.0 : 26.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final itemWidth = availableWidth / items.length;

        return Column(
          children: [
            SizedBox(
              height: indicatorSize,
              child: Stack(
                children: [
                  Positioned(
                    top: (indicatorSize - 3) / 2,
                    left: itemWidth / 2,
                    right: itemWidth / 2,
                    child: _buildProgressLines(items, isCompact),
                  ),
                  Row(
                    children: items.map((item) {
                      return SizedBox(
                        width: itemWidth,
                        child: Center(
                          child: _buildModernIndicator(item, isCompact),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: isCompact ? 14 : 18),
            Row(
              children: items.map((item) {
                return SizedBox(
                  width: itemWidth,
                  child: Center(
                    child:
                        _buildTimelineLabel(item, isCompact, TextAlign.center),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildModernIndicator(TimelineItemData item, bool isCompact) {
    final indicatorSize = isCompact ? 20.0 : 26.0;
    final iconSize = isCompact ? 11.0 : 14.0;

    Color backgroundColor;
    Color borderColor;

    if (item.isCompleted) {
      backgroundColor = AppColors.success;
      borderColor = Colors.white;
    } else if (item.isCurrent) {
      backgroundColor = AppColors.warning;
      borderColor = Colors.white;
    } else {
      backgroundColor = Colors.grey.shade600.withOpacity(0.4);
      borderColor = Colors.white.withOpacity(0.3);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      width: indicatorSize,
      height: indicatorSize,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
        boxShadow: item.isCurrent
            ? [
                BoxShadow(
                  color: AppColors.warning.withOpacity(0.6),
                  blurRadius: 10,
                  spreadRadius: 3,
                )
              ]
            : [],
      ),
      child: Icon(
        item.icon,
        size: iconSize,
        color: Colors.white,
      ),
    );
  }

  Widget _buildTimelineLabel(
      TimelineItemData item, bool isCompact, TextAlign textAlign) {
    final formattedDate = _formatDateShort(item.date);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: item.isCompleted
                ? AppColors.success.withOpacity(0.2)
                : item.isCurrent
                    ? AppColors.warning.withOpacity(0.2)
                    : Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            item.title,
            style: TextStyle(
              fontSize: isCompact ? 10 : 12,
              fontWeight: FontWeight.w600,
              color: item.isCompleted
                  ? AppColors.success
                  : item.isCurrent
                      ? AppColors.warning
                      : Colors.white70,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          formattedDate,
          textAlign: textAlign,
          style: TextStyle(
            fontSize: isCompact ? 9 : 11,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressLines(List<TimelineItemData> items, bool isCompact) {
    if (items.length < 2) return const SizedBox.shrink();

    return Row(
      children: List.generate(items.length - 1, (index) {
        final current = items[index];
        final next = items[index + 1];

        bool isActive = current.isCompleted && next.isCompleted;
        bool isPartiallyActive = current.isCompleted && next.isCurrent;

        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            height: 3,
            margin: EdgeInsets.symmetric(horizontal: isCompact ? 3 : 6),
            decoration: BoxDecoration(
              gradient: isActive
                  ? const LinearGradient(
                      colors: [AppColors.success, AppColors.success],
                    )
                  : isPartiallyActive
                      ? LinearGradient(
                          colors: [AppColors.success, AppColors.warning],
                        )
                      : null,
              color: (!isActive && !isPartiallyActive)
                  ? Colors.white.withOpacity(0.15)
                  : null,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }

  String _formatDateShort(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final targetDate = DateTime(date.year, date.month, date.day);

      if (targetDate == today) {
        return 'Today';
      } else if (targetDate == today.add(const Duration(days: 1))) {
        return 'Tomorrow';
      } else if (targetDate == today.subtract(const Duration(days: 1))) {
        return 'Yesterday';
      } else {
        return DateFormat('MMM dd').format(date);
      }
    } catch (e) {
      return dateString.length > 8 ? dateString.substring(0, 8) : dateString;
    }
  }

  bool _isDatePassed(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateTime.now().isAfter(date);
    } catch (e) {
      return false;
    }
  }

  bool _isCurrentPhase(String phase) {
    final now = DateTime.now();

    switch (phase) {
      case 'open':
        if (importantDates.openDate != null &&
            importantDates.closeDate != null) {
          final openDate = DateTime.tryParse(importantDates.openDate!);
          final closeDate = DateTime.tryParse(importantDates.closeDate!);
          if (openDate != null && closeDate != null) {
            return now.isAfter(openDate) && now.isBefore(closeDate);
          }
        }
        return status.toLowerCase() == 'current';
      case 'close':
        return status.toLowerCase() == 'closed';
      case 'allotment':
        if (importantDates.allotmentDate != null) {
          final allotmentDate =
              DateTime.tryParse(importantDates.allotmentDate!);
          if (allotmentDate != null) {
            final daysDiff = allotmentDate.difference(now).inDays;
            return daysDiff >= -1 && daysDiff <= 1;
          }
        }
        return false;
      case 'listing':
        return status.toLowerCase() == 'listed';
      default:
        return false;
    }
  }
}

class TimelineItemData {
  final String title;
  final String date;
  final IconData icon;
  final bool isCompleted;
  final bool isCurrent;

  TimelineItemData({
    required this.title,
    required this.date,
    required this.icon,
    required this.isCompleted,
    required this.isCurrent,
  });
}
