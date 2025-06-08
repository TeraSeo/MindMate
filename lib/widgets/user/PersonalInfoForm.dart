import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ai_chatter/constants/BoxSize.dart';
import 'package:ai_chatter/constants/FontSize.dart';
import 'package:ai_chatter/constants/Colors.dart';

class PersonalInfoForm extends StatelessWidget {
  final TextEditingController nameController;
  final String selectedAge;
  final String selectedGender;
  final List<String> ageGroups;
  final List<Map<String, String>> genderOptions;
  final Function(String) onAgeChanged;
  final Function(String) onGenderChanged;

  const PersonalInfoForm({
    super.key,
    required this.nameController,
    required this.selectedAge,
    required this.selectedGender,
    required this.ageGroups,
    required this.genderOptions,
    required this.onAgeChanged,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    String getLocalizedGenderLabel(String value) {
      switch (value) {
        case 'Male':
          return l10n.male;
        case 'Female':
          return l10n.female;
        case 'Non-binary':
          return l10n.nonBinary;
        case 'Prefer not to say':
          return l10n.preferNotToSay;
        default:
          return value;
      }
    }

    return Column(
      children: [
        TextFormField(
          controller: nameController,
          style: TextStyle(
            fontSize: FontSize.inputText,
            color: ConstantColor.textColor,
          ),
          decoration: InputDecoration(
            labelText: l10n.name,
            labelStyle: TextStyle(
              fontSize: FontSize.inputLabel,
              color: ConstantColor.textColor,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(BoxSize.inputRadius),
            ),
            contentPadding: EdgeInsets.all(BoxSize.inputPadding),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l10n.pleaseEnterName;
            }
            return null;
          },
        ),
        SizedBox(height: BoxSize.inputSpacing),
        DropdownButtonFormField<String>(
          value: selectedAge,
          style: TextStyle(
            fontSize: FontSize.inputText,
            color: ConstantColor.textColor,
          ),
          dropdownColor: ConstantColor.surfaceColor,
          decoration: InputDecoration(
            labelText: l10n.ageGroup,
            labelStyle: TextStyle(
              fontSize: FontSize.inputLabel,
              color: ConstantColor.textColor,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(BoxSize.inputRadius),
            ),
            contentPadding: EdgeInsets.all(BoxSize.inputPadding),
          ),
          items: ageGroups.map((age) => DropdownMenuItem(
            value: age,
            child: Text(
              age,
              style: TextStyle(color: ConstantColor.textColor),
            ),
          )).toList(),
          onChanged: (value) {
            if (value != null) onAgeChanged(value);
          },
        ),
        SizedBox(height: BoxSize.inputSpacing),
        DropdownButtonFormField<String>(
          value: selectedGender,
          style: TextStyle(
            fontSize: FontSize.inputText,
            color: ConstantColor.textColor,
          ),
          dropdownColor: ConstantColor.surfaceColor,
          decoration: InputDecoration(
            labelText: l10n.gender,
            labelStyle: TextStyle(
              fontSize: FontSize.inputLabel,
              color: ConstantColor.textColor,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(BoxSize.inputRadius),
            ),
            contentPadding: EdgeInsets.all(BoxSize.inputPadding),
          ),
          items: genderOptions.map((gender) => DropdownMenuItem(
            value: gender['value'],
            child: Text(
              getLocalizedGenderLabel(gender['value']!),
              style: TextStyle(color: ConstantColor.textColor),
            ),
          )).toList(),
          onChanged: (value) {
            if (value != null) onGenderChanged(value);
          },
        ),
      ],
    );
  }
}