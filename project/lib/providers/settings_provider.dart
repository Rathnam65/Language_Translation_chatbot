import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool _useSystemTheme = true;
  bool _autoDetectLanguage = true;
  bool _saveHistory = true;
  bool _textToSpeechEnabled = true;
  bool _speechToTextEnabled = true;
  double _speechRate = 0.5;
  String _error = '';

  // Getters
  bool get isDarkMode => _isDarkMode;
  bool get useSystemTheme => _useSystemTheme;
  bool get autoDetectLanguage => _autoDetectLanguage;
  bool get saveHistory => _saveHistory;
  bool get textToSpeechEnabled => _textToSpeechEnabled;
  bool get speechToTextEnabled => _speechToTextEnabled;
  double get speechRate => _speechRate;
  String get error => _error;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _useSystemTheme = prefs.getBool('useSystemTheme') ?? true;
      _autoDetectLanguage = prefs.getBool('autoDetectLanguage') ?? true;
      _saveHistory = prefs.getBool('saveHistory') ?? true;
      _textToSpeechEnabled = prefs.getBool('textToSpeechEnabled') ?? true;
      _speechToTextEnabled = prefs.getBool('speechToTextEnabled') ?? true;
      _speechRate = prefs.getDouble('speechRate') ?? 0.5;
      
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load settings: $e';
      notifyListeners();
    }
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      if (value is bool) {
        await prefs.setBool(key, value);
      } else if (value is String) {
        await prefs.setString(key, value);
      } else if (value is int) {
        await prefs.setInt(key, value);
      } else if (value is double) {
        await prefs.setDouble(key, value);
      }
    } catch (e) {
      _error = 'Failed to save setting: $e';
      notifyListeners();
    }
  }

  // Setters with persistence
  void setDarkMode(bool value) {
    _isDarkMode = value;
    _saveSetting('isDarkMode', value);
    notifyListeners();
  }

  void setUseSystemTheme(bool value) {
    _useSystemTheme = value;
    _saveSetting('useSystemTheme', value);
    notifyListeners();
  }

  void setAutoDetectLanguage(bool value) {
    _autoDetectLanguage = value;
    _saveSetting('autoDetectLanguage', value);
    notifyListeners();
  }

  void setSaveHistory(bool value) {
    _saveHistory = value;
    _saveSetting('saveHistory', value);
    notifyListeners();
  }

  void setTextToSpeechEnabled(bool value) {
    _textToSpeechEnabled = value;
    _saveSetting('textToSpeechEnabled', value);
    notifyListeners();
  }

  void setSpeechToTextEnabled(bool value) {
    _speechToTextEnabled = value;
    _saveSetting('speechToTextEnabled', value);
    notifyListeners();
  }

  void setSpeechRate(double value) {
    _speechRate = value;
    _saveSetting('speechRate', value);
    notifyListeners();
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }

  // Get theme mode based on settings
  ThemeMode getThemeMode() {
    if (_useSystemTheme) {
      return ThemeMode.system;
    }
    return _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }
}