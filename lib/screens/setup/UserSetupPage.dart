import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ai_chatter/screens/HomePage.dart';
import 'package:ai_chatter/screens/setup/steps/NameSetupStep.dart';
import 'package:ai_chatter/screens/setup/steps/AgeGroupSetupStep.dart';
import 'package:ai_chatter/screens/setup/steps/GenderSetupStep.dart';
import 'package:ai_chatter/screens/setup/steps/NotificationSetupStep.dart';
import 'package:ai_chatter/constants/BoxSize.dart';

class UserSetupPage extends StatefulWidget {
  const UserSetupPage({super.key});

  @override
  State<UserSetupPage> createState() => _UserSetupPageState();
}

class _UserSetupPageState extends State<UserSetupPage> {
  int _currentStep = 0;
  String _name = '';
  String _ageGroup = '';
  String _gender = '';
  Map<String, bool> _notificationPreferences = {
    'newMessages': false,
    'appUpdates': false,
    'announcements': false,
  };

  Future<void> _completeSetup() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'name': _name,
      'ageGroup': _ageGroup,
      'gender': _gender,
      'notificationPreferences': _notificationPreferences,
      'isUserSet': true,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  bool _canMoveToNextStep() {
    switch (_currentStep) {
      case 0:
        return _name.trim().length >= 2;
      case 1:
        return _ageGroup.isNotEmpty;
      case 2:
        return _gender.isNotEmpty;
      case 3:
        return true; // Notifications are optional
      default:
        return false;
    }
  }

  void _nextStep() {
    if (!_canMoveToNextStep()) {
      return;
    }

    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
    } else {
      _completeSetup();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final horizontalPadding = isSmallScreen ? BoxSize.pagePadding : size.width * 0.1;
    final maxWidth = isSmallScreen ? double.infinity : 600.0;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: maxWidth,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: BoxSize.pagePadding,
            ),
            child: _currentStep == 0
                ? NameSetupStep(
                    onNameChanged: (name) => setState(() => _name = name),
                    onNext: _nextStep,
                    initialValue: _name,
                  )
                : _currentStep == 1
                    ? AgeGroupSetupStep(
                        onAgeGroupChanged: (ageGroup) =>
                            setState(() => _ageGroup = ageGroup),
                        onNext: _nextStep,
                        onBack: _previousStep,
                        initialValue: _ageGroup,
                      )
                    : _currentStep == 2
                        ? GenderSetupStep(
                            onNext: _nextStep,
                            onPrevious: _previousStep,
                            onUpdateData: (gender) => setState(() => _gender = gender),
                            initialValue: _gender,
                          )
                        : NotificationSetupStep(
                            onNotificationPreferencesChanged: (prefs) =>
                                setState(() => _notificationPreferences = prefs),
                            onNext: _nextStep,
                            onBack: _previousStep,
                            initialPreferences: _notificationPreferences,
                          ),
          ),
        ),
      ),
    );
  }
} 