// lib/features/profile/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/consts/app_colors.dart';
import '../../../core/global_widgets/custom_text.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../auth/screens/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final String name = user?.name ?? 'Unknown User';
    final String initials = user?.initials ?? 'U';
    final String id = user?.studentId ?? 'N/A';
    final String semester = user?.semester ?? 'N/A';
    
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: CustomScrollView(
        slivers: [
          // Hero App Bar
          SliverAppBar(
            backgroundColor: AppColors.bgDark,
            expandedHeight: 260,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFF00D4AA)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -40,
                      top: -40,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.06),
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const CustomText('Profile',
                                    type: TextType.headlineSmall,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                                IconButton(
                                  onPressed: () {},
                                  icon: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(Icons.edit_rounded,
                                        color: Colors.white, size: 18),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Avatar
                            Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                gradient: AppColors.accentGradient,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                                border: Border.all(
                                    color: Colors.white, width: 3),
                              ),
                              child: Center(
                                child: CustomText(
                                  initials,
                                  type: TextType.headlineLarge,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 28,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            CustomText(
                              name,
                              type: TextType.headlineSmall,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Stats Row
                  FadeInUp(
                    child: Row(
                      children: [
                        _buildStat('CGPA', '3.72', AppColors.primary),
                        const SizedBox(width: 10),
                        _buildStat('Attendance', '85%', AppColors.success),
                        const SizedBox(width: 10),
                        _buildStat('Semester', '5th', AppColors.info),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Info Section
                  FadeInUp(
                    delay: const Duration(milliseconds: 100),
                    child: _buildInfoSection(context),
                  ),

                  const SizedBox(height: 16),

                  // Settings
                  FadeInUp(
                    delay: const Duration(milliseconds: 200),
                    child: _buildSection(
                      'Settings',
                      [
                        const _MenuItem(icon: Icons.notifications_rounded,
                            label: 'Notifications', color: AppColors.primary),
                        const _MenuItem(icon: Icons.security_rounded,
                            label: 'Privacy & Security', color: AppColors.info),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // More
                  FadeInUp(
                    delay: const Duration(milliseconds: 300),
                    child: _buildSection(
                      'More',
                      [
                        const _MenuItem(icon: Icons.help_outline_rounded,
                            label: 'Help & Support', color: AppColors.warning),
                        const _MenuItem(icon: Icons.info_outline_rounded,
                            label: 'About MyCampus', color: AppColors.textHint),
                        const _MenuItem(icon: Icons.star_outline_rounded,
                            label: 'Rate Us', color: AppColors.warning),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Logout
                  FadeInUp(
                    delay: const Duration(milliseconds: 400),
                    child: GestureDetector(
                      onTap: () {
                        context.read<AuthProvider>().signOut();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()),
                          (_) => false,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: AppColors.error.withOpacity(0.2)),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout_rounded,
                                color: AppColors.error, size: 20),
                            SizedBox(width: 10),
                            CustomText(
                              'Sign Out',
                              type: TextType.titleMedium,
                              color: AppColors.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                  const CustomText(
                    'MyCampus v1.0.0',
                    type: TextType.bodySmall,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            CustomText(value,
                type: TextType.headlineSmall,
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 18),
            const SizedBox(height: 2),
            CustomText(label,
                type: TextType.labelSmall,
                color: AppColors.textHint,
                fontSize: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText('Academic Information',
              type: TextType.titleMedium, fontWeight: FontWeight.w700),
          const SizedBox(height: 14),
          _buildInfoRow('Student ID', user?.studentId ?? 'N/A'),
          _buildInfoRow('Department', user?.department ?? 'N/A'),
          _buildInfoRow('Batch', user?.batch ?? 'N/A'),
          _buildInfoRow('Section', user?.section ?? 'N/A'),
          _buildInfoRow('Email', user?.email ?? 'N/A'),
          _buildInfoRow('Phone', user?.phone ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: CustomText(label,
                type: TextType.bodySmall,
                color: AppColors.textHint,
                fontSize: 12),
          ),
          Expanded(
            child: CustomText(value,
                type: TextType.bodyMedium,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
                fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<_MenuItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: CustomText(title,
                type: TextType.titleMedium, fontWeight: FontWeight.w700),
          ),
          ...items.asMap().entries.map((entry) {
            final i = entry.key;
            final item = entry.value;
            return Column(
              children: [
                if (i > 0)
                  const Divider(
                    color: AppColors.borderColor,
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
                ListTile(
                  leading: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: item.color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(item.icon, color: item.color, size: 18),
                  ),
                  title: CustomText(item.label,
                      type: TextType.titleSmall, fontSize: 14),
                  trailing: const Icon(Icons.chevron_right_rounded,
                      color: AppColors.textHint, size: 20),
                  onTap: () {},
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ],
            );
          }),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final Color color;
  const _MenuItem({required this.icon, required this.label, required this.color});
}
