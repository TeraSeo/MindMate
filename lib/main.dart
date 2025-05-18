import 'package:ai_chatter/constants/Colors.dart';
import 'package:ai_chatter/firebase_options.dart';
import 'package:ai_chatter/providers/LocaleProvider.dart';
import 'package:ai_chatter/screens/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => LocaleProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
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
          home: const SplashScreen(),
        );
      },
    );
  }
}
