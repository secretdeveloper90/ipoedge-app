import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_drawer.dart';
import '../services/drawer_service.dart';
import 'mainboard_screen.dart';
import 'sme_screen.dart';
import 'buybacks_screen.dart';
import 'allotment_screen.dart';
import 'news_screen.dart';
import 'brokers_screen.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex;
  const HomeScreen({super.key, this.initialIndex = 0});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _currentIndex;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _screens = [
    const MainboardScreen(),
    const SMEScreen(),
    const AllotmentScreen(),
    const BuybacksScreen(),
    const BrokersScreen(),
    const NewsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    // Register the scaffold key with the drawer service
    DrawerService().setScaffoldKey(_scaffoldKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(),
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.surface,
              AppColors.surface.withOpacity(0.95),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.1),
              blurRadius: 30,
              offset: const Offset(0, -8),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
              spreadRadius: 0,
            ),
          ],
          border: Border(
            top: BorderSide(
              color: AppColors.primary.withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.trending_up_rounded, 'Mainboard'),
                _buildNavItem(1, Icons.storefront_rounded, 'SME'),
                _buildNavItem(
                    2, Icons.assignment_turned_in_rounded, 'Allotment'),
                _buildNavItem(
                    3, Icons.account_balance_wallet_rounded, 'Buybacks'),
                _buildNavItem(4, Icons.business_rounded, 'Brokers'),
                _buildNavItem(5, Icons.article_rounded, 'News'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return Expanded(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _currentIndex = index;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic,
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background glow effect for selected item
                    if (isSelected)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(17),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.2),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    // Icon container
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOutCubic,
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.primary,
                                  AppColors.primaryDark,
                                ],
                              )
                            : null,
                        color: isSelected ? null : Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 200),
                        scale: isSelected ? 1.1 : 1.0,
                        child: Icon(
                          icon,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary,
                          size: isSelected ? 20 : 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    fontSize: isSelected ? 8.5 : 8,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    height: 1.0,
                    letterSpacing: isSelected ? 0.1 : 0,
                  ),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
