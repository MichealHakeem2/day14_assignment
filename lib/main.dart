import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/core/local_storage/cache_helper.dart';
import 'package:shopping_app/core/routes/app_routes.dart';
import 'package:shopping_app/core/services/notification_service.dart';
import 'package:shopping_app/core/theme/app_theme.dart';
import 'package:shopping_app/features/app_section/screens/app_section.dart';
import 'package:shopping_app/features/auth/presentation/view/login_view.dart';
import 'package:shopping_app/features/auth/presentation/view/register_view.dart';
import 'package:shopping_app/features/home/presentation/product_search_screen.dart';
import 'package:shopping_app/features/notifications/presentation/notifications_demo_screen.dart';
import 'package:shopping_app/features/splash/splash_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWebNoWebWorker;
  }

  await NotificationService.instance.init();

  await CacheHelper.loadTokenFromStorage();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.register: (context) => const RegisterView(),
        AppRoutes.login: (context) => const LoginView(),
        AppRoutes.home: (context) => const AppSection(),
        AppRoutes.appSection: (context) => const AppSection(),
        AppRoutes.mainLayout: (context) => const AppSection(),
        AppRoutes.productSearch: (context) => const ProductSearchScreen(),
        AppRoutes.notifications: (context) => const NotificationsDemoScreen(),
      },
    );
  }
}
