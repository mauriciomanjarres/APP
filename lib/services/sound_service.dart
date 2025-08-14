import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class SoundService {
  static const String _soundEnabledKey = 'sound_enabled';
  static const String _musicEnabledKey = 'music_enabled';

  static Future<bool> isSoundEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_soundEnabledKey) ?? true;
  }

  static Future<bool> isMusicEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_musicEnabledKey) ?? true;
  }

  static Future<void> setSoundEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundEnabledKey, enabled);
  }

  static Future<void> setMusicEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_musicEnabledKey, enabled);
  }

  static Future<void> playCorrectSound() async {
    if (await isSoundEnabled()) {
      SystemSound.play(SystemSoundType.click);
      // Aquí podrías usar un paquete como audioplayers para sonidos personalizados
    }
  }

  static Future<void> playIncorrectSound() async {
    if (await isSoundEnabled()) {
      HapticFeedback.vibrate();
      // Aquí podrías usar un paquete como audioplayers para sonidos personalizados
    }
  }

  static Future<void> playButtonSound() async {
    if (await isSoundEnabled()) {
      SystemSound.play(SystemSoundType.click);
    }
  }

  static Future<void> playLevelCompleteSound() async {
    if (await isSoundEnabled()) {
      SystemSound.play(SystemSoundType.click);
      HapticFeedback.lightImpact();
    }
  }
}
