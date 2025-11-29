import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/usuario.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _auth = AuthService();

  Usuario? usuario;
  String? token;
  bool isLoading = false;

  // =============================
  // LOGIN
  // =============================
  Future<bool> login(String email, String password) async {
    isLoading = true;
    notifyListeners();

    token = await _auth.login(email, password);

    if (token == null) {
      isLoading = false;
      notifyListeners();
      return false;
    }

    // Guardar token
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token!);

    // Obtener usuario
    usuario = await _auth.getMe(token!);

    isLoading = false;
    notifyListeners();

    return usuario != null;
  }

  // =============================
  // RESTAURAR SESIÓN
  // =============================
  Future<bool> tryRestoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");

    if (token == null) return false;

    usuario = await _auth.getMe(token!);

    notifyListeners();
    return usuario != null;
  }

  // =============================
  // LOGOUT
  // =============================
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");

    usuario = null;
    token = null;

    notifyListeners();
  }
}
