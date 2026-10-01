// lib/features/auth/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/consts/app_colors.dart';
import '../../../core/global_widgets/custom_text.dart';
import '../../../core/global_widgets/custom_text_field.dart';
import '../../../core/global_widgets/primary_button.dart';
import '../../../core/providers/auth_provider.dart';
import '../../home/screens/main_shell.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController(text: 'test@gmail.com');
  final _passwordCtrl = TextEditingController(text: '12345678');

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<AuthProvider>();
    final success = await provider.signIn(
      email: _emailCtrl.text,
      password: _passwordCtrl.text,
    );
    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainShell()),
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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height - MediaQuery.of(context).padding.top,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),

                    // Logo & Brand
                    FadeInDown(
                      duration: const Duration(milliseconds: 600),
                      child: Center(
                        child: Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.4),
                                    blurRadius: 24,
                                    offset: const Offset(0, 8),
                                  )
                                ],
                              ),
                              child: const Icon(
                                Icons.school_rounded,
                                color: Colors.white,
                                size: 44,
                              ),
                            ),
                            const SizedBox(height: 16),
                            CustomText(
                              'MyCampus',
                              type: TextType.headlineLarge,
                              isGradient: true,
                              gradientColors: [
                                AppColors.primary,
                                AppColors.accent
                              ],
                            ),
                            const SizedBox(height: 4),
                            CustomText(
                              'Smart Digital Ecosystem',
                              type: TextType.bodyMedium,
                              color: AppColors.textHint,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 48),

                    FadeInLeft(
                      delay: const Duration(milliseconds: 200),
                      child: CustomText(
                        'Welcome Back 👋',
                        type: TextType.headlineMedium,
                      ),
                    ),
                    const SizedBox(height: 6),
                    FadeInLeft(
                      delay: const Duration(milliseconds: 300),
                      child: CustomText(
                        'Sign in to your campus account',
                        type: TextType.bodyMedium,
                        color: AppColors.textHint,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Fields
                    FadeInUp(
                      delay: const Duration(milliseconds: 300),
                      child: CustomTextField(
                        label: 'Email Address',
                        hint: 'student@university.edu',
                        controller: _emailCtrl,
                        isEmail: true,
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: AppColors.textHint,
                          size: 20,
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Email is required';
                          }
                          if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(v)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    FadeInUp(
                      delay: const Duration(milliseconds: 400),
                      child: CustomTextField(
                        label: 'Password',
                        hint: '••••••••',
                        controller: _passwordCtrl,
                        isPassword: true,
                        prefixIcon: const Icon(
                          Icons.lock_outline_rounded,
                          color: AppColors.textHint,
                          size: 20,
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Password is required';
                          if (v.length < 6) return 'Minimum 6 characters';
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 12),
                    FadeInRight(
                      delay: const Duration(milliseconds: 500),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {},
                          child: CustomText(
                            'Forgot Password?',
                            type: TextType.labelMedium,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Login Button
                    FadeInUp(
                      delay: const Duration(milliseconds: 500),
                      child: Consumer<AuthProvider>(
                        builder: (_, provider, __) => PrimaryButton(
                          label: 'Sign In',
                          isLoading: provider.isLoading,
                          onPressed: _login,
                          suffixIcon: const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Demo Login
                    FadeInUp(
                      delay: const Duration(milliseconds: 600),
                      child: PrimaryButton(
                        label: 'Continue as Demo',
                        variant: ButtonVariant.outlined,
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => const MainShell()),
                          );
                        },
                        prefixIcon: const Icon(
                          Icons.play_circle_outline_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Register Link
                    FadeInUp(
                      delay: const Duration(milliseconds: 700),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const RegisterScreen(),
                              ),
                            );
                          },
                          child: RichText(
                            text: TextSpan(
                              text: "Don't have an account? ",
                              style: TextStyle(
                                color: AppColors.textHint,
                                fontSize: 13,
                                fontFamily: 'Poppins',
                              ),
                              children: [
                                TextSpan(
                                  text: 'Register',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
