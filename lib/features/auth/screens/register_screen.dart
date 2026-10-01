// lib/features/auth/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/consts/app_colors.dart';
import '../../../core/global_widgets/custom_text.dart';
import '../../../core/global_widgets/custom_text_field.dart';
import '../../../core/global_widgets/primary_button.dart';
import '../../../core/providers/auth_provider.dart';
import '../../home/screens/main_shell.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _studentIdCtrl = TextEditingController();

  String _selectedRole = 'student';
  String _selectedDepartment = 'CSE';
  String _selectedSemester = '1st Semester';
  String _selectedSection = 'A';

  final List<String> _departments = [
    'CSE', 'EEE', 'BBA', 'ENG', 'LAW', 'PHY', 'MATH'
  ];
  final List<String> _semesters = [
    '1st Semester', '2nd Semester', '3rd Semester', '4th Semester',
    '5th Semester', '6th Semester', '7th Semester', '8th Semester',
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _phoneCtrl.dispose();
    _studentIdCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<AuthProvider>();
    final success = await provider.register(
      name: _nameCtrl.text,
      email: _emailCtrl.text,
      password: _passwordCtrl.text,
      phone: _phoneCtrl.text,
      role: _selectedRole,
      department: _selectedDepartment,
      studentId: _studentIdCtrl.text,
      semester: _selectedSemester,
      section: _selectedSection,
    );
    if (success && mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainShell()),
        (_) => false,
      );
    } else if (mounted && provider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage!),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary, size: 16),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                FadeInLeft(
                  child: CustomText('Create Account 🎓', type: TextType.headlineMedium),
                ),
                const SizedBox(height: 6),
                FadeInLeft(
                  delay: const Duration(milliseconds: 100),
                  child: CustomText(
                    'Join MyCampus and streamline your academic journey',
                    type: TextType.bodyMedium,
                    color: AppColors.textHint,
                  ),
                ),

                const SizedBox(height: 28),

                // Role Toggle
                FadeInUp(
                  delay: const Duration(milliseconds: 150),
                  child: _buildRoleToggle(),
                ),
                const SizedBox(height: 20),

                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: CustomTextField(
                    label: 'Full Name',
                    hint: 'Hanif Ahmed',
                    controller: _nameCtrl,
                    textCapitalization: TextCapitalization.words,
                    prefixIcon: const Icon(Icons.person_outline_rounded,
                        color: AppColors.textHint, size: 20),
                    validator: (v) => v?.isEmpty == true ? 'Name is required' : null,
                  ),
                ),
                const SizedBox(height: 14),

                FadeInUp(
                  delay: const Duration(milliseconds: 250),
                  child: CustomTextField(
                    label: 'Email Address',
                    hint: 'student@university.edu',
                    controller: _emailCtrl,
                    isEmail: true,
                    prefixIcon: const Icon(Icons.email_outlined,
                        color: AppColors.textHint, size: 20),
                    validator: (v) {
                      if (v?.isEmpty == true) return 'Email is required';
                      if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v!)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 14),

                FadeInUp(
                  delay: const Duration(milliseconds: 300),
                  child: CustomTextField(
                    label: 'Phone Number',
                    hint: '017XXXXXXXX',
                    controller: _phoneCtrl,
                    isPhone: true,
                    prefixIcon: const Icon(Icons.phone_outlined,
                        color: AppColors.textHint, size: 20),
                    validator: (v) => v?.isEmpty == true ? 'Phone is required' : null,
                  ),
                ),
                const SizedBox(height: 14),

                if (_selectedRole == 'student') ...[
                  FadeInUp(
                    delay: const Duration(milliseconds: 320),
                    child: CustomTextField(
                      label: 'Student ID',
                      hint: '2022-CSE-001',
                      controller: _studentIdCtrl,
                      prefixIcon: const Icon(Icons.badge_outlined,
                          color: AppColors.textHint, size: 20),
                    ),
                  ),
                  const SizedBox(height: 14),
                ],

                // Department & Semester Dropdowns
                FadeInUp(
                  delay: const Duration(milliseconds: 340),
                  child: Row(
                    children: [
                      Expanded(child: _buildDropdown('Department', _departments, _selectedDepartment, (v) => setState(() => _selectedDepartment = v!))),
                      const SizedBox(width: 12),
                      if (_selectedRole == 'student')
                        Expanded(child: _buildDropdown('Section', ['A', 'B', 'C', 'D'], _selectedSection, (v) => setState(() => _selectedSection = v!))),
                    ],
                  ),
                ),

                if (_selectedRole == 'student') ...[
                  const SizedBox(height: 14),
                  FadeInUp(
                    delay: const Duration(milliseconds: 360),
                    child: _buildDropdown('Semester', _semesters, _selectedSemester, (v) => setState(() => _selectedSemester = v!), fullWidth: true),
                  ),
                ],

                const SizedBox(height: 14),

                FadeInUp(
                  delay: const Duration(milliseconds: 380),
                  child: CustomTextField(
                    label: 'Password',
                    hint: '••••••••',
                    controller: _passwordCtrl,
                    isPassword: true,
                    prefixIcon: const Icon(Icons.lock_outline_rounded,
                        color: AppColors.textHint, size: 20),
                    validator: (v) {
                      if (v?.isEmpty == true) return 'Password is required';
                      if ((v?.length ?? 0) < 6) return 'Minimum 6 characters';
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 28),

                FadeInUp(
                  delay: const Duration(milliseconds: 420),
                  child: Consumer<AuthProvider>(
                    builder: (_, provider, __) => PrimaryButton(
                      label: 'Create Account',
                      isLoading: provider.isLoading,
                      onPressed: _register,
                      suffixIcon: const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: RichText(
                      text: const TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(color: AppColors.textHint, fontSize: 13, fontFamily: 'Poppins'),
                        children: [
                          TextSpan(
                            text: 'Sign In',
                            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 13, fontFamily: 'Poppins'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: ['student', 'teacher'].map((role) {
          final isSelected = _selectedRole == role;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedRole = role),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: isSelected ? AppColors.primaryGradient : null,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isSelected
                      ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 8)]
                      : [],
                ),
                child: Center(
                  child: CustomText(
                    role == 'student' ? '🎓 Student' : '👨‍🏫 Teacher',
                    type: TextType.titleSmall,
                    color: isSelected ? Colors.white : AppColors.textHint,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    String value,
    ValueChanged<String?> onChanged, {
    bool fullWidth = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(label, type: TextType.labelMedium, color: AppColors.textSecondary),
        const SizedBox(height: 8),
        Container(
          width: fullWidth ? double.infinity : null,
          decoration: BoxDecoration(
            color: AppColors.bgCardLight,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textHint),
              dropdownColor: AppColors.bgCard,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              borderRadius: BorderRadius.circular(14),
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontFamily: 'Poppins',
              ),
              items: items
                  .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      ))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
