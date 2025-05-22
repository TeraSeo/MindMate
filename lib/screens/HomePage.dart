import 'package:ai_chatter/widgets/HomeDrawer.dart';
import 'package:flutter/material.dart';
import 'package:ai_chatter/constants/Colors.dart';
import 'package:ai_chatter/constants/FontSize.dart';
import 'package:ai_chatter/providers/UserProvider.dart';
import 'package:ai_chatter/screens/setup/chat/ChatSetupPage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _handleAddButton(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    // Wait for user data to be loaded
    if (userProvider.isLoading) {
      return;
    }

    final user = userProvider.user;
    if (user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChatSetupPage()),
      );
    }
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
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          return Center(
            child: Text(
              AppLocalizations.of(context)!.welcomeMessage,
              style: TextStyle(
                fontSize: FontSize.h4,
                color: ConstantColor.textColor,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _handleAddButton(context),
        backgroundColor: ConstantColor.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
} 