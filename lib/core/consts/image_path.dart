// lib/core/consts/image_path.dart
class ImagePath {
  ImagePath._();

  static const String _base = 'assets/images/';
  static const String _anim = 'assets/animations/';

  // Logos & Branding
  static const String logo = '${_base}logo.png';
  static const String logoWhite = '${_base}logo_white.png';
  static const String splash = '${_base}splash_bg.png';

  // Onboarding
  static const String onboarding1 = '${_base}onboarding1.png';
  static const String onboarding2 = '${_base}onboarding2.png';
  static const String onboarding3 = '${_base}onboarding3.png';

  // Avatars / Profile
  static const String defaultAvatar = '${_base}default_avatar.png';
  static const String studentAvatar = '${_base}student_avatar.png';
  static const String teacherAvatar = '${_base}teacher_avatar.png';

  // Feature Illustrations
  static const String noNotice = '${_base}no_notice.png';
  static const String noResult = '${_base}no_result.png';
  static const String noEvent = '${_base}no_event.png';
  static const String noAssignment = '${_base}no_assignment.png';
  static const String emptyState = '${_base}empty_state.png';

  // Campus
  static const String campusMap = '${_base}campus_map.png';
  static const String campusBg = '${_base}campus_bg.png';

  // Animations (Lottie)
  static const String loadingAnim = '${_anim}loading.json';
  static const String successAnim = '${_anim}success.json';
  static const String errorAnim = '${_anim}error.json';
  static const String arAnim = '${_anim}ar_scan.json';
  static const String confettiAnim = '${_anim}confetti.json';
}
