import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/producto.dart';

class InventarioService {
  final String baseUrl = "http://127.0.0.1:8000";

  // ============================================================
  // LISTAR PRODUCTOS
  // ============================================================
  Future<List<Producto>> obtenerProductos(String token) async {
    final url = Uri.parse("$baseUrl/productos/");

    final resp = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    if (resp.statusCode != 200) return [];

    final List data = jsonDecode(resp.body);

    return data.map((e) => Producto.fromJson(e)).toList();
  }

  // ============================================================
  // CREAR PRODUCTO
  // ============================================================
  Future<Producto?> crearProducto(
    String token, {
    required String nombre,
    required double precio,
    required double stock,
    required String categoria,
  }) async {
    final url = Uri.parse("$baseUrl/productos/");

    final res = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "nombre": nombre,
        "categoria": categoria,
        "precio_unitario": precio,
        "stock_actual": stock,
        "stock_minimo": 5,
      }),
    );

    if (res.statusCode == 201) {
      return Producto.fromJson(jsonDecode(res.body));
    }

    return null;
  }

  // ============================================================
  // ACTUALIZAR STOCK
  // ============================================================
  Future<bool> actualizarStock(String token, int id, double nuevoStock) async {
    final url = Uri.parse("$baseUrl/productos/$id");

    final resp = await http.put(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"stock_actual": nuevoStock}),
    );

    return resp.statusCode == 200;
  }
}
