import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ai_chatter/constants/BoxSize.dart';
import 'package:ai_chatter/constants/FontSize.dart';
import 'package:ai_chatter/services/NotificationService.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ai_chatter/screens/setup/BaseStep.dart';

class NotificationSetupStep extends StatefulWidget {
  final ValueChanged<bool> onChanged;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final bool initialValue;

  const NotificationSetupStep({
    super.key,
    required this.onChanged,
    required this.onNext,
    required this.onPrevious,
    required this.initialValue,
  });

  @override
  State<NotificationSetupStep> createState() => _NotificationSetupStepState();
}

class _NotificationSetupStepState extends State<NotificationSetupStep> {
  bool _pushNotificationsEnabled = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _pushNotificationsEnabled = widget.initialValue;
  }

  Future<void> _togglePushNotifications(bool value) async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (value) {
        final notificationService = NotificationService();
        await notificationService.initialize();
        
        PermissionStatus? permissionStatus;
        try {
          permissionStatus = await Permission.notification.status;
        } catch (e) {
          print('Error checking permission status: $e');
          permissionStatus = PermissionStatus.denied;
        }
        
        if (permissionStatus.isDenied) {
          PermissionStatus? result;
          try {
            result = await Permission.notification.request();
          } catch (e) {
            print('Error requesting permission: $e');
            result = PermissionStatus.denied;
          }
          
          if (result?.isGranted == true) {
            setState(() {
              _pushNotificationsEnabled = true;
            });
          } else {
            if (mounted) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(AppLocalizations.of(context)!.notificationsRequired),
                  content: Text(AppLocalizations.of(context)!.notificationsRequiredMessage),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(AppLocalizations.of(context)!.ok),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await openAppSettings();
                      },
                      child: const Text('Open Settings'),
                    ),
                  ],
                ),
              );
            }
          }
        } else if (permissionStatus.isGranted) {
          setState(() {
            _pushNotificationsEnabled = true;
          });
        }
      } else {
        setState(() {
          _pushNotificationsEnabled = false;
        });
      }
    } catch (e) {
      print('Error in _togglePushNotifications: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to toggle notifications. Please try again.'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    final titleFontSize = isSmallScreen ? FontSize.h2 : FontSize.h1;
    final descriptionFontSize = isSmallScreen ? FontSize.bodyLarge : FontSize.h5;
    final cardTitleFontSize = isSmallScreen ? FontSize.h4 : FontSize.h3;
    final cardDescriptionFontSize = isSmallScreen ? FontSize.bodyMedium : FontSize.bodyLarge;
    final cardPadding = isSmallScreen ? BoxSize.cardPadding : BoxSize.cardPadding * 1.5;
    final iconSize = isSmallScreen ? BoxSize.iconMedium : BoxSize.iconLarge;

    return BaseStep(
      onNext: widget.onNext,
      onPrevious: widget.onPrevious,
      canProceed: true,
      isLastStep: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.notificationStepTitle,
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isSmallScreen ? BoxSize.spacingM : BoxSize.spacingL),
          Text(
            l10n.notificationStepDescription,
            style: TextStyle(
              fontSize: descriptionFontSize,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: isSmallScreen ? BoxSize.spacingXL : BoxSize.spacingXXL),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(BoxSize.cardRadius),
              side: BorderSide(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.pushNotificationsTitle,
                    style: TextStyle(
                      fontSize: cardTitleFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? BoxSize.spacingS : BoxSize.spacingM),
                  Text(
                    l10n.pushNotificationsDescription,
                    style: TextStyle(
                      fontSize: cardDescriptionFontSize,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? BoxSize.spacingM : BoxSize.spacingL),
                  SwitchListTile(
                    value: _pushNotificationsEnabled,
                    onChanged: _isLoading ? null : _togglePushNotifications,
                    title: Text(
                      l10n.pushNotificationsTitle,
                      style: TextStyle(fontSize: cardDescriptionFontSize),
                    ),
                    secondary: _isLoading
                        ? SizedBox(
                            width: iconSize,
                            height: iconSize,
                            child: CircularProgressIndicator(
                              strokeWidth: isSmallScreen ? 2 : 3,
                            ),
                          )
                        : Icon(
                            Icons.notifications_outlined,
                            size: iconSize,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 