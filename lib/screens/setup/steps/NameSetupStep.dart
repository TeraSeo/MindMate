import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ai_chatter/constants/BoxSize.dart';
import 'package:ai_chatter/constants/FontSize.dart';

class NameSetupStep extends StatefulWidget {
  final Function(String) onNameChanged;
  final VoidCallback onNext;
  final String? initialValue;

  const NameSetupStep({
    super.key,
    required this.onNameChanged,
    required this.onNext,
    this.initialValue,
  });

  @override
  State<NameSetupStep> createState() => _NameSetupStepState();
}

class _NameSetupStepState extends State<NameSetupStep> {
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
      widget.onNameChanged(_nameController.text.trim());
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    final titleFontSize = isSmallScreen ? FontSize.h2 : FontSize.h1;
    final descriptionFontSize = isSmallScreen ? FontSize.bodyLarge : FontSize.h5;
    final inputFontSize = isSmallScreen ? FontSize.bodyLarge : FontSize.h6;
    final buttonHeight = isSmallScreen ? BoxSize.buttonHeight : BoxSize.buttonHeight * 1.2;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.nameStepTitle,
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isSmallScreen ? BoxSize.spacingM : BoxSize.spacingL),
          Text(
            l10n.nameStepDescription,
            style: TextStyle(
              fontSize: descriptionFontSize,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: isSmallScreen ? BoxSize.spacingXL : BoxSize.spacingXXL),
          TextFormField(
            controller: _nameController,
            style: TextStyle(fontSize: inputFontSize),
            decoration: InputDecoration(
              labelText: l10n.nameFieldLabel,
              labelStyle: TextStyle(fontSize: inputFontSize * 0.9),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(BoxSize.inputRadius),
              ),
              contentPadding: EdgeInsets.all(
                isSmallScreen ? BoxSize.inputPadding : BoxSize.inputPadding * 1.5,
              ),
            ),
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.nameFieldError;
              }
              if (value.trim().length < 2) {
                return l10n.nameFieldLengthError;
              }
              return null;
            },
            onFieldSubmitted: (_) => _handleNext(),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: buttonHeight,
            child: ElevatedButton(
              onPressed: _handleNext,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(BoxSize.buttonRadius),
                ),
              ),
              child: Text(
                l10n.next,
                style: TextStyle(
                  fontSize: isSmallScreen ? FontSize.buttonMedium : FontSize.buttonLarge,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 