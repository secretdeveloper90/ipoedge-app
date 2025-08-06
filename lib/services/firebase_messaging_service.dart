import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseMessagingService {
  static final FirebaseMessagingService _instance = FirebaseMessagingService._internal();
  factory FirebaseMessagingService() => _instance;
  FirebaseMessagingService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  
  String? _fcmToken;
  bool _isInitialized = false;

  /// Get the current FCM token
  String? get fcmToken => _fcmToken;

  /// Initialize Firebase Messaging Service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Request notification permissions
      await _requestPermissions();
      
      // Initialize local notifications
      await _initializeLocalNotifications();
      
      // Get FCM token
      await _getFCMToken();
      
      // Set up message handlers
      _setupMessageHandlers();
      
      _isInitialized = true;
      log('Firebase Messaging Service initialized successfully');
    } catch (e) {
      log('Error initializing Firebase Messaging Service: $e');
    }
  }

  /// Request notification permissions
  Future<void> _requestPermissions() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    log('Notification permission status: ${settings.authorizationStatus}');
  }

  /// Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_notification');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channel for Android
    await _createNotificationChannel();
  }

  /// Create notification channel for Android
  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Get FCM token
  Future<void> _getFCMToken() async {
    try {
      _fcmToken = await _firebaseMessaging.getToken();
      log('FCM Token: $_fcmToken');
      
      // Save token to SharedPreferences
      if (_fcmToken != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('fcm_token', _fcmToken!);
      }
    } catch (e) {
      log('Error getting FCM token: $e');
    }
  }

  /// Set up message handlers
  void _setupMessageHandlers() {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    
    // Handle background messages (when app is in background but not terminated)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
    
    // Handle token refresh
    _firebaseMessaging.onTokenRefresh.listen(_onTokenRefresh);
  }

  /// Handle foreground messages
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    log('Received foreground message: ${message.messageId}');
    
    // Show local notification when app is in foreground
    await _showLocalNotification(message);
  }

  /// Handle message when app is opened from notification
  Future<void> _handleMessageOpenedApp(RemoteMessage message) async {
    log('Message opened app: ${message.messageId}');
    
    // Handle navigation or specific actions when notification is tapped
    await _handleNotificationAction(message);
  }

  /// Handle token refresh
  Future<void> _onTokenRefresh(String token) async {
    log('FCM Token refreshed: $token');
    _fcmToken = token;
    
    // Save new token to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcm_token', token);
    
    // You can send the new token to your server here
    // await _sendTokenToServer(token);
  }

  /// Show local notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? 'IPO Edge',
      message.notification?.body ?? 'You have a new notification',
      platformChannelSpecifics,
      payload: jsonEncode(message.data),
    );
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse notificationResponse) {
    log('Notification tapped: ${notificationResponse.payload}');
    
    if (notificationResponse.payload != null) {
      try {
        final data = jsonDecode(notificationResponse.payload!);
        _handleNotificationData(data);
      } catch (e) {
        log('Error parsing notification payload: $e');
      }
    }
  }

  /// Handle notification action based on data
  Future<void> _handleNotificationAction(RemoteMessage message) async {
    _handleNotificationData(message.data);
  }

  /// Handle notification data and perform actions
  void _handleNotificationData(Map<String, dynamic> data) {
    log('Handling notification data: $data');
    
    // Handle different types of notifications based on data
    final String? type = data['type'];
    
    switch (type) {
      case 'ipo_update':
        // Navigate to IPO details
        _navigateToIPODetails(data['ipo_id']);
        break;
      case 'news':
        // Navigate to news
        _navigateToNews(data['news_id']);
        break;
      case 'general':
        // Handle general notifications
        break;
      default:
        log('Unknown notification type: $type');
    }
  }

  /// Navigate to IPO details
  void _navigateToIPODetails(String? ipoId) {
    if (ipoId != null) {
      log('Navigate to IPO details: $ipoId');
      // Implement navigation logic here
    }
  }

  /// Navigate to news
  void _navigateToNews(String? newsId) {
    if (newsId != null) {
      log('Navigate to news: $newsId');
      // Implement navigation logic here
    }
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      log('Subscribed to topic: $topic');
    } catch (e) {
      log('Error subscribing to topic $topic: $e');
    }
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      log('Unsubscribed from topic: $topic');
    } catch (e) {
      log('Error unsubscribing from topic $topic: $e');
    }
  }

  /// Get saved FCM token from SharedPreferences
  Future<String?> getSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('fcm_token');
  }

  /// Send token to server (implement based on your backend)
  Future<void> sendTokenToServer(String token) async {
    try {
      // Implement your server API call here
      log('Sending token to server: $token');
      
      // Example:
      // final response = await http.post(
      //   Uri.parse('your-server-endpoint'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: jsonEncode({'token': token}),
      // );
    } catch (e) {
      log('Error sending token to server: $e');
    }
  }
}
