import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_session.dart';

class ChatHistoryService {
  static const String _key = 'chat_sessions_v1';
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<List<ChatSession>> getSessions() async {
    await init();
    final jsonString = _prefs!.getString(_key);
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
    await init();
    final jsonString = jsonEncode(sessions.map((s) => s.toJson()).toList());
    await _prefs!.setString(_key, jsonString);
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
