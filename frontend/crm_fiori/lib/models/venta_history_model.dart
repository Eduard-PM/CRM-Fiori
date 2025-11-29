class VentaHistoryModel {
  final int id;
  final String cliente;
  final double total;
  final String fecha;

  VentaHistoryModel({
    required this.id,
    required this.cliente,
    required this.total,
    required this.fecha,
  });

  factory VentaHistoryModel.fromJson(Map<String, dynamic> json) {
    return VentaHistoryModel(
      id: json['id'],
      cliente: json['cliente'],
      total: json['total'].toDouble(),
      fecha: json['fecha'],
    );
  }
}
