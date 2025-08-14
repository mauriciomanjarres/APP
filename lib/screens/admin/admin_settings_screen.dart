import 'package:flutter/material.dart';
import '../../services/sound_service.dart';

class AdminSettingsScreen extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  final VoidCallback onLogout;
  final ValueChanged<Locale> onLocaleChanged;
  final Locale currentLocale;

  const AdminSettingsScreen({
    Key? key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.onLogout,
    required this.onLocaleChanged,
    required this.currentLocale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text(
          'Configuración',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        ListTile(
          leading: const Icon(Icons.language),
          title: const Text('Idioma'),
          trailing: DropdownButton<Locale>(
            value: currentLocale,
            items: const [
              DropdownMenuItem(
                value: Locale('es'),
                child: Text('Español'),
              ),
              DropdownMenuItem(
                value: Locale('en'),
                child: Text('English'),
              ),
            ],
            onChanged: (locale) async {
              if (locale != null) {
                onLocaleChanged(locale);
              }
            },
          ),
        ),
        SwitchListTile(
          secondary: const Icon(Icons.dark_mode),
          title: const Text('Modo oscuro'),
          value: isDarkMode,
          onChanged: (value) => onThemeChanged(value),
        ),
        const Divider(height: 32),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
          onTap: () async {
            await SoundService.playButtonSound();
            onLogout();
          },
        ),
      ],
    );
  }
}
