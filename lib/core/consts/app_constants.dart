// lib/core/consts/app_constants.dart
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'MyCampus';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Smart Digital Ecosystem';

  // Shared Preferences Keys
  static const String tokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  static const String userRoleKey = 'user_role';
  static const String themeKey = 'theme_mode';
  static const String onboardedKey = 'is_onboarded';
  static const String fcmTokenKey = 'fcm_token';

  // User Roles
  static const String roleStudent = 'student';
  static const String roleTeacher = 'teacher';
  static const String roleAdmin = 'admin';

  // Firestore Collections
  static const String usersCollection = 'users';
  static const String noticesCollection = 'notices';
  static const String routinesCollection = 'routines';
  static const String attendanceCollection = 'attendance';
  static const String resultsCollection = 'results';
  static const String assignmentsCollection = 'assignments';
  static const String eventsCollection = 'events';
  static const String coursesCollection = 'courses';
  static const String departmentsCollection = 'departments';
  static const String announcementsCollection = 'announcements';

  // API Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Animation Durations
  static const Duration shortAnim = Duration(milliseconds: 200);
  static const Duration mediumAnim = Duration(milliseconds: 350);
  static const Duration longAnim = Duration(milliseconds: 500);

  // Pagination
  static const int pageSize = 20;

  // Attendance
  static const double minAttendance = 75.0;

  // Days of Week
  static const List<String> daysOfWeek = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  static const List<String> shortDays = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
  ];

  // Semester
  static const List<String> semesters = [
    '1st Semester',
    '2nd Semester',
    '3rd Semester',
    '4th Semester',
    '5th Semester',
    '6th Semester',
    '7th Semester',
    '8th Semester',
  ];

  // Grade Scale
  static const Map<String, double> gradePoints = {
    'A+': 4.00,
    'A': 3.75,
    'A-': 3.50,
    'B+': 3.25,
    'B': 3.00,
    'B-': 2.75,
    'C+': 2.50,
    'C': 2.25,
    'D': 2.00,
    'F': 0.00,
  };
}
