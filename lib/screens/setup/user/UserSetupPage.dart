import 'package:ai_chatter/services/UserService.dart';
import 'package:flutter/material.dart';
import 'package:ai_chatter/screens/HomePage.dart';
import 'package:ai_chatter/screens/setup/user/steps/NameSetupStep.dart';
import 'package:ai_chatter/screens/setup/user/steps/AgeGroupSetupStep.dart';
import 'package:ai_chatter/screens/setup/user/steps/GenderSetupStep.dart';
import 'package:ai_chatter/screens/setup/user/steps/NotificationSetupStep.dart';
import 'package:ai_chatter/constants/BoxSize.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserSetupPage extends StatefulWidget {
  const UserSetupPage({super.key});

  @override
  State<UserSetupPage> createState() => _UserSetupPageState();
}

class _UserSetupPageState extends State<UserSetupPage> {
  final UserService _userService = UserService();
  int _currentStep = 0;
  String _name = '';
  String _ageGroup = '';
  String _gender = '';
  bool _notificationsEnabled = false;
  bool _isSubmitting = false;

  Future<void> _completeSetup() async {
    if (_isSubmitting) return;
    _isSubmitting = true;

    try {
      String enAgeGroup = convertAgeToEnValue(_ageGroup);
      String enGender = convertGenderToEnValue(_gender);

      await _userService.updateUser(_name, enAgeGroup, enGender, _notificationsEnabled);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } catch (e) {
      _isSubmitting = false;
      debugPrint('Setup failed: $e');
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

  String convertAgeToEnValue(String value) {
    final l10n = AppLocalizations.of(context)!;
    if (value == l10n.ageGroupUnder18) {
      return 'Under 18';
    }
    else if (value == l10n.ageGroup18to24) {
      return '18-24';
    }
    else if (value == l10n.ageGroup25to34) {
      return '25-34';
    }
    else if (value == l10n.ageGroup35to44) {
      return '35-44';
    }
    else if (value == l10n.ageGroup45to54) {
      return '45-54';
    }
    else if (value == l10n.ageGroup55Plus) {
      return '55+';
    }
    return value;
  }

  String convertGenderToEnValue(String value) {
    final l10n = AppLocalizations.of(context)!;
    if (value == l10n.male) {
      return 'Male';
    }
    else if (value == l10n.female) {
      return 'Female';
    }
    return 'Unspecified';
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
                    onPrevious: _previousStep,
                    initialValue: _name,
                  )
                : _currentStep == 1
                    ? AgeGroupSetupStep(
                        onAgeGroupChanged: (ageGroup) =>
                            setState(() => _ageGroup = ageGroup),
                        onNext: _nextStep,
                        onPrevious: _previousStep,
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
                            onChanged: (value) => setState(() => _notificationsEnabled = value),
                            onNext: _nextStep,
                            onPrevious: _previousStep,
                            initialValue: _notificationsEnabled,
                          ),
          ),
        ),
      ),
    );
  }
} 