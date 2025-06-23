import 'package:ai_chatter/providers/LocaleProvider.dart';
import 'package:ai_chatter/widgets/subscription/SubscriptionPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ai_chatter/screens/setup/user/UserSetupPage.dart';
import 'package:provider/provider.dart';

class Dialogs {
  static void showSetupRequiredDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Column(
          children: [
            const Icon(
              Icons.person_add_outlined,
              size: 48,
              color: Colors.orange,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.setupRequired,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.setupRequiredMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    l10n.cancel,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const UserSetupPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    l10n.goToSetup,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      ),
    );
  }

  static void showLanguageDialog(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Column(
          children: [
            const Icon(
              Icons.language,
              size: 48,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.language,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: LocaleProvider.supportedLocales.length,
            itemBuilder: (context, index) {
              final locale = LocaleProvider.supportedLocales[index];
              final isSelected = localeProvider.locale == locale;
              return ListTile(
                title: Text(
                  localeProvider.getDisplayLanguage(locale),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Theme.of(context).colorScheme.primary : null,
                  ),
                ),
                leading: isSelected 
                  ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary)
                  : const Icon(Icons.language_outlined),
                onTap: () {
                  localeProvider.setLocale(locale);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 20),
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      ),
    );
  }

  static void showSubscriptionRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Subscription Required'),
        content: const Text('You have reached your free message limit. Please upgrade to continue chatting.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SubscriptionPage()),
              );
            },
            child: const Text('Upgrade Now'),
          ),
        ],
      ),
    );
  }

  static void showWatchAdsRequiredDialog(BuildContext context, VoidCallback onWatchAd) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Column(
          children: [
            const Icon(
              Icons.ondemand_video,
              size: 48,
              color: Colors.purple,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.watchAdRequiredTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.watchAdRequiredMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    l10n.cancel,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onWatchAd(); // Trigger ad watch logic
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    l10n.watchNow,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      ),
    );
  }
} 