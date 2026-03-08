import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../viewmodels/chat_viewmodel.dart';
import '../viewmodels/settings_viewmodel.dart';
import '../viewmodels/model_viewmodel.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void _sendMessage(ChatViewModel chatVm, SettingsViewModel settingsVm) {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _textController.clear();
    chatVm.sendMessage(
      text,
      systemPrompt: settingsVm.systemPrompt,
      temperature: settingsVm.temperature,
      maxTokens: settingsVm.maxTokens,
      topP: settingsVm.topP,
      repeatPenalty: settingsVm.repeatPenalty,
    );
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<ChatViewModel, SettingsViewModel, ModelViewModel>(
      builder: (context, chatVm, settingsVm, modelVm, _) {
        // Auto-scroll when generating
        if (chatVm.isGenerating) {
          _scrollToBottom();
        }

        return Scaffold(
          body: Column(
            children: [
              // App bar area
              _buildAppBar(context, chatVm, modelVm),

              // Messages area
              Expanded(
                child: chatVm.messages.isEmpty
                    ? _buildEmptyState(modelVm)
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        itemCount: chatVm.messages.length,
                        itemBuilder: (context, index) {
                          return MessageBubble(message: chatVm.messages[index]);
                        },
                      ),
              ),

              // Error display
              if (chatVm.error != null)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.error.withAlpha(20),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.error.withAlpha(60)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: AppTheme.error,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          chatVm.error!,
                          style: const TextStyle(
                            color: AppTheme.error,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: chatVm.clearError,
                        child: const Icon(
                          Icons.close,
                          color: AppTheme.error,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),

              // Model loading indicator
              if (chatVm.isModelLoading)
                Container(
                  padding: const EdgeInsets.all(12),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppTheme.accentPurple,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Loading model...',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

              // Input bar
              _buildInputBar(chatVm, settingsVm),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppBar(
    BuildContext context,
    ChatViewModel chatVm,
    ModelViewModel modelVm,
  ) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 8,
        bottom: 8,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.bgDark,
        border: Border(
          bottom: BorderSide(color: AppTheme.borderColor, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          // AI Icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: AppTheme.accentGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          // Title & model name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Chat',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  modelVm.activeModel?.name ?? 'No model loaded',
                  style: TextStyle(
                    color: chatVm.isModelLoaded
                        ? AppTheme.accentGreen
                        : AppTheme.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // New Chat
          IconButton(
            icon: const Icon(
              Icons.edit_square,
              color: AppTheme.textMuted,
              size: 22,
            ),
            onPressed: () => chatVm.startNewSession(),
            tooltip: 'New Chat',
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ModelViewModel modelVm) {
    final hasModel = modelVm.activeModel != null;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: AppTheme.accentGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accentPurple.withAlpha(60),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.chat_bubble_outline_rounded,
                color: Colors.white,
                size: 36,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              hasModel ? 'Start a conversation' : 'No Model Selected',
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              hasModel
                  ? 'Type a message below to chat with\n${modelVm.activeModel!.name}'
                  : 'Go to the Models tab to download\nand select a model first',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar(ChatViewModel chatVm, SettingsViewModel settingsVm) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 8,
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.bgCard,
        border: Border(
          top: BorderSide(color: AppTheme.borderColor, width: 0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Text field
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 120),
              child: TextField(
                controller: _textController,
                focusNode: _focusNode,
                maxLines: null,
                enabled: chatVm.isModelLoaded && !chatVm.isModelLoading,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  hintText: chatVm.isModelLoaded
                      ? 'Type a message...'
                      : 'Load a model first...',
                  hintStyle: const TextStyle(color: AppTheme.textMuted),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: AppTheme.borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: AppTheme.borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(
                      color: AppTheme.accentPurple,
                      width: 1.5,
                    ),
                  ),
                  filled: true,
                  fillColor: AppTheme.bgSurface,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                onSubmitted: (_) {
                  if (!chatVm.isGenerating) {
                    _sendMessage(chatVm, settingsVm);
                  }
                },
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Send / Stop button
          Container(
            width: 44,
            height: 44,
            margin: const EdgeInsets.only(bottom: 2),
            decoration: BoxDecoration(
              gradient: chatVm.isGenerating ? null : AppTheme.accentGradient,
              color: chatVm.isGenerating ? AppTheme.error : null,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color:
                      (chatVm.isGenerating
                              ? AppTheme.error
                              : AppTheme.accentPurple)
                          .withAlpha(60),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: chatVm.isGenerating
                    ? chatVm.stopGeneration
                    : () => _sendMessage(chatVm, settingsVm),
                child: Icon(
                  chatVm.isGenerating ? Icons.stop_rounded : Icons.send_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
