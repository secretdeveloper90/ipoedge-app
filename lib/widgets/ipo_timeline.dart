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

    // Don't show timeline if no dates are available
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

    // Add timeline items based on available dates
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

    final indicatorSize = isCompact ? 18.0 : 22.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final itemWidth = availableWidth / items.length;

        return Column(
          children: [
            // Timeline container with proper alignment
            SizedBox(
              height: indicatorSize,
              child: Stack(
                children: [
                  // Dynamic progress lines between points
                  Positioned(
                    top: (indicatorSize - 3) / 2,
                    left: itemWidth / 2,
                    right: itemWidth / 2,
                    child: _buildProgressLines(items, isCompact),
                  ),
                  // Timeline indicators - evenly distributed
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
            SizedBox(height: isCompact ? 12 : 16),
            // Labels positioned directly below each indicator
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
    final indicatorSize = isCompact ? 18.0 : 22.0;
    final iconSize = isCompact ? 9.0 : 11.0;
    final borderWidth = isCompact ? 2.0 : 2.5;

    Color backgroundColor;
    Color borderColor;
    List<BoxShadow> shadows = [];

    if (item.isCompleted) {
      backgroundColor = AppColors.success;
      borderColor = Colors.white;
      shadows = [
        BoxShadow(
          color: AppColors.success.withOpacity(0.4),
          blurRadius: 8,
          spreadRadius: 2,
        ),
        BoxShadow(
          color: Colors.white.withOpacity(0.2),
          blurRadius: 2,
          spreadRadius: 0,
        ),
      ];
    } else if (item.isCurrent) {
      backgroundColor = AppColors.warning;
      borderColor = Colors.white;
      shadows = [
        BoxShadow(
          color: AppColors.warning.withOpacity(0.4),
          blurRadius: 8,
          spreadRadius: 2,
        ),
        BoxShadow(
          color: Colors.white.withOpacity(0.2),
          blurRadius: 2,
          spreadRadius: 0,
        ),
      ];
    } else {
      backgroundColor = Colors.white.withOpacity(0.25);
      borderColor = Colors.white.withOpacity(0.5);
      shadows = [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          spreadRadius: 0,
        ),
      ];
    }

    return Container(
      width: indicatorSize,
      height: indicatorSize,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
        boxShadow: shadows,
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          item.title,
          textAlign: textAlign,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: isCompact ? 10 : 11,
            fontWeight: FontWeight.w600,
            color: item.isCompleted || item.isCurrent
                ? Colors.white
                : Colors.white.withOpacity(0.8),
          ),
        ),
        SizedBox(height: isCompact ? 2 : 3),
        Text(
          formattedDate,
          textAlign: textAlign,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: isCompact ? 8 : 9,
            color: Colors.white.withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressLines(List<TimelineItemData> items, bool isCompact) {
    if (items.length < 2) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final segmentWidth = availableWidth / (items.length - 1);

        return Row(
          children: List.generate(items.length - 1, (index) {
            final currentItem = items[index];
            final nextItem = items[index + 1];

            // Determine line state based on current and next item status
            bool isActive = false;
            bool isPartiallyActive = false;

            if (currentItem.isCompleted && nextItem.isCompleted) {
              isActive = true;
            } else if (currentItem.isCompleted && nextItem.isCurrent) {
              isPartiallyActive = true;
            } else if (currentItem.isCurrent && nextItem.isCurrent) {
              isPartiallyActive = true;
            }

            return SizedBox(
              width: segmentWidth,
              child: Container(
                height: 3,
                margin: EdgeInsets.symmetric(horizontal: isCompact ? 4 : 8),
                decoration: BoxDecoration(
                  gradient: isActive
                      ? const LinearGradient(
                          colors: [
                            AppColors.success,
                            AppColors.success,
                          ],
                        )
                      : isPartiallyActive
                          ? LinearGradient(
                              colors: [
                                AppColors.success,
                                AppColors.warning.withOpacity(0.6),
                              ],
                            )
                          : null,
                  color: isActive || isPartiallyActive
                      ? null
                      : Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(1.5),
                  boxShadow: isActive || isPartiallyActive
                      ? [
                          BoxShadow(
                            color: (isActive
                                    ? AppColors.success
                                    : AppColors.warning)
                                .withOpacity(0.3),
                            blurRadius: 4,
                            spreadRadius: 0,
                          ),
                        ]
                      : null,
                ),
              ),
            );
          }),
        );
      },
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
            return daysDiff >= -1 && daysDiff <= 1; // Current if within 1 day
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
