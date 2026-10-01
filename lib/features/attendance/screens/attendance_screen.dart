// lib/features/attendance/screens/attendance_screen.dart
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/consts/app_colors.dart';
import '../../../core/global_widgets/custom_text.dart';
import '../../../core/global_widgets/app_bar_widget.dart';
import '../../../core/models/attendance_model.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _subjects = SubjectAttendance.dummyList;

  double get _overallPercentage {
    final total = _subjects.fold(0, (sum, s) => sum + s.totalClasses);
    final present = _subjects.fold(0, (sum, s) => sum + s.presentCount);
    return total > 0 ? present / total : 0;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: MyCampusAppBar(
        title: 'Attendance',
        showBack: false,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.borderColor),
                ),
                child: const Icon(Icons.download_rounded,
                    color: AppColors.textSecondary, size: 18),
              ),
              onPressed: () {},
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Summary'),
            Tab(text: 'Detailed'),
          ],
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textHint,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
          ),
        ),
        bottomHeight: 46,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSummaryTab(),
          _buildDetailedTab(),
        ],
      ),
    );
  }

  Widget _buildSummaryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Overall Card
          FadeInDown(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircularPercentIndicator(
                    radius: 55,
                    lineWidth: 8,
                    percent: _overallPercentage,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          '${(_overallPercentage * 100).toStringAsFixed(1)}%',
                          type: TextType.headlineSmall,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                        const CustomText(
                          'Overall',
                          type: TextType.labelSmall,
                          color: Colors.white70,
                          fontSize: 10,
                        ),
                      ],
                    ),
                    progressColor: Colors.white,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(
                          'Attendance Overview',
                          type: TextType.titleLarge,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                        const SizedBox(height: 8),
                        _buildStatRow('Total Classes',
                            '${_subjects.fold(0, (s, x) => s + x.totalClasses)}',
                            Colors.white70),
                        _buildStatRow('Present',
                            '${_subjects.fold(0, (s, x) => s + x.presentCount)}',
                            Colors.greenAccent),
                        _buildStatRow('Absent',
                            '${_subjects.fold(0, (s, x) => s + x.absentCount)}',
                            Colors.redAccent),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: _overallPercentage >= 0.75
                                ? Colors.green.withOpacity(0.25)
                                : Colors.red.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CustomText(
                            _overallPercentage >= 0.75
                                ? '✅ Safe to attend exams'
                                : '⚠️ Below minimum threshold',
                            type: TextType.labelSmall,
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Chart
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText('Subject-wise Attendance',
                      type: TextType.titleMedium),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 180,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 100,
                        barTouchData: BarTouchData(enabled: true),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (val, _) {
                                final codes = _subjects
                                    .map((s) => s.subjectCode.split('-').last)
                                    .toList();
                                return Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(
                                    codes[val.toInt()],
                                    style: const TextStyle(
                                      color: AppColors.textHint,
                                      fontSize: 10,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawHorizontalLine: true,
                          horizontalInterval: 25,
                          getDrawingHorizontalLine: (_) => FlLine(
                            color: AppColors.borderColor,
                            strokeWidth: 1,
                          ),
                          drawVerticalLine: false,
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: _subjects.asMap().entries.map((e) {
                          final pct = e.value.percentage;
                          return BarChartGroupData(
                            x: e.key,
                            barRods: [
                              BarChartRodData(
                                toY: pct,
                                gradient: LinearGradient(
                                  colors: pct < 75
                                      ? [AppColors.error, AppColors.error.withOpacity(0.6)]
                                      : [AppColors.accent, AppColors.primary],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                                width: 28,
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(8)),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLegend(AppColors.accent, 'Sufficient'),
                      const SizedBox(width: 20),
                      _buildLegend(AppColors.error, 'Below 75%'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // At Risk
          if (_subjects.any((s) => s.isCritical)) ...[
            FadeInUp(
              delay: const Duration(milliseconds: 300),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.error.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.warning_amber_rounded,
                            color: AppColors.error, size: 18),
                        SizedBox(width: 8),
                        CustomText('At Risk Subjects',
                            type: TextType.titleSmall,
                            color: AppColors.error,
                            fontWeight: FontWeight.w700),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ..._subjects
                        .where((s) => s.isCritical)
                        .map((s) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  const Icon(Icons.circle,
                                      color: AppColors.error, size: 6),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: CustomText(s.subject,
                                        type: TextType.bodyMedium,
                                        color: AppColors.textPrimary),
                                  ),
                                  CustomText(
                                    '${s.percentage.toStringAsFixed(1)}%',
                                    type: TextType.titleSmall,
                                    color: AppColors.error,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ],
                              ),
                            )),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailedTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _subjects.length,
      itemBuilder: (_, i) {
        final subject = _subjects[i];
        return FadeInUp(
          delay: Duration(milliseconds: i * 100),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: subject.isCritical
                    ? AppColors.error.withOpacity(0.3)
                    : AppColors.borderColor,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: (subject.isCritical
                                ? AppColors.error
                                : AppColors.accent)
                            .withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: CustomText(
                          subject.subjectCode.split('-').last,
                          type: TextType.titleSmall,
                          color: subject.isCritical
                              ? AppColors.error
                              : AppColors.accent,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(subject.subject,
                              type: TextType.titleSmall,
                              fontWeight: FontWeight.w700),
                          const SizedBox(height: 2),
                          CustomText(
                            subject.teacher,
                            type: TextType.bodySmall,
                            fontSize: 12,
                            color: AppColors.textHint,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustomText(
                          '${subject.percentage.toStringAsFixed(1)}%',
                          type: TextType.titleLarge,
                          color: subject.isCritical
                              ? AppColors.error
                              : subject.isWarning
                                  ? AppColors.warning
                                  : AppColors.success,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                        CustomText(
                          '${subject.presentCount}/${subject.totalClasses}',
                          type: TextType.labelSmall,
                          color: AppColors.textHint,
                          fontSize: 11,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: subject.percentage / 100,
                    backgroundColor: AppColors.bgSurface,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      subject.isCritical
                          ? AppColors.error
                          : subject.isWarning
                              ? AppColors.warning
                              : AppColors.success,
                    ),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMiniStat('Present', subject.presentCount, AppColors.success),
                    _buildMiniStat('Absent', subject.absentCount, AppColors.error),
                    _buildMiniStat('Late', subject.lateCount, AppColors.warning),
                    _buildMiniStat('Total', subject.totalClasses, AppColors.info),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          CustomText(label, type: TextType.bodySmall,
              color: Colors.white60, fontSize: 11),
          const SizedBox(width: 6),
          CustomText(value, type: TextType.labelMedium,
              color: color, fontWeight: FontWeight.w700),
        ],
      ),
    );
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
        ),
        const SizedBox(width: 6),
        CustomText(label, type: TextType.labelSmall, color: AppColors.textHint, fontSize: 11),
      ],
    );
  }

  Widget _buildMiniStat(String label, int value, Color color) {
    return Column(
      children: [
        CustomText(
          '$value',
          type: TextType.titleMedium,
          color: color,
          fontWeight: FontWeight.w700,
        ),
        const SizedBox(height: 2),
        CustomText(label, type: TextType.labelSmall,
            color: AppColors.textHint, fontSize: 10),
      ],
    );
  }
}
