import 'dart:math';

import 'package:ai_chatter/services/ReportService.dart';
import 'package:flutter/material.dart';
import 'package:ai_chatter/constants/Colors.dart';
import 'package:ai_chatter/constants/FontSize.dart';
import 'package:ai_chatter/constants/BoxSize.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MessageBubble extends StatelessWidget {
  final String messageId;
  final String text;
  final bool isUser;
  final DateTime timestamp;

  const MessageBubble({
    required this.messageId,
    required this.text,
    required this.isUser,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isUser) ...[
                CircleAvatar(
                  radius: 16,
                  backgroundColor: ConstantColor.primaryColor.withOpacity(0.1),
                  child: Text(
                    'AI',
                    style: TextStyle(
                      fontSize: FontSize.bodySmall,
                      color: ConstantColor.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: BoxSize.spacingM,
                    vertical: BoxSize.spacingS,
                  ),
                  decoration: BoxDecoration(
                    color: isUser
                        ? ConstantColor.primaryColor
                        : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(BoxSize.cardRadius),
                      topRight: const Radius.circular(BoxSize.cardRadius),
                      bottomLeft: Radius.circular(isUser ? BoxSize.cardRadius : 0),
                      bottomRight: Radius.circular(isUser ? 0 : BoxSize.cardRadius),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: TextStyle(
                          color: isUser ? Colors.white : Colors.black87,
                          fontSize: FontSize.bodyMedium,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatTime(timestamp),
                        style: TextStyle(
                          color: isUser ? Colors.white70 : Colors.grey[600],
                          fontSize: FontSize.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isUser) ...[
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.grey[200],
                  child: const Icon(
                    Icons.person,
                    size: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ],
          ),
          if (!isUser)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 40), // Align under bubble
              child: TextButton.icon(
                onPressed: () {
                  _showReportDialog(context, text); // 메시지 텍스트 전달
                },
                icon: const Icon(Icons.flag_outlined, size: 16, color: Colors.grey),
                label: const Text(
                  'Report',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _showReportDialog(BuildContext context, String message) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.reportMessageTitle),
        content: Text('${l10n.reportMessageConfirmation}\n\n"$message"'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.reportMessageDone)),
              );
              ReportService reportService = ReportService();
              reportService.createReport(messageId: messageId);
            },
            child: Text(l10n.report),
          ),
        ],
      ),
    );
  }
}