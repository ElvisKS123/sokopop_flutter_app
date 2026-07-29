import 'package:flutter/material.dart';
import 'package:sokopop_flutter_app/core/theme/app_theme.dart';
import 'package:sokopop_flutter_app/shared/mock/mock_data.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final today = sampleNotifications.take(3).toList();
    final yesterday = sampleNotifications.skip(3).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Notifications', style: AppTheme.bodyLg.copyWith(fontWeight: FontWeight.w700)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppTheme.onSurface),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionHeader('TODAY'),
          ...today.map((n) => _NotifTile(notif: n)),
          const SizedBox(height: 12),
          _sectionHeader('YESTERDAY'),
          ...yesterday.map((n) => _NotifTile(notif: n)),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _sectionHeader(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 4),
      child: Text(label,
          style: TextStyle(
              color: AppTheme.onSurfaceVariant,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1)),
    );
  }
}

class _NotifTile extends StatelessWidget {
  final AppNotification notif;

  const _NotifTile({required this.notif});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: notif.isUnread
              ? AppTheme.primary.withOpacity(0.2)
              : AppTheme.outlineVariant.withOpacity(0.4),
          width: notif.isUnread ? 1.5 : 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (notif.isUnread)
            Container(
              width: 3,
              margin: const EdgeInsets.only(right: 10, top: 4),
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          _notifIcon(notif.type),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (notif.linkText != null)
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                          color: AppTheme.onSurface,
                          fontSize: 13,
                          fontWeight: notif.isUnread ? FontWeight.w600 : FontWeight.w400,
                          height: 1.4),
                      children: [
                        TextSpan(text: notif.title),
                        TextSpan(
                            text: notif.linkText,
                            style: const TextStyle(color: AppTheme.primary)),
                      ],
                    ),
                  )
                else
                  Text(
                    notif.title,
                    style: TextStyle(
                        color: AppTheme.onSurface,
                        fontSize: 13,
                        fontWeight: notif.isUnread ? FontWeight.w600 : FontWeight.w400,
                        height: 1.4),
                  ),
                if (notif.subtitle != null) ...[
                  const SizedBox(height: 3),
                  Text(notif.subtitle!,
                      style: TextStyle(
                          color: AppTheme.onSurfaceVariant,
                          fontSize: 12,
                          fontStyle: FontStyle.italic)),
                ],
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _notifTypeIcon(notif.type),
                    Text(notif.time,
                        style: TextStyle(color: AppTheme.outline, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
          if (notif.isUnread)
            Container(
              width: 9,
              height: 9,
              margin: const EdgeInsets.only(left: 6, top: 4),
              decoration: const BoxDecoration(
                color: AppTheme.primary,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  Widget _notifIcon(String type) {
    IconData icon;
    Color bg;
    Color iconColor;

    switch (type) {
      case 'message':
        icon = Icons.person;
        bg = AppTheme.surfaceContainerHigh;
        iconColor = AppTheme.onSurface;
        break;
      case 'listing':
        icon = Icons.devices_outlined;
        bg = AppTheme.secondaryContainer.withOpacity(0.4);
        iconColor = AppTheme.primary;
        break;
      case 'review':
        icon = Icons.star_outline;
        bg = AppTheme.surfaceContainerHigh;
        iconColor = AppTheme.outline;
        break;
      case 'view':
        icon = Icons.trending_up;
        bg = AppTheme.surfaceContainerHigh;
        iconColor = AppTheme.outline;
        break;
      case 'interest':
        icon = Icons.person;
        bg = AppTheme.surfaceContainerHigh;
        iconColor = AppTheme.outline;
        break;
      default:
        icon = Icons.notifications_outlined;
        bg = AppTheme.surfaceContainerHigh;
        iconColor = AppTheme.outline;
    }

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Icon(icon, color: iconColor, size: 20),
    );
  }

  Widget _notifTypeIcon(String type) {
    if (type == 'message') {
      return Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppTheme.primary.withOpacity(0.12),
          borderRadius: BorderRadius.circular(999),
        ),
        child: const Icon(Icons.chat_bubble_outline, color: AppTheme.primary, size: 12),
      );
    }
    return const SizedBox();
  }
}
