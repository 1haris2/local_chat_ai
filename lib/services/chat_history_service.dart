import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/chat_session.dart';

class ChatHistoryService {
  static const String _key = 'chat_sessions_v1_secure';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<List<ChatSession>> getSessions() async {
    final jsonString = await _storage.read(key: _key);
    if (jsonString == null) return [];

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((j) => ChatSession.fromJson(j as Map<String, dynamic>))
          .toList()
        ..sort(
          (a, b) => b.updatedAt.compareTo(a.updatedAt),
        ); // Sort newest first
    } catch (e) {
      debugPrint('Error loading chat history: $e');
      return [];
    }
  }

  Future<void> saveSessions(List<ChatSession> sessions) async {
    final jsonString = jsonEncode(sessions.map((s) => s.toJson()).toList());
    await _storage.write(key: _key, value: jsonString);
  }

  Future<void> saveSession(ChatSession session) async {
    final sessions = await getSessions();
    final index = sessions.indexWhere((s) => s.id == session.id);
    if (index >= 0) {
      sessions[index] = session;
    } else {
      sessions.insert(0, session);
    }
    await saveSessions(sessions);
  }

  Future<void> deleteSession(String id) async {
    final sessions = await getSessions();
    sessions.removeWhere((s) => s.id == id);
    await saveSessions(sessions);
  }
}
