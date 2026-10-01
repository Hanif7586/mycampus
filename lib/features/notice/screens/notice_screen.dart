// lib/features/notice/screens/notice_screen.dart
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import '../../../core/consts/app_colors.dart';
import '../../../core/global_widgets/custom_text.dart';
import '../../../core/global_widgets/app_bar_widget.dart';
import '../../../core/global_widgets/loading_shimmer.dart';
import '../../../core/models/notice_model.dart';
import '../../../core/providers/notice_provider.dart';

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({super.key});

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchCtrl = TextEditingController();
  bool _isLoading = false;
  String _searchQuery = '';

  final List<String> _categories = [
    'All', 'Exam', 'Event', 'Finance', 'Library', 'IT', 'General'
  ];
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _simulateLoad();
  }

  void _simulateLoad() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  List<NoticeModel> _getFilteredNotices(List<NoticeModel> notices) {
    return notices.where((n) {
      final matchesSearch = _searchQuery.isEmpty ||
          n.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          n.body.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == 'All' || n.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: MyCampusAppBar(
        title: 'Notices',
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
                child: const Icon(Icons.tune_rounded,
                    color: AppColors.textSecondary, size: 18),
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          FadeInDown(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.borderColor),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 14),
                    const Icon(Icons.search_rounded,
                        color: AppColors.textHint, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _searchCtrl,
                        onChanged: (v) => setState(() => _searchQuery = v),
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Search notices...',
                          hintStyle: TextStyle(
                            color: AppColors.textHint,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Category Chips
          FadeInDown(
            delay: const Duration(milliseconds: 100),
            child: SizedBox(
              height: 38,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                itemBuilder: (_, i) {
                  final cat = _categories[i];
                  final isSelected = cat == _selectedCategory;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
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
                          cat,
                          type: TextType.labelMedium,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Content
          Expanded(
            child: Consumer<NoticeProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading || _isLoading) {
                  return const NoticeShimmer();
                }
                final filtered = _getFilteredNotices(provider.notices);
                if (filtered.isEmpty) {
                  return const Center(
                    child: CustomText(
                      'No notices found',
                      type: TextType.titleMedium,
                      color: AppColors.textHint,
                    ),
                  );
                }
                return AnimationLimiter(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 400),
                        child: SlideAnimation(
                          verticalOffset: 30,
                          child: FadeInAnimation(
                            child: _buildNoticeCard(filtered[index]),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
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

    return GestureDetector(
      onTap: () => _showNoticeDetail(notice),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: notice.isPinned
                ? AppColors.primary.withOpacity(0.3)
                : AppColors.borderColor,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
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
                      color: priorityColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _categoryIcon(notice.category),
                      color: priorityColor,
                      size: 20,
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
                                notice.title,
                                type: TextType.titleSmall,
                                fontWeight: FontWeight.w700,
                                maxLines: 1,
                              ),
                            ),
                            if (notice.isPinned)
                              const Padding(
                                padding: EdgeInsets.only(left: 4),
                                child: Icon(Icons.push_pin_rounded,
                                    color: AppColors.primary, size: 16),
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        CustomText(
                          notice.postedBy,
                          type: TextType.bodySmall,
                          fontSize: 11,
                          color: AppColors.textHint,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: priorityColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: priorityColor.withOpacity(0.3)),
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
              const SizedBox(height: 10),
              CustomText(
                notice.body,
                type: TextType.bodySmall,
                maxLines: 2,
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.bgSurface,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: CustomText(
                      notice.category,
                      type: TextType.labelSmall,
                      color: AppColors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.access_time_rounded,
                      size: 12, color: AppColors.textHint),
                  const SizedBox(width: 4),
                  CustomText(
                    DateFormat('MMM d, y').format(notice.createdAt),
                    type: TextType.bodySmall,
                    fontSize: 11,
                    color: AppColors.textHint,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNoticeDetail(NoticeModel notice) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _NoticeDetailSheet(notice: notice),
    );
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'Exam': return Icons.quiz_rounded;
      case 'Event': return Icons.event_rounded;
      case 'Finance': return Icons.account_balance_rounded;
      case 'Library': return Icons.local_library_rounded;
      case 'IT': return Icons.computer_rounded;
      default: return Icons.campaign_rounded;
    }
  }
}

class _NoticeDetailSheet extends StatelessWidget {
  final NoticeModel notice;
  const _NoticeDetailSheet({required this.notice});

  @override
  Widget build(BuildContext context) {
    final priorityColor = {
      NoticePriority.urgent: AppColors.error,
      NoticePriority.high: AppColors.warning,
      NoticePriority.medium: AppColors.info,
      NoticePriority.low: AppColors.success,
    }[notice.priority] ?? AppColors.info;

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
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: priorityColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: priorityColor.withOpacity(0.3)),
                        ),
                        child: CustomText(
                          notice.priority.name.toUpperCase(),
                          type: TextType.labelSmall,
                          color: priorityColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.bgSurface,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: CustomText(
                          notice.category,
                          type: TextType.labelSmall,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CustomText(notice.title, type: TextType.headlineSmall, fontWeight: FontWeight.w700),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.person_outline_rounded, size: 14, color: AppColors.textHint),
                      const SizedBox(width: 4),
                      CustomText(notice.postedBy, type: TextType.bodySmall, color: AppColors.textHint),
                      const SizedBox(width: 16),
                      Icon(Icons.access_time_rounded, size: 14, color: AppColors.textHint),
                      const SizedBox(width: 4),
                      CustomText(
                        DateFormat('MMM d, y').format(notice.createdAt),
                        type: TextType.bodySmall,
                        color: AppColors.textHint,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(height: 1, color: AppColors.borderColor),
                  const SizedBox(height: 20),
                  CustomText(
                    notice.body,
                    type: TextType.bodyLarge,
                    color: AppColors.textSecondary,
                    lineHeight: 1.7,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
