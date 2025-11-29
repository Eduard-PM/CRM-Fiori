import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/cliente_model.dart';

class ClientesService {
  final String baseUrl = "http://127.0.0.1:8000";

  Future<List<ClienteModel>> obtenerClientes(String token) async {
    final url = Uri.parse("$baseUrl/clientes");

    final res = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    if (res.statusCode != 200) {
      throw Exception("Error al obtener clientes");
    }

    final List data = json.decode(res.body);
    return data.map((c) => ClienteModel.fromJson(c)).toList();
  }
}
