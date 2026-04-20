import 'package:flutter/material.dart';
import 'package:translation_chatbot/models/language.dart';
import 'package:translation_chatbot/services/language_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  List<Language> _languages = [];
  Language? _sourceLanguage;
  Language? _targetLanguage;
  bool _isLoading = false;
  String _error = '';

  List<Language> get languages => _languages;
  Language? get sourceLanguage => _sourceLanguage;
  Language? get targetLanguage => _targetLanguage;
  bool get isLoading => _isLoading;
  String get error => _error;

  LanguageProvider() {
    _initLanguages();
  }

  Future<void> _initLanguages() async {
    await fetchLanguages();
    await loadSavedLanguages();
  }

  Future<void> fetchLanguages() async {
    try {
      _isLoading = true;
      notifyListeners();

      final languageService = LanguageService();
      _languages = await languageService.getLanguages();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to load languages: $e';
      notifyListeners();
    }
  }

  Future<void> loadSavedLanguages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sourceCode = prefs.getString('sourceLanguage') ?? 'en';
      final targetCode = prefs.getString('targetLanguage') ?? 'es';

      if (_languages.isNotEmpty) {
        _sourceLanguage = _languages.firstWhere(
          (lang) => lang.code == sourceCode,
          orElse: () => _languages.first,
        );
        
        _targetLanguage = _languages.firstWhere(
          (lang) => lang.code == targetCode,
          orElse: () => _languages.length > 1 ? _languages[1] : _languages.first,
        );
        
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to load saved languages: $e';
      notifyListeners();
    }
  }

  Future<void> setSourceLanguage(Language language) async {
    _sourceLanguage = language;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('sourceLanguage', language.code);
    } catch (e) {
      _error = 'Failed to save source language: $e';
      notifyListeners();
    }
  }

  Future<void> setTargetLanguage(Language language) async {
    _targetLanguage = language;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('targetLanguage', language.code);
    } catch (e) {
      _error = 'Failed to save target language: $e';
      notifyListeners();
    }
  }

  void swapLanguages() {
    if (_sourceLanguage != null && _targetLanguage != null) {
      final temp = _sourceLanguage;
      _sourceLanguage = _targetLanguage;
      _targetLanguage = temp;
      notifyListeners();
      
      // Save swapped languages
      _saveLanguagePreferences();
    }
  }

  Future<void> _saveLanguagePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_sourceLanguage != null) {
        await prefs.setString('sourceLanguage', _sourceLanguage!.code);
      }
      if (_targetLanguage != null) {
        await prefs.setString('targetLanguage', _targetLanguage!.code);
      }
    } catch (e) {
      _error = 'Failed to save language preferences: $e';
      notifyListeners();
    }
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }
}