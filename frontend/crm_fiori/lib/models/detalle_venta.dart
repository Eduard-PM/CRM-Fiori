class DetalleVenta {
  final int id;
  final int productoId;
  final double cantidad;
  final double precioUnitario;

  DetalleVenta({
    required this.id,
    required this.productoId,
    required this.cantidad,
    required this.precioUnitario,
  });

  factory DetalleVenta.fromJson(Map<String, dynamic> json) {
    return DetalleVenta(
      id: json['id'],
      productoId: json['producto_id'],
      cantidad: json['cantidad'].toDouble(),
      precioUnitario: json['precio_unitario'].toDouble(),
    );
  }
}
