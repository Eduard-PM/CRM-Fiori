import 'dart:convert';

/// =============================================================
/// MODELOS PARA CREAR VENTA
/// =============================================================
class VentaItemCreate {
  final int idProducto;
  final int cantidad;

  VentaItemCreate({required this.idProducto, required this.cantidad});

  Map<String, dynamic> toJson() {
    return {'id_producto': idProducto, 'cantidad': cantidad};
  }
}

class VentaCreateRequest {
  final int idCliente;
  final List<VentaItemCreate> items;

  VentaCreateRequest({required this.idCliente, required this.items});

  Map<String, dynamic> toJson() {
    return {
      'id_cliente': idCliente,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }

  String toRawJson() => jsonEncode(toJson());
}

/// =============================================================
/// DETALLE DE VENTA
/// =============================================================
class VentaDetalle {
  final int id;
  final int idProducto;
  final int cantidad;
  final double precioUnitario;
  final double subtotal;

  VentaDetalle({
    required this.id,
    required this.idProducto,
    required this.cantidad,
    required this.precioUnitario,
    required this.subtotal,
  });

  factory VentaDetalle.fromJson(Map<String, dynamic> json) {
    return VentaDetalle(
      id: json['id'] ?? 0,
      idProducto: json['id_producto'] ?? 0,
      cantidad: json['cantidad'] ?? 0,
      precioUnitario: (json['precio_unitario'] as num?)?.toDouble() ?? 0.0,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

/// =============================================================
/// VENTA COMPLETA (VentaOut)
/// =============================================================
class Venta {
  final int id;
  final int idCliente;
  final DateTime fechaVenta;
  final double total;
  final List<VentaDetalle> detalles;

  Venta({
    required this.id,
    required this.idCliente,
    required this.fechaVenta,
    required this.total,
    required this.detalles,
  });

  factory Venta.fromJson(Map<String, dynamic> json) {
    return Venta(
      id: json['id'] ?? 0,
      idCliente: json['id_cliente'] ?? 0,
      fechaVenta:
          DateTime.tryParse(json['fecha_venta'] ?? '') ?? DateTime.now(),
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      detalles: (json['detalles'] as List<dynamic>? ?? [])
          .map((d) => VentaDetalle.fromJson(d))
          .toList(),
    );
  }

  /// Ayuda: cantidad total de items vendidos
  int get cantidadTotalItems => detalles.fold(0, (a, b) => a + b.cantidad);

  /// Ayuda: obtener nombre del primer producto (si se requiere)
  String get primerProducto {
    if (detalles.isEmpty) return "";
    return "Producto ${detalles.first.idProducto}";
  }
}

/// =============================================================
/// LIST ITEM (VentaListOut)
/// =============================================================
class VentaListItem {
  final int id;
  final int idCliente;
  final DateTime fechaVenta;
  final double total;

  VentaListItem({
    required this.id,
    required this.idCliente,
    required this.fechaVenta,
    required this.total,
  });

  factory VentaListItem.fromJson(Map<String, dynamic> json) {
    return VentaListItem(
      id: json['id'] ?? 0,
      idCliente: json['id_cliente'] ?? 0,
      fechaVenta:
          DateTime.tryParse(json['fecha_venta'] ?? '') ?? DateTime.now(),
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

/// =============================================================
/// PARA DASHBOARD: productos más vendidos
/// =============================================================
class TopProductoVenta {
  final int idProducto;
  final int cantidadVendida;

  TopProductoVenta({required this.idProducto, required this.cantidadVendida});
}
