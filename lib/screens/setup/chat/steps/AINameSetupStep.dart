import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ai_chatter/constants/BoxSize.dart';
import 'package:ai_chatter/constants/FontSize.dart';
import 'package:ai_chatter/screens/setup/BaseStep.dart';

class AINameSetupStep extends StatefulWidget {
  final Function(String) onUpdateData;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final String? initialValue;

  const AINameSetupStep({
    super.key,
    required this.onUpdateData,
    required this.onNext,
    required this.onPrevious,
    this.initialValue,
  });

  @override
  State<AINameSetupStep> createState() => _AINameSetupStepState();
}

class _AINameSetupStepState extends State<AINameSetupStep> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _nameController.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onUpdateData(_nameController.text.trim());
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final isMediumScreen = size.width >= 600 && size.width < 1200;

    final titleFontSize = isSmallScreen 
        ? FontSize.h5 
        : isMediumScreen 
            ? FontSize.h4 
            : FontSize.h3;
            
    final descriptionFontSize = isSmallScreen 
        ? FontSize.bodyMedium 
        : isMediumScreen 
            ? FontSize.bodyLarge 
            : FontSize.h6;
    final inputFontSize = isSmallScreen ? FontSize.bodyLarge : FontSize.h6;
    final buttonHeight = isSmallScreen ? BoxSize.buttonHeight : BoxSize.buttonHeight * 1.2;

    return BaseStep(
      onNext: _handleNext,
      onPrevious: widget.onPrevious,
      canProceed: _nameController.text.trim().length >= 2,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.aiNameStepTitle,
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: isSmallScreen ? BoxSize.spacingM : BoxSize.spacingL),
            Text(
              l10n.aiNameStepDescription,
              style: TextStyle(
                fontSize: descriptionFontSize,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: isSmallScreen ? BoxSize.spacingXL : BoxSize.spacingXXL),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.nameFieldLabel,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(BoxSize.inputRadius),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: BoxSize.inputPadding,
                  vertical: buttonHeight / 3.5,
                ),
              ),
              style: TextStyle(fontSize: inputFontSize),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.nameFieldError;
                }
                if (value.trim().length < 2) {
                  return l10n.nameFieldLengthError;
                }
                return null;
              },
              onChanged: (value) {
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
} 