import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../models/chat_message.dart';
import '../theme/app_theme.dart';
import 'typing_indicator.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            _buildAvatar(isUser: false),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                _buildBubble(context, isUser),
                if (message.isStreaming && message.content.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: TypingIndicator(),
                  ),
              ],
            ),
          ),
          if (isUser) ...[const SizedBox(width: 8), _buildAvatar(isUser: true)],
        ],
      ),
    );
  }

  Widget _buildAvatar({required bool isUser}) {
    return Container(
      width: 32,
      height: 32,
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        gradient: isUser
            ? const LinearGradient(
                colors: [AppTheme.accentPink, AppTheme.accentPurple],
              )
            : const LinearGradient(
                colors: [AppTheme.accentPurple, AppTheme.accentCyan],
              ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        isUser ? Icons.person_rounded : Icons.auto_awesome_rounded,
        color: Colors.white,
        size: 18,
      ),
    );
  }

  Widget _buildBubble(BuildContext context, bool isUser) {
    if (message.content.isEmpty && !message.isStreaming) {
      return const SizedBox.shrink();
    }

    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.75,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isUser ? AppTheme.userBubble : AppTheme.aiBubble,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomLeft: Radius.circular(isUser ? 20 : 4),
          bottomRight: Radius.circular(isUser ? 4 : 20),
        ),
        border: isUser ? null : Border.all(color: AppTheme.borderColor),
        boxShadow: isUser
            ? [
                BoxShadow(
                  color: AppTheme.accentPurple.withAlpha(40),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: isUser
          ? Text(
              message.content,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                height: 1.4,
              ),
            )
          : MarkdownBody(
              data: message.content,
              selectable: true,
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 15,
                  height: 1.5,
                ),
                code: TextStyle(
                  backgroundColor: AppTheme.bgDark.withAlpha(120),
                  color: AppTheme.accentCyan,
                  fontSize: 13,
                ),
                codeblockDecoration: BoxDecoration(
                  color: AppTheme.bgDark,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.borderColor),
                ),
                blockquoteDecoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: AppTheme.accentPurple.withAlpha(120),
                      width: 3,
                    ),
                  ),
                ),
                h1: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                h2: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                h3: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                strong: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
                em: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontStyle: FontStyle.italic,
                ),
                listBullet: const TextStyle(color: AppTheme.accentPurple),
              ),
            ),
    );
  }
}
