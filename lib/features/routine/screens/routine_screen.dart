// lib/features/routine/screens/routine_screen.dart
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';
import '../../../core/consts/app_colors.dart';
import '../../../core/global_widgets/custom_text.dart';
import '../../../core/global_widgets/app_bar_widget.dart';
import '../../../core/models/routine_model.dart';
import '../../../core/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/consts/app_constants.dart';

class RoutineScreen extends StatefulWidget {
  const RoutineScreen({super.key});

  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  late String _selectedDay;
  late PageController _pageController;
  final List<String> _days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday'];

  @override
  void initState() {
    super.initState();
    final today = DateFormat('EEEE').format(DateTime.now());
    _selectedDay = _days.contains(today) ? today : _days.first;
    _pageController = PageController(initialPage: _days.indexOf(_selectedDay));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: const MyCampusAppBar(title: 'Class Routine'),
      body: Column(
        children: [
          // Info Card
          FadeInDown(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.school_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(
                          'CSE — 5th Semester, Section A',
                          type: TextType.titleSmall,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(height: 2),
                        CustomText(
                          'Batch 2022 • Updated ${DateFormat('MMM d').format(DateTime.now())}',
                          type: TextType.bodySmall,
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Day Selector
          FadeInLeft(
            delay: const Duration(milliseconds: 100),
            child: SizedBox(
              height: 68,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _days.length,
                itemBuilder: (_, i) {
                  final day = _days[i];
                  final isSelected = day == _selectedDay;
                  final dayDate = DateTime.now().add(
                    Duration(days: (i - _days.indexOf(DateFormat('EEEE').format(DateTime.now())))),
                  );
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedDay = day);
                      _pageController.animateToPage(i,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: isSelected ? AppColors.primaryGradient : null,
                        color: isSelected ? null : AppColors.bgCard,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : AppColors.borderColor,
                        ),
                        boxShadow: isSelected
                            ? [BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 10)]
                            : [],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            day.substring(0, 3).toUpperCase(),
                            type: TextType.titleSmall,
                            color: isSelected ? Colors.white : AppColors.textSecondary,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            fontSize: 12,
                          ),
                          const SizedBox(height: 2),
                          CustomText(
                            DateFormat('d').format(dayDate),
                            type: TextType.labelSmall,
                            color: isSelected ? Colors.white70 : AppColors.textHint,
                            fontSize: 11,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Slots
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestoreService.streamCollection(collection: AppConstants.routinesCollection, limit: 1),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: CustomText('No Routine Found', type: TextType.titleMedium, color: AppColors.textHint));
                }
                
                final _routine = RoutineModel.fromFirestore(snapshot.data!.docs.first);

                return PageView.builder(
                  controller: _pageController,
                  onPageChanged: (i) => setState(() => _selectedDay = _days[i]),
                  itemCount: _days.length,
                  itemBuilder: (_, i) {
                    final slots = _routine.getSlotsForDay(_days[i]);
                    if (slots.isEmpty) {
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
                              child: const Icon(Icons.weekend_rounded,
                                  color: AppColors.textHint, size: 40),
                            ),
                            const SizedBox(height: 16),
                            const CustomText('No Classes Today',
                                type: TextType.titleMedium,
                                color: AppColors.textHint),
                            const SizedBox(height: 6),
                            const CustomText('Enjoy your day off! 😎',
                                type: TextType.bodySmall,
                                color: AppColors.textMuted),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: slots.length,
                      itemBuilder: (_, j) => _buildSlotCard(slots[j], j),
                    );
                  },
                );
              }
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlotCard(ClassSlot slot, int index) {
    final typeColor = slot.isLab
        ? AppColors.warning
        : slot.isTutorial
            ? AppColors.info
            : AppColors.accent;

    final isOngoing = index == 0;

    return FadeInUp(
      delay: Duration(milliseconds: index * 100),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isOngoing
                ? AppColors.primary.withOpacity(0.3)
                : AppColors.borderColor,
          ),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Time Column
              Container(
                width: 72,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isOngoing
                      ? AppColors.primary.withOpacity(0.08)
                      : AppColors.bgCardLight,
                  borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(16)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      slot.startTime,
                      type: TextType.titleSmall,
                      fontSize: 12,
                      color: isOngoing ? AppColors.primary : AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      width: 1,
                      height: 12,
                      color: AppColors.borderColor,
                    ),
                    CustomText(
                      slot.endTime,
                      type: TextType.labelSmall,
                      fontSize: 11,
                      color: AppColors.textHint,
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CustomText(
                              slot.subject,
                              type: TextType.titleSmall,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (isOngoing)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const CustomText('Now',
                                  type: TextType.labelSmall,
                                  color: Colors.white,
                                  fontSize: 10),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.person_outline_rounded,
                              size: 13, color: AppColors.textHint),
                          const SizedBox(width: 4),
                          CustomText(slot.teacher,
                              type: TextType.bodySmall,
                              fontSize: 12,
                              color: AppColors.textSecondary),
                          const SizedBox(width: 12),
                          Icon(Icons.room_rounded,
                              size: 13, color: AppColors.textHint),
                          const SizedBox(width: 4),
                          CustomText(slot.room,
                              type: TextType.bodySmall,
                              fontSize: 12,
                              color: AppColors.textSecondary),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          CustomText(
                            slot.subjectCode,
                            type: TextType.labelSmall,
                            color: AppColors.textHint,
                            fontSize: 11,
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: typeColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CustomText(
                              slot.type.toUpperCase(),
                              type: TextType.labelSmall,
                              color: typeColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
