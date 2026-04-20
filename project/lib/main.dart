import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:translation_chatbot/providers/chat_provider.dart';
import 'package:translation_chatbot/providers/language_provider.dart';
import 'package:translation_chatbot/providers/settings_provider.dart';
import 'package:translation_chatbot/screens/home_screen.dart';
import 'package:translation_chatbot/screens/history_screen.dart';
import 'package:translation_chatbot/screens/settings_screen.dart';
import 'package:translation_chatbot/theme/app_theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String apiUrl = 'http://127.0.0.1:8000';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, _) {
          final themeMode = settingsProvider.getThemeMode();          return MaterialApp(
            title: 'Translation Chatbot',
            debugShowCheckedModeBanner: false,
            themeMode: themeMode,
            theme: AppTheme.lightTheme(),
            darkTheme: AppTheme.darkTheme(),
            home: const AppNavigator(),
          );
        },
      ),
    );
  }
}

class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const HistoryScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.translate),
            label: 'Translate',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

// Example translation function (move to a service/provider in production)
Future<String?> translateText(String text, String sourceLanguage, String targetLanguage) async {
  final response = await http.post(
    Uri.parse('$apiUrl/translate'),
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
}

// Supported language codes for facebook/mbart-large-50-many-to-many-mmt
final Map<String, String> mbart50Languages = {
  "ar_AR": "Arabic",
  "cs_CZ": "Czech",
  "de_DE": "German",
  "en_XX": "English",
  "es_XX": "Spanish",
  "et_EE": "Estonian",
  "fi_FI": "Finnish",
  "fr_XX": "French",
  "gu_IN": "Gujarati",
  "hi_IN": "Hindi",
  "it_IT": "Italian",
  "ja_XX": "Japanese",
  "kk_KZ": "Kazakh",
  "ko_KR": "Korean",
  "lt_LT": "Lithuanian",
  "lv_LV": "Latvian",
  "my_MM": "Burmese",
  "ne_NP": "Nepali",
  "nl_XX": "Dutch",
  "ro_RO": "Romanian",
  "ru_RU": "Russian",
  "si_LK": "Sinhala",
  "tr_TR": "Turkish",
  "vi_VN": "Vietnamese",
  "zh_CN": "Chinese",
  "pl_PL": "Polish",
  "fa_IR": "Persian",
  "uk_UA": "Ukrainian",
  "sv_SE": "Swedish",
  "xh_ZA": "Xhosa",
  "gl_ES": "Galician",
  "sl_SI": "Slovenian",
  "hr_HR": "Croatian",
  "sr_XX": "Serbian",
  "he_IL": "Hebrew",
  "id_ID": "Indonesian",
  "th_TH": "Thai",
  "ps_AF": "Pashto",
  "hy_AM": "Armenian",
  "az_AZ": "Azerbaijani",
  "ka_GE": "Georgian",
  "bn_IN": "Bengali",
  "ta_IN": "Tamil",
  "te_IN": "Telugu",
  "ml_IN": "Malayalam",
  "ur_PK": "Urdu",
  "km_KH": "Khmer",
  "mn_MN": "Mongolian",
  "uz_UZ": "Uzbek",
  "ky_KG": "Kyrgyz",
  "sw_KE": "Swahili",
  "so_SO": "Somali",
  "af_ZA": "Afrikaans",
  "sq_AL": "Albanian",
  "am_ET": "Amharic",
  "bs_BA": "Bosnian",
  "bg_BG": "Bulgarian",
  "ca_ES": "Catalan",
  "eo_EO": "Esperanto",
  "ga_IE": "Irish",
  "is_IS": "Icelandic",
  "mk_MK": "Macedonian",
  "ms_MY": "Malay",
  "mt_MT": "Maltese",
  "qu_PE": "Quechua",
  "sk_SK": "Slovak",
  "tl_XX": "Tagalog",
  "cy_GB": "Welsh",
};