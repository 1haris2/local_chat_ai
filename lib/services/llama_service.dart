import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:llama_flutter_android/llama_flutter_android.dart';

class LlamaService {
  LlamaController? _controller;
  bool _isModelLoaded = false;
  bool _isGenerating = false;
  String? _currentModelPath;

  bool get isModelLoaded => _isModelLoaded;
  bool get isGenerating => _isGenerating;
  String? get currentModelPath => _currentModelPath;

  Future<void> loadModel({
    required String modelPath,
    int threads = 4,
    int contextSize = 2048,
  }) async {
    // Dispose previous controller if exists
    await dispose();

    _controller = LlamaController();

    try {
      await _controller!.loadModel(
        modelPath: modelPath,
        threads: threads,
        contextSize: contextSize,
      );
      _isModelLoaded = true;
      _currentModelPath = modelPath;
      debugPrint('Model loaded: $modelPath');
    } catch (e) {
      debugPrint('Error loading model: $e');
      _isModelLoaded = false;
      _currentModelPath = null;
      rethrow;
    }
  }

  Stream<String> generateChat({
    required List<Map<String, String>> messages,
    double temperature = 0.7,
    int maxTokens = 1024,
    double topP = 0.9,
    int topK = 40,
    double repeatPenalty = 1.1,
    double minP = 0.05,
  }) {
    if (_controller == null || !_isModelLoaded) {
      return Stream.error('Model not loaded');
    }

    _isGenerating = true;

    // Convert messages to ChatMessage objects
    final chatMessages = messages.map((m) {
      return ChatMessage(
        role: m['role'] ?? 'user',
        content: m['content'] ?? '',
      );
    }).toList();

    final streamController = StreamController<String>();

    final subscription = _controller!
        .generateChat(
          messages: chatMessages,
          temperature: temperature,
          maxTokens: maxTokens,
          topP: topP,
          topK: topK,
          repeatPenalty: repeatPenalty,
          minP: minP,
        )
        .listen(
          (token) {
            streamController.add(token);
          },
          onDone: () {
            _isGenerating = false;
            streamController.close();
          },
          onError: (error) {
            _isGenerating = false;
            streamController.addError(error);
            streamController.close();
          },
        );

    streamController.onCancel = () {
      subscription.cancel();
      _isGenerating = false;
    };

    return streamController.stream;
  }

  Future<void> stopGeneration() async {
    if (_controller != null && _isGenerating) {
      try {
        await _controller!.stop();
      } catch (e) {
        debugPrint('Error stopping generation: $e');
      }
      _isGenerating = false;
    }
  }

  Future<void> dispose() async {
    if (_controller != null) {
      try {
        if (_isGenerating) {
          await _controller!.stop();
        }
        await _controller!.dispose();
      } catch (e) {
        debugPrint('Error disposing controller: $e');
      }
      _controller = null;
      _isModelLoaded = false;
      _isGenerating = false;
      _currentModelPath = null;
    }
  }
}
