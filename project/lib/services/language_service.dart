import 'package:translation_chatbot/models/language.dart';

class LanguageService {
  // Get supported languages from Google Translate API
  Future<List<Language>> getLanguages() async {
    try {
      // For demo purposes, we'll use a static list first
      // In production, you would use the Google Translate API
      return _getStaticLanguages();
    } catch (e) {
      throw Exception('Failed to load languages: $e');
    }
  }

  // Static list of commonly used languages for demo
  Future<List<Language>> _getStaticLanguages() async {
    // In a real app, these would come from an API
    return [
      Language(code: 'auto', name: 'Detect Language', nativeName: 'Detect Language'),
      Language(code: 'en', name: 'English', nativeName: 'English'),
      Language(code: 'es', name: 'Spanish', nativeName: 'Español'),
      Language(code: 'fr', name: 'French', nativeName: 'Français'),
      Language(code: 'de', name: 'German', nativeName: 'Deutsch'),
      Language(code: 'it', name: 'Italian', nativeName: 'Italiano'),
      Language(code: 'pt', name: 'Portuguese', nativeName: 'Português'),
      Language(code: 'ru', name: 'Russian', nativeName: 'Русский'),
      Language(code: 'ja', name: 'Japanese', nativeName: '日本語'),
      Language(code: 'zh', name: 'Chinese (Simplified)', nativeName: '简体中文'),
      Language(code: 'ar', name: 'Arabic', nativeName: 'العربية'),
      Language(code: 'hi', name: 'Hindi', nativeName: 'हिन्दी'),
      Language(code: 'ko', name: 'Korean', nativeName: '한국어'),
      Language(code: 'tr', name: 'Turkish', nativeName: 'Türkçe'),
      Language(code: 'vi', name: 'Vietnamese', nativeName: 'Tiếng Việt'),
      Language(code: 'th', name: 'Thai', nativeName: 'ไทย'),
      Language(code: 'nl', name: 'Dutch', nativeName: 'Nederlands'),
      Language(code: 'sv', name: 'Swedish', nativeName: 'Svenska'),
      Language(code: 'fi', name: 'Finnish', nativeName: 'Suomi'),
      Language(code: 'pl', name: 'Polish', nativeName: 'Polski'),
    ];
  }
}