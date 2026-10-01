// lib/features/result/screens/result_screen.dart
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/consts/app_colors.dart';
import '../../../core/global_widgets/custom_text.dart';
import '../../../core/global_widgets/app_bar_widget.dart';
import '../../../core/models/result_model.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _result = ResultModel.dummy;
  final List<String> _semesters = [
    '1st', '2nd', '3rd', '4th', '5th'
  ];
  String _selectedSemester = '5th';

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
        title: 'Academic Results',
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
          tabs: const [Tab(text: 'Semester'), Tab(text: 'Transcript')],
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textHint,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
              fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600),
        ),
        bottomHeight: 46,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSemesterTab(),
          _buildTranscriptTab(),
        ],
      ),
    );
  }

  Widget _buildSemesterTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // GPA Hero Card
          FadeInDown(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4CA3FF), Color(0xFF6C63FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.info.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText('5th Semester Result',
                            type: TextType.titleMedium, color: Colors.white70),
                        const SizedBox(height: 4),
                        CustomText(
                          'SGPA: ${_result.sgpa.toStringAsFixed(2)}',
                          type: TextType.headlineLarge,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 28,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: CustomText(
                            _getGrade(_result.sgpa),
                            type: TextType.titleMedium,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const CustomText('Cumulative',
                          type: TextType.bodySmall, color: Colors.white70),
                      CustomText(
                        'CGPA: ${_result.cgpa.toStringAsFixed(2)}',
                        type: TextType.titleLarge,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                      const SizedBox(height: 16),
                      const CustomText('Dept. Rank',
                          type: TextType.bodySmall, color: Colors.white70),
                      const CustomText(
                        '#12',
                        type: TextType.titleLarge,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Semester Selector
          FadeInUp(
            delay: const Duration(milliseconds: 150),
            child: SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _semesters.length,
                itemBuilder: (_, i) {
                  final sem = _semesters[i];
                  final isSelected = sem == _selectedSemester;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedSemester = sem),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        gradient: isSelected ? AppColors.primaryGradient : null,
                        color: isSelected ? null : AppColors.bgCard,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : AppColors.borderColor,
                        ),
                      ),
                      child: Center(
                        child: CustomText(
                          '$sem Sem',
                          type: TextType.labelMedium,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Mark Distribution Chart
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
                  const CustomText('Grade Distribution',
                      type: TextType.titleMedium),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 160,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 4,
                        centerSpaceRadius: 40,
                        sections: _buildPieSections(),
                        pieTouchData: PieTouchData(enabled: true),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      _buildLegend(AppColors.success, 'A+ / A'),
                      _buildLegend(AppColors.info, 'A- / B+'),
                      _buildLegend(AppColors.warning, 'B / B-'),
                      _buildLegend(AppColors.error, 'C+ and below'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Course List
          const SectionTitle(title: 'Course-wise Result'),
          const SizedBox(height: 12),

          ..._result.courses.asMap().entries.map((entry) {
            final i = entry.key;
            final course = entry.value;
            return FadeInUp(
              delay: Duration(milliseconds: i * 80),
              child: _buildCourseCard(course),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTranscriptTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          FadeInDown(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText('Academic Transcript',
                      type: TextType.titleLarge, fontWeight: FontWeight.w700),
                  const SizedBox(height: 4),
                  const CustomText('CSE Department • Batch 2022',
                      type: TextType.bodySmall, color: AppColors.textHint),
                  const SizedBox(height: 16),
                  Container(height: 1, color: AppColors.borderColor),
                  const SizedBox(height: 16),
                  // GPA History
                  SizedBox(
                    height: 180,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 1,
                          getDrawingHorizontalLine: (_) => FlLine(
                            color: AppColors.borderColor,
                            strokeWidth: 1,
                          ),
                        ),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (val, _) => Text(
                                '${val.toInt() + 1}st',
                                style: const TextStyle(
                                  color: AppColors.textHint,
                                  fontSize: 10,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 36,
                              getTitlesWidget: (val, _) => Text(
                                val.toStringAsFixed(1),
                                style: const TextStyle(
                                  color: AppColors.textHint,
                                  fontSize: 10,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        minX: 0,
                        maxX: 4,
                        minY: 0,
                        maxY: 4,
                        lineBarsData: [
                          LineChartBarData(
                            spots: const [
                              FlSpot(0, 3.5),
                              FlSpot(1, 3.6),
                              FlSpot(2, 3.4),
                              FlSpot(3, 3.75),
                              FlSpot(4, 3.64),
                            ],
                            isCurved: true,
                            gradient: AppColors.heroGradient,
                            barWidth: 3,
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (_, __, ___, ____) =>
                                  FlDotCirclePainter(
                                radius: 4,
                                color: AppColors.primary,
                                strokeWidth: 2,
                                strokeColor: Colors.white,
                              ),
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primary.withOpacity(0.3),
                                  AppColors.primary.withOpacity(0.0),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Center(
                    child: CustomText(
                      'SGPA Trend by Semester',
                      type: TextType.bodySmall,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Summary Table
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16)),
                    ),
                    child: const Row(
                      children: [
                        Expanded(flex: 3, child: CustomText('Subject', type: TextType.labelMedium, color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
                        Expanded(child: CustomText('Mid', type: TextType.labelMedium, color: AppColors.textPrimary, fontWeight: FontWeight.w700, textAlign: TextAlign.center)),
                        Expanded(child: CustomText('Final', type: TextType.labelMedium, color: AppColors.textPrimary, fontWeight: FontWeight.w700, textAlign: TextAlign.center)),
                        Expanded(child: CustomText('Grade', type: TextType.labelMedium, color: AppColors.textPrimary, fontWeight: FontWeight.w700, textAlign: TextAlign.center)),
                        Expanded(child: CustomText('GP', type: TextType.labelMedium, color: AppColors.textPrimary, fontWeight: FontWeight.w700, textAlign: TextAlign.center)),
                      ],
                    ),
                  ),
                  ..._result.courses.asMap().entries.map((entry) {
                    final c = entry.value;
                    final isOdd = entry.key % 2 == 0;
                    return Container(
                      color: isOdd ? AppColors.bgCard : AppColors.bgCardLight,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: CustomText(c.subject,
                                type: TextType.bodySmall,
                                maxLines: 1,
                                fontSize: 11),
                          ),
                          Expanded(
                            child: CustomText('${c.midMark.toInt()}',
                                type: TextType.bodySmall,
                                textAlign: TextAlign.center,
                                fontSize: 12),
                          ),
                          Expanded(
                            child: CustomText('${c.finalMark.toInt()}',
                                type: TextType.bodySmall,
                                textAlign: TextAlign.center,
                                fontSize: 12),
                          ),
                          Expanded(
                            child: CustomText(c.grade,
                                type: TextType.titleSmall,
                                color: _gradeColor(c.grade),
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.w700,
                                fontSize: 13),
                          ),
                          Expanded(
                            child: CustomText(
                                c.gradePoint.toStringAsFixed(2),
                                type: TextType.bodySmall,
                                textAlign: TextAlign.center,
                                fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  }),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: const BoxDecoration(
                      color: AppColors.bgSurface,
                      borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(16)),
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          flex: 3,
                          child: CustomText('SGPA',
                              type: TextType.titleSmall,
                              fontWeight: FontWeight.w700),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        Expanded(child: Container()),
                        Expanded(
                          child: CustomText(
                            _result.sgpa.toStringAsFixed(2),
                            type: TextType.titleLarge,
                            color: AppColors.success,
                            textAlign: TextAlign.center,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Expanded(child: Container()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(CourseResult course) {
    final gradeColor = _gradeColor(course.grade);
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
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: gradeColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: CustomText(course.grade,
                  type: TextType.titleLarge,
                  color: gradeColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 16),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(course.subject,
                    type: TextType.titleSmall, fontWeight: FontWeight.w600),
                const SizedBox(height: 3),
                Row(
                  children: [
                    CustomText(course.subjectCode,
                        type: TextType.bodySmall,
                        color: AppColors.textHint,
                        fontSize: 11),
                    const SizedBox(width: 8),
                    CustomText('• ${course.creditHours} Credit',
                        type: TextType.bodySmall,
                        color: AppColors.textHint,
                        fontSize: 11),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildMarkChip('Mid', course.midMark.toInt(), AppColors.info),
                    const SizedBox(width: 6),
                    _buildMarkChip('Final', course.finalMark.toInt(), AppColors.accent),
                    const SizedBox(width: 6),
                    _buildMarkChip('Total', course.totalMark.toInt(), gradeColor),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              CustomText(course.gradePoint.toStringAsFixed(2),
                  type: TextType.headlineSmall,
                  color: gradeColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 20),
              const CustomText('GP', type: TextType.labelSmall,
                  color: AppColors.textHint, fontSize: 10),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMarkChip(String label, int mark, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$label: $mark',
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 5),
        CustomText(label, type: TextType.labelSmall,
            color: AppColors.textHint, fontSize: 11),
      ],
    );
  }

  List<PieChartSectionData> _buildPieSections() {
    final counts = {'A+/A': 0, 'A-/B+': 0, 'B': 0, 'Other': 0};
    for (final c in _result.courses) {
      if (c.grade == 'A+' || c.grade == 'A') counts['A+/A'] = counts['A+/A']! + 1;
      else if (c.grade == 'A-' || c.grade == 'B+') counts['A-/B+'] = counts['A-/B+']! + 1;
      else if (c.grade == 'B' || c.grade == 'B-') counts['B'] = counts['B']! + 1;
      else counts['Other'] = counts['Other']! + 1;
    }
    final total = _result.courses.length.toDouble();
    return [
      PieChartSectionData(value: counts['A+/A']! / total * 100, color: AppColors.success, title: '${counts['A+/A']}', radius: 50, titleStyle: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700, fontFamily: 'Poppins')),
      PieChartSectionData(value: counts['A-/B+']! / total * 100, color: AppColors.info, title: '${counts['A-/B+']}', radius: 50, titleStyle: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700, fontFamily: 'Poppins')),
      PieChartSectionData(value: counts['B']! / total * 100, color: AppColors.warning, title: '${counts['B']}', radius: 50, titleStyle: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700, fontFamily: 'Poppins')),
    ];
  }

  Color _gradeColor(String grade) {
    if (grade == 'A+' || grade == 'A') return AppColors.success;
    if (grade == 'A-' || grade == 'B+') return AppColors.info;
    if (grade == 'B' || grade == 'B-') return AppColors.warning;
    if (grade == 'C+' || grade == 'C') return AppColors.attendanceColor;
    return AppColors.error;
  }

  String _getGrade(double gpa) {
    if (gpa >= 3.75) return 'Outstanding';
    if (gpa >= 3.50) return 'Excellent';
    if (gpa >= 3.00) return 'Very Good';
    if (gpa >= 2.50) return 'Good';
    return 'Satisfactory';
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return CustomText(title, type: TextType.titleLarge, fontWeight: FontWeight.w700);
  }
}
