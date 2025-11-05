import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/constants/colors.dart';
import 'core/services/api_service.dart';
import 'core/services/shared_prefs_service.dart';
import 'core/services/user_service.dart';
import 'features/auth/views/login_view.dart';
import 'features/home/views/home_view.dart';
import 'features/grammar/views/grammar_check_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  final sharedPrefsService = Get.put(SharedPrefsService(), permanent: true);
  await sharedPrefsService.onInit();

  final apiService = Get.put(ApiService(), permanent: true);
  apiService.onInit();

  final userService = Get.put(UserService(), permanent: true);
  await userService.onInit();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Grammar Checker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.textDark),
        ),
      ),
      getPages: [
        GetPage(
          name: '/login',
          page: () => const LoginView(),
        ),
        GetPage(
          name: '/home',
          page: () => const HomeView(),
        ),
        GetPage(
          name: '/grammar',
          page: () => const GrammarCheckView(),
        ),
      ],
      // Check authentication status
      initialRoute: Get.find<UserService>().isLoggedIn ? '/home' : '/login',
    );
  }
}
