import 'package:flutter/material.dart';
import 'package:translation_chatbot/models/message.dart';
import 'package:translation_chatbot/models/language.dart';
import 'package:translation_chatbot/services/translation_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ChatProvider extends ChangeNotifier {
  List<Message> _messages = [];
  bool _isLoading = false;
  String _error = '';
  final TranslationService _translationService = TranslationService();

  List<Message> get messages => _messages;
  bool get isLoading => _isLoading;
  String get error => _error;

  ChatProvider() {
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final messagesJson = prefs.getStringList('messages') ?? [];
      
      _messages = messagesJson
          .map((json) => Message.fromJson(jsonDecode(json)))
          .toList();
      
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load messages: $e';
      notifyListeners();
    }
  }

  Future<void> _saveMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final messagesJson = _messages
          .map((message) => jsonEncode(message.toJson()))
          .toList();
      
      await prefs.setStringList('messages', messagesJson);
    } catch (e) {
      _error = 'Failed to save messages: $e';
      notifyListeners();
    }
  }

  Future<void> sendMessage({
    required String text,
    required Language sourceLanguage,
    required Language targetLanguage,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Create user message
      final userMessage = Message(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
        sourceLanguage: sourceLanguage.code,
        targetLanguage: targetLanguage.code,
      );
      
      _messages.insert(0, userMessage);
      notifyListeners();

      // Translate the text
      final translatedText = await _translationService.translateText(
        text: text,
        sourceLanguage: sourceLanguage.code,
        targetLanguage: targetLanguage.code,
      );

      print('Translated text: $translatedText');

      // Create bot message with the translation
      final botMessage = Message(
        text: text,
        isUser: false,
        translatedText: translatedText,
        timestamp: DateTime.now(),
        sourceLanguage: sourceLanguage.code,
        targetLanguage: targetLanguage.code,
      );
      
      _messages.insert(0, botMessage);
      _isLoading = false;
      notifyListeners();
      
      // Save messages
      await _saveMessages();
    } catch (e) {
      _isLoading = false;
      _error = 'Translation failed: $e';
      notifyListeners();
    }
  }

  void deleteMessage(Message message) {
    _messages.remove(message);
    notifyListeners();
    _saveMessages();
  }

  void clearHistory() {
    _messages.clear();
    notifyListeners();
    _saveMessages();
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }
}