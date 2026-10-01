// lib/features/splash/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/consts/app_colors.dart';
import '../../../core/global_widgets/custom_text.dart';
import '../../auth/screens/login_screen.dart';
import '../../home/screens/main_shell.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../firebase_options.dart';
import '../../../core/services/firestore_seeder.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();
    _initApp();
  }

  Future<void> _initApp() async {
    try {
      await FirestoreSeeder.seedInitialData();
    } catch (_) {}
    
    await Future.delayed(const Duration(milliseconds: 2800));
    
    if (mounted) {
      final auth = context.read<AuthProvider>();
      final Widget nextScreen = auth.isAuthenticated ? const MainShell() : const LoginScreen();
      
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, anim, __) => nextScreen,
          transitionsBuilder: (_, anim, __, child) => FadeTransition(
            opacity: anim,
            child: child,
          ),
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D0E1A), Color(0xFF151628)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // Background orbs
            Positioned(
              top: -100,
              right: -80,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -80,
              left: -60,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.accent.withOpacity(0.12),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Center Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  BounceInDown(
                    delay: const Duration(milliseconds: 200),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.5),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.school_rounded,
                        color: Colors.white,
                        size: 54,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // App Name
                  FadeInUp(
                    delay: const Duration(milliseconds: 600),
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [AppColors.primary, AppColors.accent],
                      ).createShader(bounds),
                      child: const Text(
                        'MyCampus',
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          letterSpacing: -1,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  FadeInUp(
                    delay: const Duration(milliseconds: 800),
                    child: const CustomText(
                      'Smart Digital Ecosystem',
                      type: TextType.bodyMedium,
                      color: AppColors.textHint,
                    ),
                  ),

                  const SizedBox(height: 60),

                  // Loading Indicator
                  FadeIn(
                    delay: const Duration(milliseconds: 1200),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 160,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: 1),
                              duration: const Duration(milliseconds: 2000),
                              builder: (_, value, __) => LinearProgressIndicator(
                                value: value,
                                backgroundColor:
                                    AppColors.primary.withOpacity(0.15),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    AppColors.primary),
                                minHeight: 3,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const CustomText(
                          'Initializing...',
                          type: TextType.labelSmall,
                          color: AppColors.textMuted,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Brand
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: FadeIn(
                delay: const Duration(milliseconds: 1000),
                child: const Column(
                  children: [
                    CustomText(
                      'Designed for Academic Excellence',
                      type: TextType.labelSmall,
                      color: AppColors.textMuted,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4),
                    CustomText(
                      'Version 1.0.0',
                      type: TextType.labelSmall,
                      color: AppColors.textMuted,
                      textAlign: TextAlign.center,
                      fontSize: 10,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
