import 'package:flutter/material.dart';
import 'package:sokopop_flutter_app/core/theme/app_theme.dart';
import 'package:sokopop_flutter_app/shared/mock/mock_data.dart';
import 'package:sokopop_flutter_app/features/messaging/presentation/screens/chat_screen.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.arrow_back, color: AppTheme.primary),
                Text('Messages',
                    style: TextStyle(
                        color: AppTheme.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700)),
                const Icon(Icons.notifications_outlined, color: AppTheme.primary),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.outlineVariant),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: AppTheme.outline, size: 20),
                  const SizedBox(width: 8),
                  Text('Search conversations...',
                      style: TextStyle(color: AppTheme.outline, fontSize: 14)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                ...sampleMessages.map((m) => _MessageTile(msg: m)),
                const SizedBox(height: 24),
                Column(
                  children: [
                    Icon(Icons.chat_bubble_outline,
                        size: 40, color: AppTheme.outline.withOpacity(0.4)),
                    const SizedBox(height: 8),
                    Text('No more messages',
                        style: TextStyle(color: AppTheme.outline, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageTile extends StatelessWidget {
  final Message msg;

  const _MessageTile({required this.msg});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatScreen(
            contactName: msg.senderName,
            listing: sampleListings.first,
            messages: msg.messages,
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.outlineVariant.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundImage: NetworkImage(msg.avatarUrl),
                  backgroundColor: AppTheme.surfaceContainerHigh,
                  onBackgroundImageError: (_, __) {},
                  child: Text(msg.senderName[0],
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, color: AppTheme.primary)),
                ),
                if (msg.isOnline)
                  Positioned(
                    bottom: 1,
                    right: 1,
                    child: Container(
                      width: 11,
                      height: 11,
                      decoration: BoxDecoration(
                        color: const Color(0xFF22C55E),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(msg.senderName,
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                  const SizedBox(height: 2),
                  Text(
                    msg.lastMessage,
                    style: TextStyle(
                      color: msg.hasUnread ? AppTheme.onSurface : AppTheme.onSurfaceVariant,
                      fontWeight:
                          msg.hasUnread ? FontWeight.w600 : FontWeight.w400,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  msg.time,
                  style: TextStyle(
                    color: msg.hasUnread ? AppTheme.primary : AppTheme.outline,
                    fontSize: 12,
                    fontWeight: msg.hasUnread ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                if (msg.hasUnread)
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppTheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
