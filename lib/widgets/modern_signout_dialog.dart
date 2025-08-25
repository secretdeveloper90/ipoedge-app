import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';
import '../screens/home_screen.dart';

class ModernSignOutDialog extends StatefulWidget {
  const ModernSignOutDialog({super.key});

  @override
  State<ModernSignOutDialog> createState() => _ModernSignOutDialogState();
}

class _ModernSignOutDialogState extends State<ModernSignOutDialog>
    with SingleTickerProviderStateMixin {
  bool _isSigningOut = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 340),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      Color(0xFFFAFBFF),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.1),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.15),
                      blurRadius: 32,
                      offset: const Offset(0, 16),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 20),
                      _buildContent(),
                      const SizedBox(height: 24),
                      _buildActions(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.error.withOpacity(0.1),
            AppColors.error.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.error.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Icon(
        Icons.logout_rounded,
        size: 32,
        color: AppColors.error,
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        Text(
          'Sign Out',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Are you sure you want to sign out of your account?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.warning.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.warning.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: AppColors.warning,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'You\'ll need to sign in again to access your account features.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.warning.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        Expanded(
          child: _buildCancelButton(),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSignOutButton(),
        ),
      ],
    );
  }

  Widget _buildCancelButton() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.textSecondary.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isSigningOut ? null : () => Navigator.of(context).pop(),
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _isSigningOut
                    ? AppColors.textSecondary.withOpacity(0.5)
                    : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignOutButton() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _isSigningOut
              ? [
                  AppColors.textSecondary.withOpacity(0.3),
                  AppColors.textSecondary.withOpacity(0.2),
                ]
              : [
                  AppColors.error,
                  AppColors.error.withOpacity(0.8),
                ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: _isSigningOut
            ? []
            : [
                BoxShadow(
                  color: AppColors.error.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isSigningOut ? null : _handleSignOut,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: _isSigningOut
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white.withOpacity(0.8),
                      ),
                    ),
                  )
                : Text(
                    'Sign Out',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSignOut() async {
    setState(() {
      _isSigningOut = true;
    });

    try {
      // Use Firebase signOut method
      await AuthService().signOut();

      if (mounted) {
        Navigator.of(context).pop(); // Close dialog

        // Navigate to home screen (mainboard)
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Signed out successfully',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSigningOut = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.error_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Error signing out: $e',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }
}

/// Show modern sign out dialog
Future<void> showModernSignOutDialog(BuildContext context) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.6),
    builder: (context) => const ModernSignOutDialog(),
  );
}
