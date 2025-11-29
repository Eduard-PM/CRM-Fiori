import 'package:flutter/material.dart';
import '../models/cliente_model.dart';
import '../services/clientes_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientesProvider extends ChangeNotifier {
  final ClientesService _service = ClientesService();

  List<ClienteModel> clientes = [];
  bool isLoading = false;

  Future<void> cargarClientes() async {
    isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token != null) {
      clientes = await _service.obtenerClientes(token);
    }

    isLoading = false;
    notifyListeners();
  }

  // NUEVO → para HomeScreen
  int get totalClientes => clientes.length;
}
