// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/consts/app_theme.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/notice_provider.dart';
import 'features/splash/screens/splash_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF161728),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const MyCampusApp());
}

class MyCampusApp extends StatelessWidget {
  const MyCampusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NoticeProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812), // standard phone screen size
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'MyCampus',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            home: const SplashScreen(),
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: const TextScaler.linear(1.0),
                ),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}
