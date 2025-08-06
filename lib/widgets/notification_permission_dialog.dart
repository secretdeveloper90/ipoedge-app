import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/notification_helper.dart';

class NotificationPermissionDialog extends StatefulWidget {
  final VoidCallback? onPermissionGranted;
  final VoidCallback? onPermissionDenied;

  const NotificationPermissionDialog({
    super.key,
    this.onPermissionGranted,
    this.onPermissionDenied,
  });

  @override
  State<NotificationPermissionDialog> createState() => _NotificationPermissionDialogState();
}

class _NotificationPermissionDialogState extends State<NotificationPermissionDialog> {
  bool _isRequesting = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Icon(
            Icons.notifications_active,
            color: Theme.of(context).primaryColor,
            size: 28,
          ),
          const SizedBox(width: 12),
          const Text(
            'Enable Notifications',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Stay updated with the latest IPO news and updates!',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          _buildFeatureItem(
            icon: Icons.trending_up,
            title: 'IPO Updates',
            description: 'Get notified about new IPO listings and price updates',
          ),
          const SizedBox(height: 12),
          _buildFeatureItem(
            icon: Icons.article,
            title: 'Market News',
            description: 'Receive important market news and analysis',
          ),
          const SizedBox(height: 12),
          _buildFeatureItem(
            icon: Icons.schedule,
            title: 'Timely Alerts',
            description: 'Never miss important IPO deadlines and events',
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.blue.shade700,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'You can change this setting anytime in your device settings.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isRequesting ? null : () {
            Navigator.of(context).pop();
            widget.onPermissionDenied?.call();
          },
          child: Text(
            'Not Now',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _isRequesting ? null : _requestPermission,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: _isRequesting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text(
                  'Allow Notifications',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _requestPermission() async {
    setState(() {
      _isRequesting = true;
    });

    try {
      final notificationHelper = NotificationHelper();
      final granted = await notificationHelper.requestNotificationPermissions();

      if (mounted) {
        Navigator.of(context).pop();
        
        if (granted) {
          widget.onPermissionGranted?.call();
          _showSuccessSnackBar();
        } else {
          widget.onPermissionDenied?.call();
          _showPermissionDeniedDialog();
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
        widget.onPermissionDenied?.call();
        _showErrorSnackBar();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRequesting = false;
        });
      }
    }
  }

  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Notifications enabled successfully!'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showErrorSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.error, color: Colors.white),
            SizedBox(width: 8),
            Text('Failed to enable notifications'),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Denied'),
        content: const Text(
          'To receive notifications, please enable them in your device settings.\n\n'
          'Go to Settings > Apps > IPO Edge > Notifications and turn them on.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  /// Show notification permission dialog
  static Future<void> show(
    BuildContext context, {
    VoidCallback? onPermissionGranted,
    VoidCallback? onPermissionDenied,
  }) async {
    // Check if permission is already granted
    final notificationHelper = NotificationHelper();
    final isEnabled = await notificationHelper.areNotificationsEnabled();
    
    if (isEnabled) {
      onPermissionGranted?.call();
      return;
    }

    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => NotificationPermissionDialog(
          onPermissionGranted: onPermissionGranted,
          onPermissionDenied: onPermissionDenied,
        ),
      );
    }
  }
}
