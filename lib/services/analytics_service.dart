import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // Log custom events
  static Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    await _analytics.logEvent(
      name: name,
      parameters: parameters,
    );
  }

  // Log screen views
  static Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );
  }

  // Log user properties
  static Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    await _analytics.setUserProperty(
      name: name,
      value: value,
    );
  }

  // Log IPO-specific events
  static Future<void> logIPOView({
    required String ipoName,
    required String ipoType, // 'mainboard' or 'sme'
  }) async {
    await logEvent(
      name: 'ipo_view',
      parameters: {
        'ipo_name': ipoName,
        'ipo_type': ipoType,
      },
    );
  }

  static Future<void> logIPOApply({
    required String ipoName,
    required String ipoType,
  }) async {
    await logEvent(
      name: 'ipo_apply',
      parameters: {
        'ipo_name': ipoName,
        'ipo_type': ipoType,
      },
    );
  }

  static Future<void> logNewsView({
    required String newsTitle,
    required String newsCategory,
  }) async {
    await logEvent(
      name: 'news_view',
      parameters: {
        'news_title': newsTitle,
        'news_category': newsCategory,
      },
    );
  }

  static Future<void> logUserSignIn({
    required String signInMethod,
  }) async {
    await _analytics.logLogin(loginMethod: signInMethod);
  }

  static Future<void> logUserSignUp({
    required String signUpMethod,
  }) async {
    await _analytics.logSignUp(signUpMethod: signUpMethod);
  }
}
