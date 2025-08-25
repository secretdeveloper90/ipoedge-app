import 'package:flutter/material.dart';
import 'package:ipo_edge/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../screens/contact_us_screen.dart';
import '../screens/privacy_policy_screen.dart';
import '../screens/terms_conditions_screen.dart';
import '../screens/about_us_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/help_support_screen.dart';

import '../screens/home_screen.dart';
import '../screens/signin_screen.dart';
import '../services/auth_service.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _slideController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 280,
      backgroundColor: AppColors.surface,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.surface,
              AppColors.surfaceVariant,
            ],
          ),
        ),
        child: Column(
          children: [
            _buildHeroSection(),
            Expanded(
              child: _buildMenuItems(),
            ),
            _buildSocialMediaSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(
          minHeight: 160,
          maxHeight: 190,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.primaryDark,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background pattern
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            Positioned(
              bottom: -30,
              left: -30,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.03),
                ),
              ),
            ),
            // Content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: AuthService().isLoggedIn
                          ? _buildLoggedInContent()
                          : Row(
                              children: [
                                Container(
                                  width: 52,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.white.withOpacity(0.25),
                                        Colors.white.withOpacity(0.15),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.5),
                                    child: Image.asset(
                                      'assets/images/ipo-edge-logo.jpeg',
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(
                                          Icons.trending_up_rounded,
                                          color: Colors.white,
                                          size: 24,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildGuestContent(),
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.2),
                                Colors.white.withOpacity(0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.verified_rounded,
                                color: Colors.greenAccent,
                                size: 14,
                              ),
                              SizedBox(width: 3),
                              Text(
                                'Trusted',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.amber.withOpacity(0.3),
                                Colors.orange.withOpacity(0.2),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.amber.withOpacity(0.4),
                              width: 1,
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star_rounded,
                                color: Colors.amber,
                                size: 14,
                              ),
                              SizedBox(width: 3),
                              Text(
                                'Premium',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItems() {
    final menuItems = [
      DrawerMenuItem(
        icon: Icons.home_rounded,
        title: 'Home',
        subtitle: 'Go to main dashboard',
        onTap: () => _handleMenuTap('home'),
      ),
      DrawerMenuItem(
        icon: Icons.contact_support_rounded,
        title: 'Contact Us',
        subtitle: 'Get in touch with our team',
        onTap: () => _handleMenuTap('contact'),
      ),
      DrawerMenuItem(
        icon: Icons.privacy_tip_rounded,
        title: 'Privacy Policy',
        subtitle: 'How we protect your data',
        onTap: () => _handleMenuTap('privacy'),
      ),
      DrawerMenuItem(
        icon: Icons.description_rounded,
        title: 'Terms & Conditions',
        subtitle: 'Our terms of service',
        onTap: () => _handleMenuTap('terms'),
      ),
      DrawerMenuItem(
        icon: Icons.info_rounded,
        title: 'About Us',
        subtitle: 'Learn more about IPO Edge',
        onTap: () => _handleMenuTap('about'),
      ),
      DrawerMenuItem(
        icon: Icons.settings_rounded,
        title: 'Settings',
        subtitle: 'Customize your experience',
        onTap: () => _handleMenuTap('settings'),
      ),
      DrawerMenuItem(
        icon: Icons.help_rounded,
        title: 'Help & Support',
        subtitle: 'FAQs and support center',
        onTap: () => _handleMenuTap('help'),
      ),
      if (AuthService().isLoggedIn) ...[
        DrawerMenuItem(
          icon: Icons.logout_rounded,
          title: 'Sign Out',
          subtitle: 'Sign out of your account',
          onTap: () => _handleMenuTap('signout'),
          isDestructive: true,
        ),
      ],
    ];

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 6),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          return TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 300 + (index * 50)),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(50 * (1 - value), 0),
                child: Opacity(
                  opacity: value,
                  child: _buildMenuItem(menuItems[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildMenuItem(DrawerMenuItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: item.onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: item.isDestructive
                        ? Colors.red.withOpacity(0.1)
                        : AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    item.icon,
                    color: item.isDestructive ? Colors.red : AppColors.primary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: item.isDestructive
                              ? Colors.red
                              : AppColors.textPrimary,
                        ),
                      ),
                      if (item.subtitle != null) ...[
                        const SizedBox(height: 1),
                        Text(
                          item.subtitle!,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textSecondary,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialMediaSection() {
    final socialItems = [
      const SocialMediaItem(
        svgAsset: 'assets/icons/facebook.svg',
        label: 'Facebook',
        url: 'https://www.facebook.com/ipoedge',
      ),
      const SocialMediaItem(
        svgAsset: 'assets/icons/twitter.svg',
        label: 'Twitter',
        url: 'https://twitter.com/ipoedgeindia',
      ),
      const SocialMediaItem(
        svgAsset: 'assets/icons/youtube.svg',
        label: 'YouTube',
        url: 'https://www.youtube.com/@ipoedgeindia',
      ),
      const SocialMediaItem(
        svgAsset: 'assets/icons/instagram.svg',
        label: 'Instagram',
        url: 'https://www.instagram.com/ipo.edge',
      ),
      const SocialMediaItem(
        svgAsset: 'assets/icons/telegram.svg',
        label: 'Telegram',
        url: 'https://t.me/IPOEdgeApp',
      ),
      const SocialMediaItem(
        svgAsset: 'assets/icons/thread.svg',
        label: 'Threads',
        url: 'https://www.threads.net/@ipo.edge',
      ),
    ];

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant.withOpacity(0.3),
          border: Border(
            top: BorderSide(
              color: AppColors.cardBorder.withOpacity(0.3),
              width: 1,
            ),
          ),
        ),
        child: Column(
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: socialItems.map((item) {
                  return TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 600),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: _buildSocialButton(item),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                'IPO Edge v1.0.0',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(SocialMediaItem item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _launchUrl(item.url),
        mouseCursor: SystemMouseCursors.click,
        child: Container(
          width: 32,
          height: 32,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: AppColors.cardBorder.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: item.svgAsset != null
              ? SvgPicture.asset(
                  item.svgAsset!,
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                )
              : Icon(
                  item.icon!,
                  color: item.color ?? AppColors.textSecondary,
                  size: 20,
                ),
        ),
      ),
    );
  }

  void _handleMenuTap(String action) {
    Navigator.pop(context);

    switch (action) {
      case 'home':
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
        break;

      case 'contact':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ContactUsScreen()),
        );
        break;
      case 'privacy':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
        );
        break;
      case 'terms':
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const TermsConditionsScreen()),
        );
        break;
      case 'about':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AboutUsScreen()),
        );
        break;
      case 'settings':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingsScreen()),
        );
        break;
      case 'help':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
        );
        break;
      case 'signout':
        _handleSignOut();
        break;
    }
  }

  void _handleSignOut() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Close dialog first

                // Show loading indicator
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );

                try {
                  // Use Firebase signOut method
                  await AuthService().signOut();

                  if (context.mounted) {
                    Navigator.pop(context); // Close loading dialog

                    // Navigate to home screen (mainboard)
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                      (route) => false,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Signed out successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.pop(context); // Close loading dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error signing out: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Widget _buildLoggedInContent() {
    return Row(
      children: [
        // Profile Avatar with same style as IPO logo
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.25),
                Colors.white.withOpacity(0.15),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: AuthService().userPhotoUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12.5),
                  child: CachedNetworkImage(
                    imageUrl: AuthService().userPhotoUrl!,
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                    errorWidget: (context, url, error) => ClipRRect(
                      borderRadius: BorderRadius.circular(12.5),
                      child: Image.asset(
                        'assets/images/profile.png',
                        width: 52,
                        height: 52,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(12.5),
                  child: Image.asset(
                    'assets/images/profile.png',
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                  ),
                ),
        ),
        const SizedBox(width: 12),

        // User info with welcome message and icon in same row
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AuthService().userName ?? 'IPO Investor',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Welcome back!',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => _navigateToSettings(),
                  child: Icon(
                    Icons.settings_outlined,
                    color: Colors.white.withOpacity(0.9),
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGuestContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'IPO Edge',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.4,
            height: 1.1,
            shadows: [
              Shadow(
                color: Colors.black26,
                offset: Offset(0, 1),
                blurRadius: 3,
              ),
            ],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          'Your Gateway to IPO Success',
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 0,
            height: 1.2,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => _navigateToSignIn(),
            child: RichText(
              text: TextSpan(
                text: 'Click here to ',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  height: 1.1,
                ),
                children: const [
                  TextSpan(
                    text: 'sign in',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToSignIn() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
    );
  }

  void _navigateToSettings() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );
  }
}

class DrawerMenuItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  const DrawerMenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });
}

class SocialMediaItem {
  final IconData? icon;
  final String? svgAsset;
  final String label;
  final String url;
  final Color? color;

  const SocialMediaItem({
    this.icon,
    this.svgAsset,
    required this.label,
    required this.url,
    this.color,
  }) : assert(icon != null || svgAsset != null,
            'Either icon or svgAsset must be provided');
}
