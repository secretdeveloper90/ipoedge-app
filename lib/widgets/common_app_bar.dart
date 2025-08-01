import 'package:flutter/material.dart';
import 'package:ipo_edge/theme/app_theme.dart';
import 'package:ipo_edge/screens/search_screen.dart';
import 'package:ipo_edge/services/drawer_service.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showSearch;
  final bool showMenu;
  final List<Widget>? additionalActions;
  final List<Widget>? actions;
  final String? searchHint;
  final SearchType? searchType;
  final PreferredSizeWidget? bottom;
  final VoidCallback? onMenuPressed;

  const CommonAppBar({
    super.key,
    required this.title,
    this.showSearch = false,
    this.showMenu = true,
    this.additionalActions,
    this.actions,
    this.searchHint,
    this.searchType,
    this.bottom,
    this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 2,
      leading: showMenu
          ? Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.menu_rounded),
                  onPressed: () {
                    DrawerService().openDrawer();
                  },
                  tooltip: 'Open menu',
                );
              },
            )
          : null,
      actions: actions ??
          [
            if (showSearch) ...[
              IconButton(
                icon: const Icon(Icons.search_rounded),
                onPressed: () => _openSearch(context),
                tooltip: 'Search',
              ),
            ],
            if (additionalActions != null) ...additionalActions!,
          ],
      bottom: bottom,
    );
  }

  void _openSearch(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchScreen(
          searchType: searchType ?? SearchType.all,
          initialHint: searchHint,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );
}

enum SearchType {
  all,
  mainboard,
  sme,
  buybacks,
}

extension SearchTypeExtension on SearchType {
  String get displayName {
    switch (this) {
      case SearchType.all:
        return 'All IPOs';
      case SearchType.mainboard:
        return 'Mainboard IPOs';
      case SearchType.sme:
        return 'SME IPOs';
      case SearchType.buybacks:
        return 'Buybacks';
    }
  }

  String get searchHint {
    switch (this) {
      case SearchType.all:
        return 'Search all IPOs...';
      case SearchType.mainboard:
        return 'Search mainboard IPOs...';
      case SearchType.sme:
        return 'Search SME IPOs...';
      case SearchType.buybacks:
        return 'Search buybacks...';
    }
  }
}
