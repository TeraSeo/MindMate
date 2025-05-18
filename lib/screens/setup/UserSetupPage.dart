import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ai_chatter/screens/HomePage.dart';
import 'package:ai_chatter/screens/setup/steps/NameSetupStep.dart';
import 'package:ai_chatter/screens/setup/steps/AgeGroupSetupStep.dart';
import 'package:ai_chatter/screens/setup/steps/GenderSetupStep.dart';
import 'package:ai_chatter/screens/setup/steps/NotificationSetupStep.dart';

class UserSetupPage extends StatefulWidget {
  const UserSetupPage({super.key});

  @override
  State<UserSetupPage> createState() => _UserSetupPageState();
}

class _UserSetupPageState extends State<UserSetupPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final Map<String, dynamic> _userData = {
    'name': '',
    'ageGroup': '20s',
    'gender': 'Male',
    'pushNotificationEnabled': true,
  };

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage++;
      });
    } else {
      _saveUserSettings();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage--;
      });
    }
  }

  void _updateUserData(String key, dynamic value) {
    setState(() {
      _userData[key] = value;
    });
  }

  Future<void> _saveUserSettings() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'name': _userData['name'],
          'ageGroup': _userData['ageGroup'],
          'gender': _userData['gender'],
          'pushNotificationEnabled': _userData['pushNotificationEnabled'],
          'isUserSet': true,
        });

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save user settings. Please try again.')),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (_currentPage + 1) / 4,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  NameSetupStep(
                    onNext: _nextPage,
                    onUpdateData: (value) => _updateUserData('name', value),
                  ),
                  AgeGroupSetupStep(
                    onNext: _nextPage,
                    onPrevious: _previousPage,
                    onUpdateData: (value) => _updateUserData('ageGroup', value),
                    initialValue: _userData['ageGroup'],
                  ),
                  GenderSetupStep(
                    onNext: _nextPage,
                    onPrevious: _previousPage,
                    onUpdateData: (value) => _updateUserData('gender', value),
                    initialValue: _userData['gender'],
                  ),
                  NotificationSetupStep(
                    onComplete: _nextPage,
                    onPrevious: _previousPage,
                    onUpdateData: (value) => _updateUserData('pushNotificationEnabled', value),
                    initialValue: _userData['pushNotificationEnabled'],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 