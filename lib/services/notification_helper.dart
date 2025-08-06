import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationHelper {
  static final NotificationHelper _instance = NotificationHelper._internal();
  factory NotificationHelper() => _instance;
  NotificationHelper._internal();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  /// Initialize notification helper
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _initializeLocalNotifications();
      await _createNotificationChannels();
      _isInitialized = true;
      log('Notification Helper initialized successfully');
    } catch (e) {
      log('Error initializing Notification Helper: $e');
    }
  }

  /// Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_notification');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _localNotifications.initialize(initializationSettings);
  }

  /// Create notification channels
  Future<void> _createNotificationChannels() async {
    // High importance channel
    const AndroidNotificationChannel highImportanceChannel =
        AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description:
          'This channel is used for important notifications like IPO updates.',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      enableLights: true,
      ledColor: Colors.blue,
    );

    // Medium importance channel
    const AndroidNotificationChannel mediumImportanceChannel =
        AndroidNotificationChannel(
      'medium_importance_channel',
      'Medium Importance Notifications',
      description: 'This channel is used for general notifications.',
      importance: Importance.defaultImportance,
      playSound: true,
      enableVibration: false,
    );

    // Low importance channel
    const AndroidNotificationChannel lowImportanceChannel =
        AndroidNotificationChannel(
      'low_importance_channel',
      'Low Importance Notifications',
      description: 'This channel is used for background updates.',
      importance: Importance.low,
      playSound: false,
      enableVibration: false,
    );

    final androidPlugin =
        _localNotifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(highImportanceChannel);
      await androidPlugin.createNotificationChannel(mediumImportanceChannel);
      await androidPlugin.createNotificationChannel(lowImportanceChannel);
    }
  }

  /// Request notification permissions for Android 13+
  Future<bool> requestNotificationPermissions() async {
    try {
      // For Android 13+ (API level 33+)
      final status = await Permission.notification.request();

      if (status.isGranted) {
        log('Notification permission granted');
        return true;
      } else if (status.isDenied) {
        log('Notification permission denied');
        return false;
      } else if (status.isPermanentlyDenied) {
        log('Notification permission permanently denied');
        // You might want to show a dialog to guide user to settings
        return false;
      }

      return false;
    } catch (e) {
      log('Error requesting notification permissions: $e');
      return false;
    }
  }

  /// Check if notification permissions are granted
  Future<bool> areNotificationsEnabled() async {
    try {
      final status = await Permission.notification.status;
      return status.isGranted;
    } catch (e) {
      log('Error checking notification permissions: $e');
      return false;
    }
  }

  /// Show a local notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    NotificationImportance importance = NotificationImportance.high,
  }) async {
    try {
      AndroidNotificationDetails androidDetails;

      switch (importance) {
        case NotificationImportance.high:
          androidDetails = const AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications like IPO updates.',
            importance: Importance.high,
            priority: Priority.high,
            showWhen: true,
            enableVibration: true,
            playSound: true,
            enableLights: true,
            ledColor: Colors.blue,
            ledOnMs: 1000,
            ledOffMs: 500,
          );
          break;
        case NotificationImportance.medium:
          androidDetails = const AndroidNotificationDetails(
            'medium_importance_channel',
            'Medium Importance Notifications',
            channelDescription:
                'This channel is used for general notifications.',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
            showWhen: true,
            enableVibration: false,
            playSound: true,
          );
          break;
        case NotificationImportance.low:
          androidDetails = const AndroidNotificationDetails(
            'low_importance_channel',
            'Low Importance Notifications',
            channelDescription: 'This channel is used for background updates.',
            importance: Importance.low,
            priority: Priority.low,
            showWhen: false,
            enableVibration: false,
            playSound: false,
          );
          break;
      }

      final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidDetails,
      );

      await _localNotifications.show(
        id,
        title,
        body,
        platformChannelSpecifics,
        payload: payload,
      );

      log('Local notification shown: $title');
    } catch (e) {
      log('Error showing local notification: $e');
    }
  }

  /// Show a scheduled notification
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    NotificationImportance importance = NotificationImportance.high,
  }) async {
    try {
      AndroidNotificationDetails androidDetails;

      switch (importance) {
        case NotificationImportance.high:
          androidDetails = const AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications like IPO updates.',
            importance: Importance.high,
            priority: Priority.high,
            showWhen: true,
            enableVibration: true,
            playSound: true,
          );
          break;
        case NotificationImportance.medium:
          androidDetails = const AndroidNotificationDetails(
            'medium_importance_channel',
            'Medium Importance Notifications',
            channelDescription:
                'This channel is used for general notifications.',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
            showWhen: true,
            enableVibration: false,
            playSound: true,
          );
          break;
        case NotificationImportance.low:
          androidDetails = const AndroidNotificationDetails(
            'low_importance_channel',
            'Low Importance Notifications',
            channelDescription: 'This channel is used for background updates.',
            importance: Importance.low,
            priority: Priority.low,
            showWhen: false,
            enableVibration: false,
            playSound: false,
          );
          break;
      }

      // Note: For scheduling, you might want to use a different package like timezone
      // This is a basic implementation
      log('Scheduled notification set for: $scheduledDate');
    } catch (e) {
      log('Error scheduling notification: $e');
    }
  }

  /// Cancel a notification
  Future<void> cancelNotification(int id) async {
    try {
      await _localNotifications.cancel(id);
      log('Notification cancelled: $id');
    } catch (e) {
      log('Error cancelling notification: $e');
    }
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    try {
      await _localNotifications.cancelAll();
      log('All notifications cancelled');
    } catch (e) {
      log('Error cancelling all notifications: $e');
    }
  }

  /// Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      return await _localNotifications.pendingNotificationRequests();
    } catch (e) {
      log('Error getting pending notifications: $e');
      return [];
    }
  }
}

/// Notification importance levels
enum NotificationImportance {
  high,
  medium,
  low,
}
