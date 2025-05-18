import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en', 'US');

  Locale get locale => _locale;

  static final List<Locale> supportedLocales = [
    const Locale('en', 'US'), // English (US)
    const Locale('en', 'GB'), // English (UK)
    const Locale('ko', 'KR'), // Korean
    const Locale('ja', 'JP'), // Japanese
    const Locale('es', 'ES'), // Spanish
    const Locale('fr', 'FR'), // French
    const Locale('de', 'DE'), // German
    const Locale('zh', 'CN'), // Chinese (Simplified)
    const Locale('pt', 'BR'), // Portuguese
    const Locale('hi', 'IN'), // Hindi
  ];

  void setLocale(Locale locale) {
    // Check if the locale is supported
    if (supportedLocales.contains(locale)) {
      _locale = locale;
      notifyListeners();
    }
  }

  // Get the display name for a locale
  String getDisplayLanguage(Locale locale) {
    switch ('${locale.languageCode}_${locale.countryCode}') {
      case 'en_US':
        return 'English (US)';
      case 'en_GB':
        return 'English (UK)';
      case 'ko_KR':
        return '한국어';
      case 'ja_JP':
        return '日本語';
      case 'es_ES':
        return 'Español';
      case 'fr_FR':
        return 'Français';
      case 'de_DE':
        return 'Deutsch';
      case 'zh_CN':
        return '简体中文';
      case 'pt_BR':
        return 'Português';
      case 'hi_IN':
        return 'हिन्दी';
      default:
        return locale.languageCode;
    }
  }
} 