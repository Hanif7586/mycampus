// lib/features/assignment/screens/assignment_screen.dart
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';
import '../../../core/consts/app_colors.dart';
import '../../../core/global_widgets/custom_text.dart';
import '../../../core/global_widgets/app_bar_widget.dart';
import '../../../core/global_widgets/status_badge.dart';
import '../../../core/models/assignment_model.dart';

class AssignmentScreen extends StatefulWidget {
  const AssignmentScreen({super.key});

  @override
  State<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<AssignmentModel> _assignments;

  @override
  void initState() {
    super.initState();
    _assignments = List.from(AssignmentModel.dummyList);
    _tabController = TabController(length: 3, vsync: this);
  }

  void _submitAssignment(AssignmentModel assignment) {
    setState(() {
      final index = _assignments.indexWhere((a) => a.id == assignment.id);
      if (index != -1) {
        _assignments[index] = AssignmentModel(
          id: assignment.id,
          title: assignment.title,
          description: assignment.description,
          subjectCode: assignment.subjectCode,
          subject: assignment.subject,
          teacher: assignment.teacher,
          department: assignment.department,
          semester: assignment.semester,
          deadline: assignment.deadline,
          createdAt: assignment.createdAt,
          totalMarks: assignment.totalMarks,
          status: AssignmentStatus.submitted,
          attachments: assignment.attachments,
        );
      }
    });
    Navigator.pop(context); // Close bottom sheet
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Assignment Submitted Successfully! 🎉'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<AssignmentModel> _filterByStatus(AssignmentStatus status) =>
      _assignments.where((a) => a.status == status).toList();

  @override
  Widget build(BuildContext context) {
    final pending = _filterByStatus(AssignmentStatus.pending);
    final submitted = _filterByStatus(AssignmentStatus.submitted);
    final graded = _filterByStatus(AssignmentStatus.graded);

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: MyCampusAppBar(
        title: 'Assignments',
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Pending (${pending.length})'),
            Tab(text: 'Submitted'),
            Tab(text: 'Graded'),
          ],
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textHint,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottomHeight: 46,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const CustomText('Submit', type: TextType.labelMedium,
            color: Colors.white),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildList(pending, AssignmentStatus.pending),
          _buildList(submitted, AssignmentStatus.submitted),
          _buildList(graded, AssignmentStatus.graded),
        ],
      ),
    );
  }

  Widget _buildList(List<AssignmentModel> items, AssignmentStatus status) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.assignment_turned_in_rounded,
                  color: AppColors.textHint, size: 40),
            ),
            const SizedBox(height: 16),
            CustomText(
              status == AssignmentStatus.pending
                  ? 'All caught up! 🎉'
                  : 'Nothing here yet',
              type: TextType.titleMedium,
              color: AppColors.textHint,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (_, i) => FadeInUp(
        delay: Duration(milliseconds: i * 100),
        child: _buildCard(items[i]),
      ),
    );
  }

  Widget _buildCard(AssignmentModel assignment) {
    final statusBadge = {
      AssignmentStatus.pending: BadgeStatus.pending,
      AssignmentStatus.submitted: BadgeStatus.submitted,
      AssignmentStatus.graded: BadgeStatus.graded,
      AssignmentStatus.late: BadgeStatus.absent,
    }[assignment.status] ?? BadgeStatus.pending;

    final isOverdue = assignment.isOverdue;
    final daysLeft = assignment.daysLeft;

    Color urgencyColor = AppColors.success;
    if (isOverdue) {
      urgencyColor = AppColors.error;
    } else if (daysLeft <= 2) {
      urgencyColor = AppColors.warning;
    }

    return GestureDetector(
      onTap: () => _showDetail(assignment),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isOverdue
                ? AppColors.error.withOpacity(0.3)
                : AppColors.borderColor,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.assignmentColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.assignment_rounded,
                        color: AppColors.assignmentColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          assignment.title,
                          type: TextType.titleSmall,
                          fontWeight: FontWeight.w700,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 2),
                        CustomText(
                          '${assignment.subject} • ${assignment.teacher}',
                          type: TextType.bodySmall,
                          fontSize: 11,
                          color: AppColors.textHint,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  StatusBadge(status: statusBadge),
                ],
              ),
              const SizedBox(height: 10),
              CustomText(
                assignment.description,
                type: TextType.bodySmall,
                maxLines: 2,
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.calendar_today_rounded,
                      size: 13, color: urgencyColor),
                  const SizedBox(width: 5),
                  CustomText(
                    'Due: ${DateFormat('MMM d, y').format(assignment.deadline)}',
                    type: TextType.bodySmall,
                    color: urgencyColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  const Spacer(),
                  if (assignment.totalMarks != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.bgSurface,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: CustomText(
                        assignment.status == AssignmentStatus.graded
                            ? '${assignment.obtainedMarks?.toInt()}/${assignment.totalMarks?.toInt()} marks'
                            : '${assignment.totalMarks?.toInt()} marks',
                        type: TextType.labelSmall,
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
              if (assignment.status == AssignmentStatus.pending && !isOverdue) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: urgencyColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.hourglass_empty_rounded,
                          size: 12, color: urgencyColor),
                      const SizedBox(width: 5),
                      CustomText(
                        daysLeft == 0
                            ? 'Due today!'
                            : '$daysLeft days remaining',
                        type: TextType.labelSmall,
                        color: urgencyColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showDetail(AssignmentModel assignment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AssignmentDetailSheet(
        assignment: assignment,
        onSubmit: () => _submitAssignment(assignment),
      ),
    );
  }
}

class _AssignmentDetailSheet extends StatelessWidget {
  final AssignmentModel assignment;
  final VoidCallback? onSubmit;

  const _AssignmentDetailSheet({required this.assignment, this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.assignmentColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.assignment_rounded,
                            color: AppColors.assignmentColor, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(assignment.title,
                                type: TextType.titleLarge,
                                fontWeight: FontWeight.w700),
                            CustomText(assignment.subject,
                                type: TextType.bodySmall,
                                color: AppColors.textHint),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(height: 1, color: AppColors.borderColor),
                  const SizedBox(height: 20),
                  CustomText(assignment.description,
                      type: TextType.bodyMedium,
                      color: AppColors.textSecondary,
                      lineHeight: 1.6),
                  const SizedBox(height: 20),
                  _infoRow(Icons.person_outline_rounded,
                      'Teacher', assignment.teacher),
                  const SizedBox(height: 10),
                  _infoRow(Icons.calendar_today_rounded, 'Deadline',
                      DateFormat('MMM d, y • h:mm a').format(assignment.deadline)),
                  const SizedBox(height: 10),
                  _infoRow(Icons.grading_rounded, 'Total Marks',
                      '${assignment.totalMarks?.toInt()} marks'),
                  if (assignment.status == AssignmentStatus.graded) ...[
                    const SizedBox(height: 10),
                    _infoRow(Icons.check_circle_outline_rounded,
                        'Obtained',
                        '${assignment.obtainedMarks?.toInt()}/${assignment.totalMarks?.toInt()} marks',
                        color: AppColors.success),
                  ],
                  const SizedBox(height: 24),
                  if (assignment.status == AssignmentStatus.pending)
                    Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onSubmit ?? () => Navigator.pop(context),
                          borderRadius: BorderRadius.circular(14),
                          child: const Center(
                            child: CustomText(
                              'Submit Assignment',
                              type: TextType.labelLarge,
                              color: Colors.white,
                            ),
                          ),
                        ),
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

  Widget _infoRow(IconData icon, String label, String value,
      {Color? color}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textHint),
        const SizedBox(width: 8),
        CustomText('$label: ', type: TextType.bodySmall,
            color: AppColors.textHint),
        Expanded(
          child: CustomText(value, type: TextType.bodyMedium,
              color: color ?? AppColors.textPrimary,
              fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
