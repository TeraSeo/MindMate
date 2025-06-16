import 'package:ai_chatter/constants/Colors.dart';
import 'package:ai_chatter/screens/HomePage.dart';
import 'package:ai_chatter/screens/setup/chat/steps/AINameSetupStep.dart';
import 'package:ai_chatter/services/CharacterService.dart';
import 'package:ai_chatter/widgets/characters/ChatSetupBody.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ai_chatter/constants/BoxSize.dart';
import 'package:ai_chatter/constants/FontSize.dart';
import 'package:ai_chatter/screens/setup/chat/steps/AIPersonalityStep.dart';
import 'package:ai_chatter/screens/setup/chat/steps/GenderStep.dart';
import 'package:ai_chatter/screens/setup/chat/steps/AgeGroupStep.dart';
import 'package:ai_chatter/screens/setup/chat/steps/LanguageStep.dart';
import 'package:ai_chatter/screens/setup/chat/steps/RelationshipStep.dart';
import 'package:ai_chatter/screens/setup/chat/steps/ChattingStyleStep.dart';

class ChatSetupPage extends StatefulWidget {
  const ChatSetupPage({super.key});

  @override
  State<ChatSetupPage> createState() => _ChatSetupPageState();
}

class _ChatSetupPageState extends State<ChatSetupPage> {
  final CharacterService _chatService = CharacterService();

  int _currentStep = 0;
  final Map<String, String> _setupData = {
    'name': '',
    'personality': '',
    'gender': '',
    'ageGroup': '',
    'language': '',
    'relationship': '',
    'chattingStyle': '',
  };
  bool _isSubmitting = false;

  Future<void> _completeSetup() async {
    if (_isSubmitting) return;
    _isSubmitting = true;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await _chatService.createCharacter(user.uid, _setupData);

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

  void _handleNext() {
    if (_currentStep < 6) {
      setState(() {
        _currentStep++;
      });
    } else {
      _completeSetup();
    }
  }

  void _handlePrevious() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _handleUpdateData(String key, String value) {
    setState(() {
      _setupData[key] = value;
    });
  }

  Widget _buildStep() {
    switch (_currentStep) {
      case 0:
        return AINameSetupStep(
          onNext: _handleNext,
          onPrevious: _handlePrevious,
          onUpdateData: (value) => _handleUpdateData('name', value),
          initialValue: _setupData['name']!,
        );
      case 1:
        return AIPersonalityStep(
          onNext: _handleNext,
          onPrevious: _handlePrevious,
          onUpdateData: (value) => _handleUpdateData('personality', value),
          initialValue: _setupData['personality']!,
        );
      case 2:
        return GenderStep(
          onNext: _handleNext,
          onPrevious: _handlePrevious,
          onUpdateData: (value) => _handleUpdateData('gender', value),
          initialValue: _setupData['gender']!,
        );
      case 3:
        return AgeGroupStep(
          onNext: _handleNext,
          onPrevious: _handlePrevious,
          onUpdateData: (value) => _handleUpdateData('ageGroup', value),
          initialValue: _setupData['ageGroup']!,
        );
      case 4:
        return LanguageStep(
          onNext: _handleNext,
          onPrevious: _handlePrevious,
          onUpdateData: (value) => _handleUpdateData('language', value),
          initialValue: _setupData['language']!,
        );
      case 5:
        return RelationshipStep(
          onNext: _handleNext,
          onPrevious: _handlePrevious,
          onUpdateData: (value) => _handleUpdateData('relationship', value),
          initialValue: _setupData['relationship']!,
        );
      case 6:
        return ChattingStyleStep(
          onNext: _handleNext,
          onPrevious: _handlePrevious,
          onUpdateData: (value) => _handleUpdateData('chattingStyle', value),
          initialValue: _setupData['chattingStyle']!,
        );
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final horizontalPadding = isSmallScreen ? BoxSize.pagePadding : size.width * 0.1;
    final maxWidth = isSmallScreen ? double.infinity : 600.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.chatSetup,
          style: TextStyle(
            fontSize: isSmallScreen ? FontSize.h5 : FontSize.h4,
          ),
        ),
        backgroundColor: ConstantColor.primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ChatSetupBody(buildStep: _buildStep, currentStep: _currentStep, horizontalPadding: horizontalPadding, maxWidth: maxWidth)
    );
  }
} 