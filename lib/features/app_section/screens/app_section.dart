import 'package:flutter/material.dart';
import 'package:shopping_app/core/constants/app_assets.dart';
import 'package:shopping_app/core/constants/app_colors.dart';
import 'package:shopping_app/features/account/presentation/view/account_screen.dart';
import 'package:shopping_app/features/cart/presentation/view/cart_screen.dart';
import 'package:shopping_app/features/favorite/presentation/view/favorite_screen.dart';
import 'package:shopping_app/features/home/presentation/view/home_screen.dart';

class AppSection extends StatefulWidget {
  const AppSection({super.key});

  @override
  State<AppSection> createState() => _AppSectionState();
}

class _AppSectionState extends State<AppSection> {
  int index = 0;

  final List<Widget> screens = const [
    HomeScreen(),
    CartScreen(),
    FavoriteScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (selectedIndex) {
          index = selectedIndex;
          setState(() {});
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(AppAssets.homeIcons, width: 24, height: 24),
            activeIcon: Image.asset(
              AppAssets.homeIcons,
              width: 24,
              height: 24,
              color: AppColors.primary,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(AppAssets.cartIcons, width: 24, height: 24),
            activeIcon: Image.asset(
              AppAssets.cartIcons,
              width: 24,
              height: 24,
              color: AppColors.primary,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(AppAssets.favoriteIcons, width: 24, height: 24),
            activeIcon: Image.asset(
              AppAssets.favoriteIcons,
              width: 24,
              height: 24,
              color: AppColors.primary,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(AppAssets.profileIcons, width: 24, height: 24),
            activeIcon: Image.asset(
              AppAssets.profileIcons,
              width: 24,
              height: 24,
              color: AppColors.primary,
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}

