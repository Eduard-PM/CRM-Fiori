import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/venta.dart';

class VentasService {
  final String baseUrl = "http://localhost:8000";

  /// Registrar una venta
  Future<Venta> registrarVenta({
    required String token,
    required VentaCreateRequest data,
  }) async {
    final url = Uri.parse("$baseUrl/ventas/registrar");

    final res = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(data.toJson()),
    );

    if (res.statusCode != 201) {
      throw Exception("Error al registrar venta: ${res.body}");
    }

    return Venta.fromJson(jsonDecode(res.body));
  }

  /// Listar ventas (VentaListOut)
  Future<List<VentaListItem>> listarVentas({required String token}) async {
    final url = Uri.parse("$baseUrl/ventas/");

    final res = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    if (res.statusCode != 200) return [];

    final List data = jsonDecode(res.body);
    return data.map((e) => VentaListItem.fromJson(e)).toList();
  }

  /// Obtener venta completa por ID
  Future<Venta> obtenerVenta({
    required String token,
    required int ventaId,
  }) async {
    final url = Uri.parse("$baseUrl/ventas/$ventaId");

    final res = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    if (res.statusCode != 200) {
      throw Exception("Venta no encontrada");
    }

    return Venta.fromJson(jsonDecode(res.body));
  }
}
