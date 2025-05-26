import 'package:ai_chatter/constants/Colors.dart';
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
  int _currentStep = 0;
  final Map<String, String> _setupData = {
    'personality': '',
    'gender': '',
    'ageGroup': '',
    'language': '',
    'relationship': '',
    'chattingStyle': '',
  };

  void _handleNext() {
    if (_currentStep < 5) {
      setState(() {
        _currentStep++;
      });
    } else {
      // TODO: Handle completion
      Navigator.pop(context, _setupData);
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
        return AIPersonalityStep(
          onNext: _handleNext,
          onPrevious: _handlePrevious,
          onUpdateData: (value) => _handleUpdateData('personality', value),
          initialValue: _setupData['personality']!,
        );
      case 1:
        return GenderStep(
          onNext: _handleNext,
          onPrevious: _handlePrevious,
          onUpdateData: (value) => _handleUpdateData('gender', value),
          initialValue: _setupData['gender']!,
        );
      case 2:
        return AgeGroupStep(
          onNext: _handleNext,
          onPrevious: _handlePrevious,
          onUpdateData: (value) => _handleUpdateData('ageGroup', value),
          initialValue: _setupData['ageGroup']!,
        );
      case 3:
        return LanguageStep(
          onNext: _handleNext,
          onPrevious: _handlePrevious,
          onUpdateData: (value) => _handleUpdateData('language', value),
          initialValue: _setupData['language']!,
        );
      case 4:
        return RelationshipStep(
          onNext: _handleNext,
          onPrevious: _handlePrevious,
          onUpdateData: (value) => _handleUpdateData('relationship', value),
          initialValue: _setupData['relationship']!,
        );
      case 5:
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
          'Chat Setup',
          style: TextStyle(
            fontSize: isSmallScreen ? FontSize.h5 : FontSize.h4,
          ),
        ),
        backgroundColor: ConstantColor.primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
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
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: (_currentStep + 1) / 6,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(height: isSmallScreen ? BoxSize.spacingM : BoxSize.spacingL),
                Expanded(
                  child: _buildStep(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 