import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class AdminLanguageService {
  static const String _languageKey = 'admin_selected_language';
  
  static Future<String> getSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? 'es'; // Español por defecto
  }
  
  static Future<void> setSelectedLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }
  
  static Future<Locale> getLocale() async {
    final languageCode = await getSelectedLanguage();
    return Locale(languageCode);
  }
  
  static List<Map<String, String>> getSupportedLanguages() {
    return [
      {'code': 'en', 'name': 'English', 'nativeName': 'English'},
      {'code': 'es', 'name': 'Spanish', 'nativeName': 'Español'},
    ];
  }
}