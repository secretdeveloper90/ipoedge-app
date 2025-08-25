import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';
import '../services/drawer_service.dart';
import '../widgets/common_app_bar.dart';
import '../widgets/app_drawer.dart';
import 'home_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Register the scaffold key with the drawer service
    WidgetsBinding.instance.addPostFrameCallback((_) {
      DrawerService().setScaffoldKey(_scaffoldKey);
    });

    // Listen to auth state changes to refresh the UI when user data is restored
    _listenToAuthStateChanges();
  }

  void _listenToAuthStateChanges() {
    // Listen to Firebase auth state changes to rebuild UI when data is restored
    AuthService().firebaseAuth.authStateChanges().listen((user) {
      if (mounted) {
        // Small delay to ensure Firestore data is fetched
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            setState(() {
              // This will trigger a rebuild with updated user data
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    // Note: We don't restore the previous scaffold key here because
    // the DrawerService will be updated by the next screen that has a drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      appBar: CommonAppBar(
        title: 'Profile',
        actions: AuthService().isLoggedIn
            ? [
                IconButton(
                  onPressed: _handleSignOut,
                  icon: const Icon(Icons.logout_rounded),
                  tooltip: 'Sign Out',
                  color: Colors.white,
                ),
              ]
            : null,
      ),
      drawer: const AppDrawer(),
      body: _buildAuthenticatedProfile(),
    );
  }

  Widget _buildAuthenticatedProfile() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 24),
          _buildUserDetailsCard(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primaryDark,
            AppColors.primary.withOpacity(0.9),
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
          child: Column(
            children: [
              // Profile Image with enhanced design
              Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.3),
                          Colors.white.withOpacity(0.1),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.4),
                            width: 3,
                          ),
                        ),
                        child: AuthService().userPhotoUrl != null
                            ? ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: AuthService().userPhotoUrl!,
                                  width: 112,
                                  height: 112,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withOpacity(0.2),
                                    ),
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      ClipOval(
                                    child: Image.asset(
                                      'assets/images/profile.png',
                                      width: 112,
                                      height: 112,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              )
                            : ClipOval(
                                child: Image.asset(
                                  'assets/images/profile.png',
                                  width: 112,
                                  height: 112,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                  ),
                  // Online status indicator
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.success.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // User name with enhanced typography
              Text(
                AuthService().userName ?? 'IPO Investor',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.5,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              // User email with subtle styling
              if (AuthService().userEmail != null) ...[
                Text(
                  AuthService().userEmail!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.3,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
              ] else
                const SizedBox(height: 12),
              // Premium badge with enhanced design
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.25),
                      Colors.white.withOpacity(0.15),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: Colors.white.withOpacity(0.9),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Premium Member',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.95),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserDetailsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.cardBorder.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.1),
                      AppColors.primary.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.person_outline_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.verified_rounded,
                  color: AppColors.success,
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildEnhancedDetailRow(
            Icons.person_rounded,
            'Full Name',
            AuthService().userName ?? 'John Doe',
            AppColors.primary,
          ),
          const SizedBox(height: 20),
          _buildEnhancedDetailRow(
            Icons.email_rounded,
            'Email Address',
            AuthService().userEmail ?? 'john.doe@example.com',
            AppColors.info,
          ),
          const SizedBox(height: 20),
          _buildEnhancedDetailRow(
            Icons.phone_rounded,
            'Mobile Number',
            AuthService().userPhoneNumber ?? 'Not provided',
            AppColors.success,
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedDetailRow(
    IconData icon,
    String label,
    String value,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: iconColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  iconColor.withOpacity(0.15),
                  iconColor.withOpacity(0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ],
      ),
    );
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

                  if (mounted) {
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
                  if (mounted) {
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
}
