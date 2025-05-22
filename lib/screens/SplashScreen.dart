import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ai_chatter/constants/FontSize.dart';
import 'package:ai_chatter/constants/BoxSize.dart';
import 'package:ai_chatter/screens/auth/LoginPage.dart';
import 'package:ai_chatter/screens/HomePage.dart';
import 'package:ai_chatter/screens/setup/user/UserSetupPage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
    _checkAuthState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkAuthState() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _navigateToLogin();
      return;
    }

    try {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!mounted) return;

      if (userData.exists && userData.data()?['isUserSet'] == true) {
        _navigateToHome();
      } else {
        _navigateToSetup();
      }
    } catch (e) {
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  void _navigateToSetup() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const UserSetupPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/character.png',
                        width: isSmallScreen ? size.width * 0.5 : size.width * 0.3,
                        height: isSmallScreen ? size.width * 0.5 : size.width * 0.3,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: BoxSize.spacingXL),
                      Text(
                        l10n.appTitle,
                        style: TextStyle(
                          fontSize: isSmallScreen ? FontSize.h1 : FontSize.h1 * 1.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: BoxSize.spacingL),
                      Text(
                        l10n.welcome,
                        style: TextStyle(
                          fontSize: isSmallScreen ? FontSize.h5 : FontSize.h4,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      SizedBox(height: BoxSize.spacingXXL),
                      SizedBox(
                        width: isSmallScreen ? 40 : 48,
                        height: isSmallScreen ? 40 : 48,
                        child: const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
} 