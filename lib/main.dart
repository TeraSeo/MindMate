import 'package:ai_chatter/constants/Colors.dart';
import 'package:ai_chatter/firebase_options.dart';
import 'package:ai_chatter/providers/LocaleProvider.dart';
import 'package:ai_chatter/screens/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  // Ensure platform channels are properly initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Wait for a frame to ensure platform channels are ready
  await Future.delayed(const Duration(milliseconds: 100));
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final provider = LocaleProvider();
        // Initialize the provider
        provider.initialize();
        return provider;
      },
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MaterialApp(
            title: 'AI Chatter',
            locale: localeProvider.locale,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: LocaleProvider.supportedLocales,
            theme: ThemeData(
              primaryColor: ConstantColor.primaryColor,
              scaffoldBackgroundColor: ConstantColor.backgroundColor,
              textTheme: TextTheme(
                bodyMedium: TextStyle(color: ConstantColor.textColor),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ConstantColor.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ConstantColor.primaryColor),
                ),
                labelStyle: TextStyle(color: ConstantColor.textColor),
                hintStyle: TextStyle(color: ConstantColor.hintTextColor),
              ),
              colorScheme: ColorScheme.light(
                primary: ConstantColor.primaryColor,
                secondary: ConstantColor.secondaryColor,
                background: ConstantColor.backgroundColor,
                surface: ConstantColor.surfaceColor,
                error: ConstantColor.errorColor,
                onPrimary: Colors.white,
                onSurface: ConstantColor.textColor,
              ),
            ),
            builder: (context, child) {
              // Show loading indicator while locale is being initialized
              if (!localeProvider.isInitialized) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: Scaffold(
                    backgroundColor: ConstantColor.backgroundColor,
                    body: Center(
                      child: CircularProgressIndicator(
                        color: ConstantColor.primaryColor,
                      ),
                    ),
                  ),
                );
              }
              return child ?? const SizedBox();
            },
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
