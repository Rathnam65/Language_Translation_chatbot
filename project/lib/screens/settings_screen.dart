import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translation_chatbot/providers/settings_provider.dart';
import 'package:translation_chatbot/widgets/settings_section.dart';
import 'package:translation_chatbot/widgets/settings_switch_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme settings
          SettingsSection(
            title: 'Appearance',
            children: [
              SettingsSwitchTile(
                title: 'Dark Theme',
                subtitle: 'Enable dark theme for the app',
                value: settingsProvider.isDarkMode,
                onChanged: (value) {
                  settingsProvider.setDarkMode(value);
                },
                leadingIcon: Icons.dark_mode,
              ),
              SettingsSwitchTile(
                title: 'Use System Theme',
                subtitle: 'Follow system dark/light mode setting',
                value: settingsProvider.useSystemTheme,
                onChanged: (value) {
                  settingsProvider.setUseSystemTheme(value);
                },
                leadingIcon: Icons.sync,
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Translation settings
          SettingsSection(
            title: 'Translation',
            children: [
              SettingsSwitchTile(
                title: 'Auto-Detect Language',
                subtitle: 'Automatically detect source language',
                value: settingsProvider.autoDetectLanguage,
                onChanged: (value) {
                  settingsProvider.setAutoDetectLanguage(value);
                },
                leadingIcon: Icons.auto_awesome,
              ),
              SettingsSwitchTile(
                title: 'Save History',
                subtitle: 'Save translation history',
                value: settingsProvider.saveHistory,
                onChanged: (value) {
                  settingsProvider.setSaveHistory(value);
                },
                leadingIcon: Icons.history,
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Audio settings
          SettingsSection(
            title: 'Audio',
            children: [
              SettingsSwitchTile(
                title: 'Text-to-Speech',
                subtitle: 'Enable text-to-speech for translations',
                value: settingsProvider.textToSpeechEnabled,
                onChanged: (value) {
                  settingsProvider.setTextToSpeechEnabled(value);
                },
                leadingIcon: Icons.record_voice_over,
              ),
              SettingsSwitchTile(
                title: 'Speech-to-Text',
                subtitle: 'Enable voice input for translations',
                value: settingsProvider.speechToTextEnabled,
                onChanged: (value) {
                  settingsProvider.setSpeechToTextEnabled(value);
                },
                leadingIcon: Icons.mic,
              ),
              ListTile(
                title: const Text('Speech Rate'),
                subtitle: const Text('Adjust the speech playback speed'),
                leading: const Icon(Icons.speed),
                trailing: SizedBox(
                  width: 120,
                  child: Slider(
                    value: settingsProvider.speechRate,
                    min: 0.25,
                    max: 2.0,
                    divisions: 7,
                    label: settingsProvider.speechRate.toStringAsFixed(2),
                    onChanged: (value) {
                      settingsProvider.setSpeechRate(value);
                    },
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // About section
          SettingsSection(
            title: 'About',
            children: [
              const ListTile(
                title: Text('Version'),
                subtitle: Text('1.0.0'),
                leading: Icon(Icons.info_outline),
              ),
              ListTile(
                title: const Text('Privacy Policy'),
                leading: const Icon(Icons.privacy_tip_outlined),
                onTap: () {
                  // Navigate to privacy policy
                },
              ),
              ListTile(
                title: const Text('Terms of Service'),
                leading: const Icon(Icons.description_outlined),
                onTap: () {
                  // Navigate to terms of service
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}