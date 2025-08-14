import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? getInstance(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  // Textos de autenticación
  String get welcomeBack => _localizedValues[locale.languageCode]!['welcome_back']!;
  String get englishLearning => _localizedValues[locale.languageCode]!['english_learning']!;
  String get email => _localizedValues[locale.languageCode]!['email']!;
  String get password => _localizedValues[locale.languageCode]!['password']!;
  String get login => _localizedValues[locale.languageCode]!['login']!;
  String get dontHaveAccount => _localizedValues[locale.languageCode]!['dont_have_account']!;
  String get signUp => _localizedValues[locale.languageCode]!['sign_up']!;
  String get pleaseEnterEmail => _localizedValues[locale.languageCode]!['please_enter_email']!;
  String get pleaseEnterValidEmail => _localizedValues[locale.languageCode]!['please_enter_valid_email']!;
  String get pleaseEnterPassword => _localizedValues[locale.languageCode]!['please_enter_password']!;
  String get passwordMinLength => _localizedValues[locale.languageCode]!['password_min_length']!;
  String get invalidEmailPassword => _localizedValues[locale.languageCode]!['invalid_email_password']!;
  String get errorOccurred => _localizedValues[locale.languageCode]!['error_occurred']!;

  // Registro
  String get createAccount => _localizedValues[locale.languageCode]!['create_account']!;
  String get fullName => _localizedValues[locale.languageCode]!['full_name']!;
  String get confirmPassword => _localizedValues[locale.languageCode]!['confirm_password']!;
  String get pleaseEnterName => _localizedValues[locale.languageCode]!['please_enter_name']!;
  String get pleaseConfirmPassword => _localizedValues[locale.languageCode]!['please_confirm_password']!;
  String get passwordsDoNotMatch => _localizedValues[locale.languageCode]!['passwords_do_not_match']!;
  String get emailAlreadyRegistered => _localizedValues[locale.languageCode]!['email_already_registered']!;

  // Home
  String get welcome => _localizedValues[locale.languageCode]!['welcome']!;
  String get keepLearning => _localizedValues[locale.languageCode]!['keep_learning']!;
  String get home => _localizedValues[locale.languageCode]!['home']!;
  String get lessons => _localizedValues[locale.languageCode]!['lessons']!;
  String get achievements => _localizedValues[locale.languageCode]!['achievements']!;
  String get settings => _localizedValues[locale.languageCode]!['settings']!;
  String get completePreviousLevel => _localizedValues[locale.languageCode]!['complete_previous_level']!;
  String get completed => _localizedValues[locale.languageCode]!['completed']!;

  // Juegos
  String get level => _localizedValues[locale.languageCode]!['level']!;
  String get game => _localizedValues[locale.languageCode]!['game']!;
  String get of => _localizedValues[locale.languageCode]!['of']!;
  String get playAgain => _localizedValues[locale.languageCode]!['play_again']!;
  String get completeMissingLetter => _localizedValues[locale.languageCode]!['complete_missing_letter']!;
  String get chooseCorrectTranslation => _localizedValues[locale.languageCode]!['choose_correct_translation']!;
  String get chooseCorrectPronunciation => _localizedValues[locale.languageCode]!['choose_correct_pronunciation']!;
  String get completeSentence => _localizedValues[locale.languageCode]!['complete_sentence']!;
  String get chooseCorrectAnswer => _localizedValues[locale.languageCode]!['choose_correct_answer']!;
  String get completeGreeting => _localizedValues[locale.languageCode]!['complete_greeting']!;
  String get chooseCorrectVerb => _localizedValues[locale.languageCode]!['choose_correct_verb']!;
  String get correct => _localizedValues[locale.languageCode]!['correct']!;
  String get incorrect => _localizedValues[locale.languageCode]!['incorrect']!;
  String get excellentWork => _localizedValues[locale.languageCode]!['excellent_work']!;
  String get dontWorryTryAgain => _localizedValues[locale.languageCode]!['dont_worry_try_again']!;
  String get continueText => _localizedValues[locale.languageCode]!['continue']!;
  String get tryAgain => _localizedValues[locale.languageCode]!['try_again']!;
  String get congratulations => _localizedValues[locale.languageCode]!['congratulations']!;
  String get completedLevel => _localizedValues[locale.languageCode]!['completed_level']!;
  String get levelUnlocked => _localizedValues[locale.languageCode]!['level_unlocked']!;

  // Logros
  String get unlocked => _localizedValues[locale.languageCode]!['unlocked']!;
  String get locked => _localizedValues[locale.languageCode]!['locked']!;
  String get close => _localizedValues[locale.languageCode]!['close']!;
  String get firstSteps => _localizedValues[locale.languageCode]!['first_steps']!;
  String get firstStepsDesc => _localizedValues[locale.languageCode]!['first_steps_desc']!;
  String get gettingStarted => _localizedValues[locale.languageCode]!['getting_started']!;
  String get gettingStartedDesc => _localizedValues[locale.languageCode]!['getting_started_desc']!;
  String get starCollector => _localizedValues[locale.languageCode]!['star_collector']!;
  String get starCollectorDesc => _localizedValues[locale.languageCode]!['star_collector_desc']!;
  String get consistentLearner => _localizedValues[locale.languageCode]!['consistent_learner']!;
  String get consistentLearnerDesc => _localizedValues[locale.languageCode]!['consistent_learner_desc']!;
  String get perfectionist => _localizedValues[locale.languageCode]!['perfectionist']!;
  String get perfectionistDesc => _localizedValues[locale.languageCode]!['perfectionist_desc']!;
  String get master => _localizedValues[locale.languageCode]!['master']!;
  String get masterDesc => _localizedValues[locale.languageCode]!['master_desc']!;

  // Configuración
  String get userProfile => _localizedValues[locale.languageCode]!['user_profile']!;
  String get audioSettings => _localizedValues[locale.languageCode]!['audio_settings']!;
  String get soundEffects => _localizedValues[locale.languageCode]!['sound_effects']!;
  String get soundEffectsDesc => _localizedValues[locale.languageCode]!['sound_effects_desc']!;
  String get backgroundMusic => _localizedValues[locale.languageCode]!['background_music']!;
  String get backgroundMusicDesc => _localizedValues[locale.languageCode]!['background_music_desc']!;
  String get general => _localizedValues[locale.languageCode]!['general']!;
  String get language => _localizedValues[locale.languageCode]!['language']!;
  String get languageDesc => _localizedValues[locale.languageCode]!['language_desc']!;
  String get helpSupport => _localizedValues[locale.languageCode]!['help_support']!;
  String get helpSupportDesc => _localizedValues[locale.languageCode]!['help_support_desc']!;
  String get about => _localizedValues[locale.languageCode]!['about']!;
  String get aboutDesc => _localizedValues[locale.languageCode]!['about_desc']!;
  String get logout => _localizedValues[locale.languageCode]!['logout']!;
  String get cancel => _localizedValues[locale.languageCode]!['cancel']!;
  String get areYouSureLogout => _localizedValues[locale.languageCode]!['are_you_sure_logout']!;

  // Diálogos de ayuda y acerca de
  String get helpTitle => _localizedValues[locale.languageCode]!['help_title']!;
  String get helpContent => _localizedValues[locale.languageCode]!['help_content']!;
  String get aboutTitle => _localizedValues[locale.languageCode]!['about_title']!;
  String get aboutContent => _localizedValues[locale.languageCode]!['about_content']!;
  String get selectLanguage => _localizedValues[locale.languageCode]!['select_language']!;
  String get languageChanged => _localizedValues[locale.languageCode]!['language_changed']!;
  String get restartRequired => _localizedValues[locale.languageCode]!['restart_required']!;

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // Autenticación
      'welcome_back': 'Welcome back!',
      'english_learning': 'English Learning',
      'email': 'Email',
      'password': 'Password',
      'login': 'Login',
      'dont_have_account': "Don't have an account? ",
      'sign_up': 'Sign up',
      'please_enter_email': 'Please enter your email',
      'please_enter_valid_email': 'Please enter a valid email',
      'please_enter_password': 'Please enter your password',
      'password_min_length': 'Password must be at least 6 characters',
      'invalid_email_password': 'Invalid email or password',
      'error_occurred': 'An error occurred. Please try again.',

      // Registro
      'create_account': 'Create Account',
      'full_name': 'Full Name',
      'confirm_password': 'Confirm Password',
      'please_enter_name': 'Please enter your name',
      'please_confirm_password': 'Please confirm your password',
      'passwords_do_not_match': 'Passwords do not match',
      'email_already_registered': 'Email already registered',

      // Home
      'welcome': 'Welcome!',
      'keep_learning': 'Keep learning!',
      'home': 'Home',
      'lessons': 'Lessons',
      'achievements': 'Achievements',
      'settings': 'Settings',
      'complete_previous_level': 'Complete the previous level to unlock this one!',
      'completed': 'Completed',

      // Juegos
      'level': 'Level',
      'game': 'Game',
      'of': 'of',
      'play_again': 'Play again',
      'complete_missing_letter': 'Complete the missing letter',
      'choose_correct_translation': 'Choose the correct translation',
      'choose_correct_pronunciation': 'Choose the correct pronunciation',
      'complete_sentence': 'Complete the sentence',
      'choose_correct_answer': 'Choose the correct answer',
      'complete_greeting': 'Complete the greeting',
      'choose_correct_verb': 'Choose the correct verb',
      'correct': 'Correct!',
      'incorrect': 'Incorrect!',
      'excellent_work': 'Excellent work!',
      'dont_worry_try_again': "Don't worry, try again",
      'continue': 'Continue',
      'try_again': 'Try again',
      'congratulations': 'Congratulations!',
      'completed_level': 'You have completed Level',
      'level_unlocked': 'Level {level} has been unlocked!',

      // Logros
      'unlocked': 'Unlocked',
      'locked': 'Locked',
      'close': 'Close',
      'first_steps': 'First Steps',
      'first_steps_desc': 'Complete your first level',
      'getting_started': 'Getting Started',
      'getting_started_desc': 'Complete 5 levels',
      'star_collector': 'Star Collector',
      'star_collector_desc': 'Collect 10 stars',
      'consistent_learner': 'Consistent Learner',
      'consistent_learner_desc': 'Maintain a 5-day streak',
      'perfectionist': 'Perfectionist',
      'perfectionist_desc': 'Get 3 stars in a level',
      'master': 'Master',
      'master_desc': 'Complete all levels',

      // Configuración
      'user_profile': 'User Profile',
      'audio_settings': 'Audio Settings',
      'sound_effects': 'Sound Effects',
      'sound_effects_desc': 'Enable button clicks and game sounds',
      'background_music': 'Background Music',
      'background_music_desc': 'Enable background music during gameplay',
      'general': 'General',
      'language': 'Language',
      'language_desc': 'Change app language',
      'help_support': 'Help & Support',
      'help_support_desc': 'Get help and contact support',
      'about': 'About',
      'about_desc': 'App version and information',
      'logout': 'Logout',
      'cancel': 'Cancel',
      'are_you_sure_logout': 'Are you sure you want to logout?',

      // Diálogos
      'help_title': 'Help & Support',
      'help_content': 'Welcome to English Learning App!\n\n• Complete levels to unlock new ones\n• Earn stars based on your performance\n• Unlock achievements as you progress\n• Customize your experience in settings\n\nNeed more help? Contact us at support@englishapp.com',
      'about_title': 'About',
      'about_content': 'English Learning App\nVersion 1.0.0\n\nA fun and interactive way to learn English through games and challenges.\n\nDeveloped with ❤️ using Flutter',
      'select_language': 'Select Language',
      'language_changed': 'Language changed successfully',
      'restart_required': 'Please restart the app to apply changes',
    },
    'es': {
      // Autenticación
      'welcome_back': '¡Bienvenido de vuelta!',
      'english_learning': 'Aprendizaje de Inglés',
      'email': 'Correo electrónico',
      'password': 'Contraseña',
      'login': 'Iniciar sesión',
      'dont_have_account': '¿No tienes una cuenta? ',
      'sign_up': 'Registrarse',
      'please_enter_email': 'Por favor ingresa tu correo electrónico',
      'please_enter_valid_email': 'Por favor ingresa un correo válido',
      'please_enter_password': 'Por favor ingresa tu contraseña',
      'password_min_length': 'La contraseña debe tener al menos 6 caracteres',
      'invalid_email_password': 'Correo o contraseña inválidos',
      'error_occurred': 'Ocurrió un error. Por favor intenta de nuevo.',

      // Registro
      'create_account': 'Crear Cuenta',
      'full_name': 'Nombre Completo',
      'confirm_password': 'Confirmar Contraseña',
      'please_enter_name': 'Por favor ingresa tu nombre',
      'please_confirm_password': 'Por favor confirma tu contraseña',
      'passwords_do_not_match': 'Las contraseñas no coinciden',
      'email_already_registered': 'Correo ya registrado',

      // Home
      'welcome': '¡Bienvenido!',
      'keep_learning': '¡Sigue aprendiendo!',
      'home': 'Inicio',
      'lessons': 'Lecciones',
      'achievements': 'Logros',
      'settings': 'Configuración',
      'complete_previous_level': '¡Completa el nivel anterior para desbloquear este!',
      'completed': 'Completado',

      // Juegos
      'level': 'Nivel',
      'game': 'Juego',
      'of': 'de',
      'play_again': 'Jugar nuevamente',
      'complete_missing_letter': 'Completa la letra faltante',
      'choose_correct_translation': 'Elige la traducción correcta',
      'choose_correct_pronunciation': 'Elige la pronunciación correcta',
      'complete_sentence': 'Completa la oración',
      'choose_correct_answer': 'Elige la respuesta correcta',
      'complete_greeting': 'Completa el saludo',
      'choose_correct_verb': 'Elige el verbo correcto',
      'correct': '¡Correcto!',
      'incorrect': '¡Incorrecto!',
      'excellent_work': '¡Excelente trabajo!',
      'dont_worry_try_again': 'No te preocupes, inténtalo de nuevo',
      'continue': 'Continuar',
      'try_again': 'Intentar de nuevo',
      'congratulations': '¡Felicitaciones!',
      'completed_level': 'Has completado el Nivel',
      'level_unlocked': '¡El Nivel {level} se ha desbloqueado!',

      // Logros
      'unlocked': 'Desbloqueado',
      'locked': 'Bloqueado',
      'close': 'Cerrar',
      'first_steps': 'Primeros Pasos',
      'first_steps_desc': 'Completa tu primer nivel',
      'getting_started': 'Comenzando',
      'getting_started_desc': 'Completa 5 niveles',
      'star_collector': 'Coleccionista de Estrellas',
      'star_collector_desc': 'Recolecta 10 estrellas',
      'consistent_learner': 'Estudiante Constante',
      'consistent_learner_desc': 'Mantén una racha de 5 días',
      'perfectionist': 'Perfeccionista',
      'perfectionist_desc': 'Obtén 3 estrellas en un nivel',
      'master': 'Maestro',
      'master_desc': 'Completa todos los niveles',

      // Configuración
      'user_profile': 'Perfil de Usuario',
      'audio_settings': 'Configuración de Audio',
      'sound_effects': 'Efectos de Sonido',
      'sound_effects_desc': 'Habilitar clics de botones y sonidos del juego',
      'background_music': 'Música de Fondo',
      'background_music_desc': 'Habilitar música de fondo durante el juego',
      'general': 'General',
      'language': 'Idioma',
      'language_desc': 'Cambiar idioma de la aplicación',
      'help_support': 'Ayuda y Soporte',
      'help_support_desc': 'Obtener ayuda y contactar soporte',
      'about': 'Acerca de',
      'about_desc': 'Versión de la app e información',
      'logout': 'Cerrar sesión',
      'cancel': 'Cancelar',
      'are_you_sure_logout': '¿Estás seguro de que quieres cerrar sesión?',

      // Diálogos
      'help_title': 'Ayuda y Soporte',
      'help_content': '¡Bienvenido a la App de Aprendizaje de Inglés!\n\n• Completa niveles para desbloquear nuevos\n• Gana estrellas basadas en tu rendimiento\n• Desbloquea logros mientras progresas\n• Personaliza tu experiencia en configuración\n\n¿Necesitas más ayuda? Contáctanos en support@englishapp.com',
      'about_title': 'Acerca de',
      'about_content': 'App de Aprendizaje de Inglés\nVersión 1.0.0\n\nUna forma divertida e interactiva de aprender inglés a través de juegos y desafíos.\n\nDesarrollado con ❤️ usando Flutter',
      'select_language': 'Seleccionar Idioma',
      'language_changed': 'Idioma cambiado exitosamente',
      'restart_required': 'Por favor reinicia la app para aplicar los cambios',
    },
  };
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'es'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
