import 'package:ai_chatter/widgets/button/HomeFloatingActionButton.dart';
import 'package:ai_chatter/widgets/drawer/HomeDrawer.dart';
import 'package:ai_chatter/widgets/drawer/characters/ChatCharacterList.dart';
import 'package:flutter/material.dart';
import 'package:ai_chatter/constants/Colors.dart';
import 'package:ai_chatter/constants/FontSize.dart';
import 'package:ai_chatter/providers/UserProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final user = userProvider.user;
          if (user == null) {
            return const Center(child: Text("User not found"));
          }
          return ChatCharacterList(user: user);
        },
      ),
      floatingActionButton: HomefloatingactionButton()
    );
  }
} 