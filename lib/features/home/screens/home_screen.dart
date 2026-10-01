// lib/features/home/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/consts/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/global_widgets/custom_text.dart';
import '../../../core/global_widgets/gradient_card.dart';
import '../../../core/global_widgets/section_header.dart';
import '../../../core/models/notice_model.dart';
import '../../notice/screens/notice_screen.dart';
import '../../routine/screens/routine_screen.dart';
import '../../attendance/screens/attendance_screen.dart';
import '../../result/screens/result_screen.dart';
import '../../assignment/screens/assignment_screen.dart';
import '../../ar_mode/screens/ar_screen.dart';
import '../../library/screens/library_screen.dart';
import '../../event/screens/event_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _notices = NoticeModel.dummyList.take(3).toList();

  final List<_QuickItem> _quickItems = [
    _QuickItem(icon: Icons.campaign_rounded, label: 'Notices', color: AppColors.noticeColor, screen: 'notice'),
    _QuickItem(icon: Icons.schedule_rounded, label: 'Routine', color: AppColors.routineColor, screen: 'routine'),
    _QuickItem(icon: Icons.how_to_reg_rounded, label: 'Attendance', color: AppColors.attendanceColor, screen: 'attendance'),
    _QuickItem(icon: Icons.bar_chart_rounded, label: 'Results', color: AppColors.resultColor, screen: 'result'),
    _QuickItem(icon: Icons.assignment_rounded, label: 'Assignments', color: AppColors.assignmentColor, screen: 'assignment'),
    _QuickItem(icon: Icons.event_rounded, label: 'Events', color: AppColors.eventColor, screen: 'event'),
    _QuickItem(icon: Icons.view_in_ar_rounded, label: 'AR Mode', color: AppColors.primary, screen: 'ar'),
    _QuickItem(icon: Icons.local_library_rounded, label: 'Library', color: AppColors.libraryColor, screen: 'library'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildBanner(),
                _buildQuickAccess(),
                _buildTodaySchedule(),
                _buildRecentNotices(),
                _buildAttendanceOverview(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    final now = DateTime.now();
    final hour = now.hour;
    
    String greeting;
    String emoji;
    if (hour >= 5 && hour < 12) {
      greeting = 'Good Morning';
      emoji = '☀️';
    } else if (hour >= 12 && hour < 17) {
      greeting = 'Good Afternoon';
      emoji = '🌤️';
    } else if (hour >= 17 && hour < 21) {
      greeting = 'Good Evening';
      emoji = '🌅';
    } else {
      greeting = 'Good Night';
      emoji = '🌙';
    }

    final user = context.watch<AuthProvider>().user;
    final userName = user?.name ?? 'Welcome';
    final userInitials = user?.initials ?? 'U';

    return SliverAppBar(
      backgroundColor: AppColors.bgDark,
      pinned: true,
      expandedHeight: 100,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          padding: const EdgeInsets.fromLTRB(20, 56, 20, 0),
          child: Row(
            children: [
              Expanded(
                child: FadeInLeft(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        '$greeting $emoji',
                        type: TextType.titleMedium,
                        color: AppColors.textSecondary,
                      ),
                      CustomText(
                        userName,
                        type: TextType.headlineSmall,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                ),
              ),
              FadeInRight(
                child: Row(
                  children: [
                    _buildIconBtn(Icons.search_rounded, () {}),
                    const SizedBox(width: 8),
                    Stack(
                      children: [
                        _buildIconBtn(Icons.notifications_rounded, () {}),
                        Positioned(
                          right: 4,
                          top: 4,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.bgDark, width: 1.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(13),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.4),
                              blurRadius: 10,
                            )
                          ],
                        ),
                        child: Center(
                          child: CustomText(userInitials, type: TextType.titleSmall,
                              color: Colors.white),
                        ),
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

  Widget _buildIconBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Icon(icon, color: AppColors.textSecondary, size: 20),
      ),
    );
  }

  Widget _buildBanner() {
    return FadeInUp(
      delay: const Duration(milliseconds: 100),
      child: Container(
        margin: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
        height: 160.h,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6C63FF), Color(0xFF3ECFAB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
            Positioned(
              right: 40,
              bottom: -30,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.06),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const CustomText(
                      '🎯  Mid-Term Exams',
                      type: TextType.labelSmall,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const CustomText(
                    'Check your exam\nschedule now!',
                    type: TextType.headlineSmall,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded,
                          color: Colors.white70, size: 14),
                      const SizedBox(width: 4),
                      CustomText(
                        DateFormat('EEEE, MMM d').format(DateTime.now()),
                        type: TextType.labelSmall,
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccess() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Quick Access'),
          const SizedBox(height: 16),
          AnimationLimiter(
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 12.h,
                crossAxisSpacing: 12.w,
                childAspectRatio: 0.75, // Adjust ratio to prevent overflow
              ),
              itemCount: _quickItems.length,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: const Duration(milliseconds: 400),
                  columnCount: 4,
                  child: ScaleAnimation(
                    child: FadeInAnimation(
                      child: _buildQuickItem(_quickItems[index]),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickItem(_QuickItem item) {
    return GestureDetector(
      onTap: () => _navigateTo(item.screen),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: item.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: item.color.withOpacity(0.2)),
              ),
              child: Icon(item.icon, color: item.color, size: 26.sp),
            ),
            SizedBox(height: 7.h),
            Expanded(
              child: CustomText(
                item.label,
                type: TextType.labelSmall,
                color: AppColors.textSecondary,
                textAlign: TextAlign.center,
                maxLines: 1,
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodaySchedule() {
    final slots = [
      {'sub': 'Software Engineering', 'time': '08:00 - 09:30', 'room': 'R-301', 'type': 'Lecture'},
      {'sub': 'Computer Networks', 'time': '09:45 - 11:15', 'room': 'R-205', 'type': 'Lecture'},
      {'sub': 'Database Lab', 'time': '11:30 - 13:30', 'room': 'Lab-01', 'type': 'Lab'},
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: FadeInUp(
        delay: const Duration(milliseconds: 200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              title: "Today's Classes",
              actionLabel: 'Full Routine',
              onAction: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const RoutineScreen())),
            ),
            const SizedBox(height: 14),
            ...slots.asMap().entries.map((entry) {
              final i = entry.key;
              final slot = entry.value;
              final isNow = i == 0;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isNow
                      ? AppColors.primary.withOpacity(0.1)
                      : AppColors.bgCard,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isNow ? AppColors.primary.withOpacity(0.3) : AppColors.borderColor,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isNow ? AppColors.primary : AppColors.bgSurface,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: CustomText(
                                  slot['sub']!,
                                  type: TextType.titleSmall,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (isNow)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const CustomText('Live', type: TextType.labelSmall,
                                      color: Colors.white, fontSize: 10),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.access_time_rounded, size: 12, color: AppColors.textHint),
                              const SizedBox(width: 4),
                              CustomText(slot['time']!, type: TextType.bodySmall, fontSize: 11),
                              const SizedBox(width: 12),
                              Icon(Icons.room_rounded, size: 12, color: AppColors.textHint),
                              const SizedBox(width: 4),
                              CustomText(slot['room']!, type: TextType.bodySmall, fontSize: 11),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: slot['type'] == 'Lab'
                            ? AppColors.warning.withOpacity(0.12)
                            : AppColors.accent.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomText(
                        slot['type']!,
                        type: TextType.labelSmall,
                        color: slot['type'] == 'Lab' ? AppColors.warning : AppColors.accent,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentNotices() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: FadeInUp(
        delay: const Duration(milliseconds: 300),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              title: 'Recent Notices',
              actionLabel: 'See All',
              onAction: () {},
            ),
            const SizedBox(height: 14),
            ..._notices.map((notice) => _buildNoticeCard(notice)),
          ],
        ),
      ),
    );
  }

  Widget _buildNoticeCard(NoticeModel notice) {
    final priorityColor = {
      NoticePriority.urgent: AppColors.error,
      NoticePriority.high: AppColors.warning,
      NoticePriority.medium: AppColors.info,
      NoticePriority.low: AppColors.success,
    }[notice.priority] ?? AppColors.info;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: priorityColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              notice.isPinned ? Icons.push_pin_rounded : Icons.campaign_rounded,
              color: priorityColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  notice.title,
                  type: TextType.titleSmall,
                  maxLines: 1,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    CustomText(
                      notice.postedBy,
                      type: TextType.bodySmall,
                      fontSize: 11,
                      color: AppColors.textHint,
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 3,
                      height: 3,
                      decoration: const BoxDecoration(
                        color: AppColors.textMuted,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    CustomText(
                      _timeAgo(notice.createdAt),
                      type: TextType.bodySmall,
                      fontSize: 11,
                      color: AppColors.textHint,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: priorityColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: CustomText(
              notice.priority.name.toUpperCase(),
              type: TextType.labelSmall,
              color: priorityColor,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceOverview() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: FadeInUp(
        delay: const Duration(milliseconds: 400),
        child: GradientCard(
          gradientColors: [
            AppColors.bgCard,
            AppColors.bgCardLight,
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText('Attendance Overview', type: TextType.titleMedium),
                  GestureDetector(
                    onTap: () {},
                    child: const CustomText('Details →', type: TextType.labelSmall,
                        color: AppColors.primary, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildAttStat('Overall', '85%', AppColors.success),
                  const SizedBox(width: 12),
                  _buildAttStat('This Month', '78%', AppColors.warning),
                  const SizedBox(width: 12),
                  _buildAttStat('At Risk', '2', AppColors.error),
                ],
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: 0.85,
                  backgroundColor: AppColors.bgSurface,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 6),
              const CustomText(
                'Min. 75% required to sit for exams',
                type: TextType.bodySmall,
                color: AppColors.textHint,
                fontSize: 11,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttStat(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            CustomText(value, type: TextType.headlineSmall, color: color, fontSize: 18),
            const SizedBox(height: 2),
            CustomText(label, type: TextType.labelSmall, color: AppColors.textHint, fontSize: 10),
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  void _navigateTo(String screen) {
    Widget? dest;
    switch (screen) {
      case 'notice':
        dest = const NoticeScreen();
        break;
      case 'routine':
        dest = const RoutineScreen();
        break;
      case 'attendance':
        dest = const AttendanceScreen();
        break;
      case 'result':
        dest = const ResultScreen();
        break;
      case 'assignment':
        dest = const AssignmentScreen();
        break;
      case 'ar':
        dest = const ArScreen();
        break;
      case 'library':
        dest = const LibraryScreen();
        break;
      case 'event':
        dest = const EventScreen();
        break;
      default:
        return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => dest!));
  }
}

class _QuickItem {
  final IconData icon;
  final String label;
  final Color color;
  final String screen;

  const _QuickItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.screen,
  });
}
