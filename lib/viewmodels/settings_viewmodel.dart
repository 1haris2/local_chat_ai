import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsViewModel extends ChangeNotifier {
  double _temperature = 0.7;
  int _maxTokens = 1024;
  double _topP = 0.9;
  double _repeatPenalty = 1.1;
  String _systemPrompt =
      'You are a helpful AI assistant. Be concise and clear in your responses.';
  bool _isDarkMode = true;

  double get temperature => _temperature;
  int get maxTokens => _maxTokens;
  double get topP => _topP;
  double get repeatPenalty => _repeatPenalty;
  String get systemPrompt => _systemPrompt;
  bool get isDarkMode => _isDarkMode;

  SettingsViewModel() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _temperature = prefs.getDouble('temperature') ?? 0.7;
    _maxTokens = prefs.getInt('max_tokens') ?? 1024;
    _topP = prefs.getDouble('top_p') ?? 0.9;
    _repeatPenalty = prefs.getDouble('repeat_penalty') ?? 1.1;
    _systemPrompt =
        prefs.getString('system_prompt') ??
        'You are a helpful AI assistant. Be concise and clear in your responses.';
    _isDarkMode = prefs.getBool('dark_mode') ?? true;
    notifyListeners();
  }

  Future<void> setTemperature(double value) async {
    _temperature = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('temperature', value);
  }

  Future<void> setMaxTokens(int value) async {
    _maxTokens = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('max_tokens', value);
  }

  Future<void> setTopP(double value) async {
    _topP = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('top_p', value);
  }

  Future<void> setRepeatPenalty(double value) async {
    _repeatPenalty = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('repeat_penalty', value);
  }

  Future<void> setSystemPrompt(String value) async {
    _systemPrompt = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('system_prompt', value);
  }

  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', value);
  }

  void resetToDefaults() {
    _temperature = 0.7;
    _maxTokens = 1024;
    _topP = 0.9;
    _repeatPenalty = 1.1;
    _systemPrompt =
        'You are a helpful AI assistant. Be concise and clear in your responses.';
    notifyListeners();
  }
}
