import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shopping_app/core/constants/app_assets.dart';
import 'package:shopping_app/core/constants/app_colors.dart';
import 'package:shopping_app/core/local_storage/cache_helper.dart';
import 'package:shopping_app/core/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        if (CacheHelper.hasToken()) {
          Navigator.pushReplacementNamed(context, AppRoutes.appSection);
        } else {
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppAssets.splash,
              width: 140,
              height: 140,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => Image.asset(
                AppAssets.logo,
                width: 140,
                height: 140,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Shopping',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Tagline Here',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.grey,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
