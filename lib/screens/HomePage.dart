import 'package:ai_chatter/services/AdsService.dart';
import 'package:ai_chatter/widgets/button/HomeFloatingActionButton.dart';
import 'package:ai_chatter/widgets/drawer/HomeDrawer.dart';
import 'package:ai_chatter/widgets/characters/ChatCharacterList.dart';
import 'package:flutter/material.dart';
import 'package:ai_chatter/constants/Colors.dart';
import 'package:ai_chatter/constants/FontSize.dart';
import 'package:ai_chatter/providers/UserProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AdsService _adsService = AdsService();
  bool _hasShownAd = false;

  @override
  void initState() {
    super.initState();

    _adsService.loadInterstitialAd(); // Load it early

    // Wait and try showing it later
    Future.delayed(const Duration(seconds: 2), () {
      if (!_hasShownAd) {
        _adsService.showInterstitialAd(
          onAdNotReady: () {
            Future.delayed(const Duration(seconds: 2), () {
              _adsService.showInterstitialAd();
              _hasShownAd = true;
            });
          },
        );
        _hasShownAd = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.home,
          style: TextStyle(fontSize: FontSize.h6),
        ),
        backgroundColor: ConstantColor.primaryColor,
        foregroundColor: Colors.white,
      ),
      drawer: HomeDrawer(),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = userProvider.user;
          if (user == null) {
            return const Center(child: Text("User not found"));
          }
          return ChatCharacterList(user: user);
        },
      ),
      floatingActionButton: HomefloatingactionButton(),
    );
  }
}
