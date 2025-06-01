import 'package:ai_chatter/constants/Colors.dart';
import 'package:ai_chatter/providers/UserProvider.dart';
import 'package:ai_chatter/screens/setup/chat/ChatSetupPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomefloatingactionButton extends StatefulWidget {
  const HomefloatingactionButton({super.key});

  @override
  State<HomefloatingactionButton> createState() => _HomefloatingactionButtonState();
}

class _HomefloatingactionButtonState extends State<HomefloatingactionButton> {
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
    return FloatingActionButton(
      onPressed: () => _handleAddButton(context),
      backgroundColor: ConstantColor.primaryColor,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}