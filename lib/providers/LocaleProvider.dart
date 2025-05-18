import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en', 'US'); // Default to English (US)
  static const String _localeKey = 'selected_locale';
  SharedPreferences? _prefs;
  bool _initialized = false;
  int _initAttempts = 0;
  static const int maxAttempts = 3;

  LocaleProvider();

  bool get isInitialized => _initialized;
  Locale get locale => _locale;

  Future<void> initialize() async {
    if (_initialized) return;
    if (_initAttempts >= maxAttempts) {
      _initialized = true;
      notifyListeners();
      return;
    }
    
    _initAttempts++;
    
    try {
      // Add a small delay before initialization
      await Future.delayed(const Duration(milliseconds: 100));
      _prefs = await SharedPreferences.getInstance();
      
      // Try to get saved locale
      final String? savedLocale = _prefs?.getString(_localeKey);
      
      if (savedLocale != null) {
        // Parse saved locale
        final parts = savedLocale.split('_');
        if (parts.length == 2) {
          final locale = Locale(parts[0], parts[1]);
          if (supportedLocales.contains(locale)) {
            _locale = locale;
            _initialized = true;
            notifyListeners();
            return;
          }
        }
      }
      
      // If no valid saved locale, use device locale
      _locale = _getDeviceLocale();
      await _saveLocale(_locale);
    } catch (e) {
      print('Error initializing LocaleProvider (attempt $_initAttempts): $e');
      if (_initAttempts < maxAttempts) {
        // Retry initialization after a delay
        await Future.delayed(const Duration(milliseconds: 500));
        return initialize();
      }
    } finally {
      _initialized = true;
      notifyListeners();
    }
  }

  Future<void> _saveLocale(Locale locale) async {
    try {
      await _prefs?.setString(_localeKey, '${locale.languageCode}_${locale.countryCode}');
    } catch (e) {
      print('Error saving locale: $e');
    }
  }

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

  // Get the device's locale and return a supported locale or fallback
  Locale _getDeviceLocale() {
    // Get the device's locale
    final List<Locale> deviceLocales = ui.PlatformDispatcher.instance.locales;
    
    if (deviceLocales.isEmpty) {
      return const Locale('en', 'US'); // Fallback if no device locale
    }

    // Try to find an exact match (language + country)
    for (var deviceLocale in deviceLocales) {
      try {
        return supportedLocales.firstWhere(
          (supported) => 
            supported.languageCode == deviceLocale.languageCode && 
            supported.countryCode == deviceLocale.countryCode,
        );
      } catch (_) {
        // No exact match found, continue to next locale
        continue;
      }
    }

    // Try to find a language match (ignoring country)
    for (var deviceLocale in deviceLocales) {
      try {
        return supportedLocales.firstWhere(
          (supported) => supported.languageCode == deviceLocale.languageCode,
        );
      } catch (_) {
        // No language match found, continue to next locale
        continue;
      }
    }

    // Fallback to English (US) if no match found
    return const Locale('en', 'US');
  }

  Future<void> setLocale(Locale locale) async {
    // Check if the locale is supported
    if (supportedLocales.contains(locale)) {
      _locale = locale;
      await _saveLocale(locale);
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