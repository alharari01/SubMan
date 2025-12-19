import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'providers/subscription_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final showOnboarding = prefs.getBool('showOnboarding') ?? true;
  
  runApp(MyApp(showOnboarding: showOnboarding));
}

class MyApp extends StatelessWidget {
  final bool showOnboarding;
  
  const MyApp({super.key, required this.showOnboarding});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'SubMan',
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.light,
              scaffoldBackgroundColor: AppColors.backgroundLight,
              colorScheme: const ColorScheme.light(
                primary: AppColors.primary,
                surface: AppColors.backgroundLight,
                onSurface: AppColors.textLight,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.transparent,
                foregroundColor: AppColors.textLight,
                elevation: 0,
              ),
              cardColor: Colors.white,
              dividerColor: Colors.grey.shade200,
              textTheme: GoogleFonts.manropeTextTheme(
                ThemeData.light().textTheme,
              ),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              scaffoldBackgroundColor: AppColors.backgroundDark,
              colorScheme: const ColorScheme.dark(
                primary: AppColors.primary,
                surface: AppColors.surfaceDark,
                onSurface: AppColors.textDark,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.transparent,
                foregroundColor: AppColors.textDark,
                elevation: 0,
              ),
              cardColor: AppColors.surfaceDark,
              dividerColor: Colors.grey.shade800,
              textTheme: GoogleFonts.manropeTextTheme(
                ThemeData.dark().textTheme,
              ).apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
              ),
            ),
            home: showOnboarding ? const OnboardingScreen() : const HomeScreen(),
          );
        },
      ),
    );
  }
}
