import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/chat_message.dart';
import '../models/chat_session.dart';
import '../services/llama_service.dart';
import '../services/chat_history_service.dart';

class ChatViewModel extends ChangeNotifier {
  final LlamaService _llamaService = LlamaService();
  final ChatHistoryService _historyService = ChatHistoryService();

  final List<ChatMessage> _messages = [];
  List<ChatSession> _sessions = [];
  ChatSession? _currentSession;

  bool _isGenerating = false;
  bool _isModelLoading = false;
  String? _error;
  String? _loadedModelPath;
  StreamSubscription<String>? _generationSubscription;

  ChatViewModel() {
    loadSessions();
  }

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  List<ChatSession> get sessions => List.unmodifiable(_sessions);
  ChatSession? get currentSession => _currentSession;
  bool get isGenerating => _isGenerating;
  bool get isModelLoading => _isModelLoading;
  String? get error => _error;
  bool get isModelLoaded => _llamaService.isModelLoaded;
  String? get loadedModelPath => _loadedModelPath;

  Future<void> loadSessions() async {
    _sessions = await _historyService.getSessions();
    notifyListeners();
  }

  void loadSession(ChatSession session) {
    _currentSession = session;
    _messages.clear();
    _messages.addAll(session.messages);
    _error = null;
    notifyListeners();
  }

  void startNewSession() {
    _currentSession = null;
    _messages.clear();
    _error = null;
    notifyListeners();
  }

  Future<void> _saveCurrentSession() async {
    if (_currentSession == null && _messages.isNotEmpty) {
      _currentSession = ChatSession.create();
      // Set title from first user message
      final firstMsg = _messages.firstWhere(
        (m) => m.isUser,
        orElse: () => _messages.first,
      );
      final title = firstMsg.content.length > 30
          ? '${firstMsg.content.substring(0, 30)}...'
          : firstMsg.content;
      _currentSession!.title = title;
    }

    if (_currentSession != null) {
      _currentSession!.messages = List.from(_messages);
      _currentSession!.updatedAt = DateTime.now();
      await _historyService.saveSession(_currentSession!);
      await loadSessions();
    }
  }

  Future<void> deleteSession(String id) async {
    await _historyService.deleteSession(id);
    if (_currentSession?.id == id) {
      startNewSession();
    } else {
      await loadSessions();
    }
  }

  Future<void> loadModel(String modelPath) async {
    _isModelLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _llamaService.loadModel(
        modelPath: modelPath,
        threads: 4,
        contextSize: 2048,
      );
      _loadedModelPath = modelPath;
      _isModelLoading = false;
      notifyListeners();
    } catch (e) {
      _isModelLoading = false;
      _error = 'Failed to load model: $e';
      notifyListeners();
    }
  }

  Future<void> sendMessage(
    String content, {
    String systemPrompt =
        'You are a helpful AI assistant. Be concise and clear.',
    double temperature = 0.7,
    int maxTokens = 1024,
    double topP = 0.9,
    double repeatPenalty = 1.1,
  }) async {
    if (!_llamaService.isModelLoaded) {
      _error = 'No model loaded';
      notifyListeners();
      return;
    }

    // Add user message
    _messages.add(ChatMessage(role: 'user', content: content));
    _error = null;
    _isGenerating = true;
    notifyListeners();
    _saveCurrentSession();

    // Build message list for the model
    final messagesForModel = <Map<String, String>>[];

    // Add system prompt
    messagesForModel.add({'role': 'system', 'content': systemPrompt});

    // Add conversation history
    for (final msg in _messages) {
      messagesForModel.add({'role': msg.role, 'content': msg.content});
    }

    // Add empty assistant message for streaming
    _messages.add(
      ChatMessage(role: 'assistant', content: '', isStreaming: true),
    );
    notifyListeners();

    final assistantIndex = _messages.length - 1;
    final buffer = StringBuffer();
    Timer? throttleTimer;

    try {
      final stream = _llamaService.generateChat(
        messages: messagesForModel,
        temperature: temperature,
        maxTokens: maxTokens,
        topP: topP,
        repeatPenalty: repeatPenalty,
      );

      _generationSubscription = stream.listen(
        (token) {
          buffer.write(token);
          _messages[assistantIndex] = _messages[assistantIndex].copyWith(
            content: buffer.toString(),
          );

          // Throttle UI updates to 100ms to improve performance
          if (throttleTimer == null || !throttleTimer!.isActive) {
            throttleTimer = Timer(const Duration(milliseconds: 100), () {
              notifyListeners();
            });
          }
        },
        onDone: () {
          throttleTimer?.cancel();
          _messages[assistantIndex] = _messages[assistantIndex].copyWith(
            isStreaming: false,
          );
          _isGenerating = false;
          _generationSubscription = null;
          notifyListeners();
          _saveCurrentSession();
        },
        onError: (error) {
          _messages[assistantIndex] = _messages[assistantIndex].copyWith(
            content: buffer.isEmpty
                ? 'Error generating response.'
                : buffer.toString(),
            isStreaming: false,
          );
          _isGenerating = false;
          _error = error.toString();
          _generationSubscription = null;
          notifyListeners();
          _saveCurrentSession();
        },
      );
    } catch (e) {
      _messages[assistantIndex] = _messages[assistantIndex].copyWith(
        content: 'Error: $e',
        isStreaming: false,
      );
      _isGenerating = false;
      notifyListeners();
      _saveCurrentSession();
    }
  }

  Future<void> stopGeneration() async {
    await _llamaService.stopGeneration();
    _generationSubscription?.cancel();
    _generationSubscription = null;
    _isGenerating = false;

    // Finalize the last message
    if (_messages.isNotEmpty && _messages.last.isStreaming) {
      _messages[_messages.length - 1] = _messages.last.copyWith(
        isStreaming: false,
      );
    }
    notifyListeners();
    _saveCurrentSession();
  }

  void clearChat() {
    startNewSession();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _generationSubscription?.cancel();
    _llamaService.dispose();
    super.dispose();
  }
}
