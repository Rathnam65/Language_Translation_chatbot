import 'dart:convert';
import 'package:http/http.dart' as http;

class TranslationService {
  final String _baseUrl = 'http://10.0.2.2:8000'; // Correct for Android emulator

  final Map<String, String> supportedPairs = {
    "es-en": "Helsinki-NLP/opus-mt-es-en",
    "en-es": "Helsinki-NLP/opus-mt-en-es",
    "fr-en": "Helsinki-NLP/opus-mt-fr-en",
    "en-fr": "Helsinki-NLP/opus-mt-en-fr",
    "de-en": "Helsinki-NLP/opus-mt-de-en",
    "en-de": "Helsinki-NLP/opus-mt-en-de",
    "it-en": "Helsinki-NLP/opus-mt-it-en",
    "en-it": "Helsinki-NLP/opus-mt-en-it",
    // Add more as needed
  };

  Future<String> translateText({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    try {
      final pairKey = "$sourceLanguage-$targetLanguage";
      if (!supportedPairs.containsKey(pairKey)) {
        throw Exception('This translation pair is not supported.');
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/translate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'text': text,
          'source_language': sourceLanguage,
          'target_language': targetLanguage,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['translation'];
      } else {
        final errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['detail'] ?? 'Translation failed');
      }
    } catch (e) {
      if (e.toString().contains('Connection refused')) {
        return _getMockTranslation(text, targetLanguage);
      }
      throw Exception('Translation error: $e');
    }
  }

  Future<String?> detectLanguage(String text) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/detect-language'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': text}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['detectedLanguage'];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // Mock translation for demo purposes only when API isn't available
  String _getMockTranslation(String text, String targetLanguage) {
    if (targetLanguage == 'es') {
      return 'Traducción simulada: $text';
    } else if (targetLanguage == 'fr') {
      return 'Traduction simulée: $text';
    } else if (targetLanguage == 'de') {
      return 'Simulierte Übersetzung: $text';
    } else if (targetLanguage == 'it') {
      return 'Traduzione simulata: $text';
    } else if (targetLanguage == 'ja') {
      return '模擬翻訳: $text';
    } else if (targetLanguage == 'zh') {
      return '模拟翻译: $text';
    } else {
      return 'Mock translation: $text';
    }
  }
}