import 'package:flutter/material.dart';
import '../models/venta.dart';
import '../services/ventas_service.dart';
import 'auth_provider.dart';

class VentasProvider extends ChangeNotifier {
  final VentasService service;
  final AuthProvider authProvider;

  VentasProvider({required this.service, required this.authProvider});

  bool isLoading = false;
  bool isSaving = false;

  /// Lista general (VentaListOut)
  List<VentaListItem> ventas = [];

  /// Detalle cargado (VentaOut)
  Venta? ventaSeleccionada;

  String get _token => authProvider.token ?? "";

  // ============================================================
  // OBTENER LISTADO DE VENTAS
  // ============================================================
  Future<void> cargarVentas() async {
    if (_token.isEmpty) return;

    isLoading = true;
    notifyListeners();

    try {
      ventas = await service.listarVentas(token: _token);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // CARGAR DETALLE
  // ============================================================
  Future<void> cargarVentaDetalle(int id) async {
    if (_token.isEmpty) return;

    isLoading = true;
    notifyListeners();

    try {
      ventaSeleccionada = await service.obtenerVenta(
        token: _token,
        ventaId: id,
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // REGISTRAR VENTA
  // ============================================================
  Future<Venta> registrarVenta(VentaCreateRequest req) async {
    isSaving = true;
    notifyListeners();

    try {
      final venta = await service.registrarVenta(token: _token, data: req);

      // Insertar en listado (para actualización inmediata del historial)
      ventas.insert(
        0,
        VentaListItem(
          id: venta.id,
          idCliente: venta.idCliente,
          fechaVenta: venta.fechaVenta,
          total: venta.total,
        ),
      );

      notifyListeners();
      return venta;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  // ============================================================
  // GETTERS PARA HOME
  // ============================================================

  /// Ventas del día (suma total)
  double get ventasDelDia {
    final hoy = DateTime.now();

    return ventas
        .where(
          (v) =>
              v.fechaVenta.year == hoy.year &&
              v.fechaVenta.month == hoy.month &&
              v.fechaVenta.day == hoy.day,
        )
        .fold(0.0, (sum, v) => sum + v.total);
  }

  /// Número de transacciones del día
  int get numeroTransaccionesDia {
    final hoy = DateTime.now();

    return ventas
        .where(
          (v) =>
              v.fechaVenta.year == hoy.year &&
              v.fechaVenta.month == hoy.month &&
              v.fechaVenta.day == hoy.day,
        )
        .length;
  }
}
