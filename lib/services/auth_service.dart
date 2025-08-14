import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserModel? currentUser;

  // Iniciar sesión con Google
  Future<UserModel?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final userCredential = await _auth.signInWithCredential(credential);
    final user = userCredential.user;
    if (user != null) {
      currentUser = UserModel(
        name: user.displayName ?? '',
        email: user.email ?? '',
        role: 'user',
        unlockedLevels: [1],
        levelStars: {},
        streak: 0,
        totalStars: 0,
        photoUrl: user.photoURL ?? '',
      );
      await _saveUserToPrefs(currentUser!);
      // Guardar en Firestore solo si es nuevo
      final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final docSnapshot = await userDoc.get();
      if (!docSnapshot.exists) {
        await userDoc.set(currentUser!.toJson());
        print('Usuario guardado en Firestore');
      }
      return currentUser;
    }
    return null;
  }

  // Registrar usuario con email y password
  Future<UserModel?> registerWithEmail(String name, String email, String password) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    final user = userCredential.user;
    if (user != null) {
      await user.updateDisplayName(name);
      currentUser = UserModel(
        name: name,
        email: email,
        role: 'user',
        unlockedLevels: [1],
        levelStars: {},
        streak: 0,
        totalStars: 0,
        photoUrl: user.photoURL ?? '',
      );
      await _saveUserToPrefs(currentUser!);

      // Guardar en Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set(currentUser!.toJson());

      return currentUser;
    }
    return null;
  }

  // Iniciar sesión con email y password
  Future<UserModel?> signInWithEmail(String email, String password) async {
    final userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    final user = userCredential.user;
    if (user != null) {
      currentUser = UserModel(
        name: user.displayName ?? '',
        email: user.email ?? '',
        role: 'user',
        photoUrl: user.photoURL ?? '',
      );
      await _saveUserToPrefs(currentUser!);
      return currentUser;
    }
    return null;
  }

  // Olvidó su contraseña
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Cerrar sesión
  Future<void> signOut() async {
    await _auth.signOut();
    currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Mantener sesión activa y cargar usuario al iniciar la app
  Future<UserModel?> loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      currentUser = UserModel.fromJson(jsonDecode(userJson));
      return currentUser;
    }
    return null;
  }

  Future<void> _saveUserToPrefs(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(user.toJson()));
  }

  // Verificar si hay sesión activa
  bool isLoggedIn() => _auth.currentUser != null;
}