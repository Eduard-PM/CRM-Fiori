import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/usuario.dart';

class AuthService {
  final String baseUrl = "http://127.0.0.1:8000";

  // ============================
  // LOGIN
  // ============================
  Future<String?> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/auth/login");

    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (res.statusCode != 200) return null;

    final data = jsonDecode(res.body);
    return data["access_token"];
  }

  // ============================
  // GET ME (requiere token)
  // ============================
  Future<Usuario?> getMe(String token) async {
    final url = Uri.parse("$baseUrl/auth/me");

    final res = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    if (res.statusCode != 200) return null;

    final data = jsonDecode(res.body);
    return Usuario.fromJson(data);
  }
}
