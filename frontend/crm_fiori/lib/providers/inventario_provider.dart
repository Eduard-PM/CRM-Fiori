import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/producto.dart';
import '../services/inventario_service.dart';

class InventarioProvider extends ChangeNotifier {
  final InventarioService _service = InventarioService();

  List<Producto> productos = [];
  bool isLoading = false;

  // CARGAR INVENTARIO
  Future<void> cargarInventario() async {
    isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token != null) {
      productos = await _service.obtenerProductos(token);
    }

    isLoading = false;
    notifyListeners();
  }

  // CREAR PRODUCTO
  Future<bool> crearProducto({
    required String nombre,
    required double precio,
    required double stock,
    required String categoria,
  }) async {
    isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) return false;

    final nuevo = await _service.crearProducto(
      token,
      nombre: nombre,
      precio: precio,
      stock: stock,
      categoria: categoria,
    );

    isLoading = false;

    if (nuevo != null) {
      productos.add(nuevo);
      notifyListeners();
      return true;
    }

    notifyListeners();
    return false;
  }

  // ACTUALIZAR STOCK
  Future<bool> actualizarStock(int id, double stock) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) return false;

    final ok = await _service.actualizarStock(token, id, stock);

    if (ok) {
      await cargarInventario();
    }

    return ok;
  }

  // NUEVO → para dashboard
  List<Producto> get productosStockBajo =>
      productos.where((p) => p.stock < 10).toList();
  int get alertasStock => productosStockBajo.length;
}
