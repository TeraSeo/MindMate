import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:ai_chatter/providers/LocaleProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ai_chatter/screens/auth/LoginPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ai_chatter/constants/BoxSize.dart';
import 'package:ai_chatter/constants/FontSize.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  void _showLanguageDialog(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.language),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: LocaleProvider.supportedLocales.length,
            itemBuilder: (context, index) {
              final locale = LocaleProvider.supportedLocales[index];
              return ListTile(
                title: Text(localeProvider.getDisplayLanguage(locale)),
                selected: localeProvider.locale == locale,
                onTap: () {
                  localeProvider.setLocale(locale);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.secondary,
                ],
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: theme.colorScheme.surface,
              child: Text(
                user?.email?.substring(0, 1).toUpperCase() ?? 'A',
                style: TextStyle(
                  fontSize: FontSize.h3,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            accountName: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data?.exists == true) {
                  final userData = snapshot.data!.data() as Map<String, dynamic>?;
                  return Text(
                    userData?['name'] ?? user?.email?.split('@')[0] ?? '',
                    style: const TextStyle(fontSize: FontSize.bodyLarge),
                  );
                }
                return Text(
                  user?.email?.split('@')[0] ?? '',
                  style: const TextStyle(fontSize: FontSize.bodyLarge),
                );
              },
            ),
            accountEmail: Text(
              user?.email ?? '',
              style: const TextStyle(fontSize: FontSize.bodyMedium),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.home_outlined),
                  title: Text(l10n.home),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: Text(l10n.profile),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navigate to profile page
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings_outlined),
                  title: Text(l10n.settings),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navigate to settings page
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(l10n.language),
                  onTap: () {
                    Navigator.pop(context);
                    _showLanguageDialog(context);
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(l10n.about),
                  onTap: () {
                    Navigator.pop(context);
                    showAboutDialog(
                      context: context,
                      applicationName: l10n.appTitle,
                      applicationVersion: '1.0.0',
                      applicationIcon: Icon(
                        Icons.chat_bubble_outline,
                        size: BoxSize.iconLarge,
                        color: theme.colorScheme.primary,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(BoxSize.spacingM),
            child: Column(
              children: [
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: Text(l10n.logout),
                  onTap: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(l10n.logoutConfirmation),
                        content: Text(l10n.logoutMessage),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text(l10n.cancel),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text(l10n.logout),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true) {
                      await FirebaseAuth.instance.signOut();
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                          (route) => false,
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}