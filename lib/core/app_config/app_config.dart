// lib/core/app_config/app_config.dart
class AppConfig {
  AppConfig._();

  // Environment
  static const bool isDevelopment = true;
  static const bool isProduction = false;

  // App Settings
  static const String appName = 'MyCampus';
  static const String packageName = 'com.mycampus.app';
  static const String appVersion = '1.0.0';
  static const int buildNumber = 1;

  // Firebase Project
  static const String projectId = 'mycampus-2026';
  static const String firebaseRegion = 'asia-south1';

  // Feature Flags
  static const bool enableAR = true;
  static const bool enablePushNotifications = true;
  static const bool enableOfflineMode = true;
  static const bool enableAnalytics = true;
  static const bool enableChatSupport = false;

  // API Config
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 2);
  static const Duration cacheDuration = Duration(hours: 1);

  // UI Config
  static const bool enableAnimations = true;
  static const bool enableHapticFeedback = true;
  static const double defaultBorderRadius = 14;
  static const double cardElevation = 0;

  // Attendance Config
  static const double minimumAttendancePercent = 75.0;
  static const double warningAttendancePercent = 80.0;

  // Result Config
  static const double minimumPassGPA = 2.0;
  static const int maxSemester = 8;

  // Cache Keys
  static const String routineCacheKey = 'routine_cache';
  static const String noticesCacheKey = 'notices_cache';
  static const String resultCacheKey = 'result_cache';
}
