import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../viewmodels/chat_viewmodel.dart';

class HistoryScreen extends StatelessWidget {
  final VoidCallback onSessionSelected;

  const HistoryScreen({super.key, required this.onSessionSelected});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatViewModel>(
      builder: (context, chatVm, _) {
        final sessions = chatVm.sessions;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 120,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                  title: const Text(
                    'Chat History',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.accentPurple.withAlpha(50),
                          AppTheme.bgDark,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (sessions.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 64,
                          color: AppTheme.textMuted.withAlpha(100),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No history yet',
                          style: TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final session = sessions[index];
                      final isCurrent = chatVm.currentSession?.id == session.id;

                      final dateFormat = DateFormat('MMM d, h:mm a');
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: isCurrent
                              ? AppTheme.accentPurple.withAlpha(20)
                              : Colors.transparent,
                          gradient: isCurrent ? null : AppTheme.cardGradient,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isCurrent
                                ? AppTheme.accentPurple.withAlpha(50)
                                : AppTheme.borderColor,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              chatVm.loadSession(session);
                              onSessionSelected();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          session.title.isEmpty
                                              ? 'New Chat'
                                              : session.title,
                                          style: const TextStyle(
                                            color: AppTheme.textPrimary,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${(session.messages.length / 2).ceil()} exchanges • ${dateFormat.format(session.updatedAt)}',
                                          style: const TextStyle(
                                            color: AppTheme.textMuted,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline_rounded,
                                      color: AppTheme.warning,
                                      size: 20,
                                    ),
                                    onPressed: () =>
                                        chatVm.deleteSession(session.id),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }, childCount: sessions.length),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
