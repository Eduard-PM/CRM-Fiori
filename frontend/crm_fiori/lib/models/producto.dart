class Producto {
  final int id;
  final String nombre;
  final String categoria;
  final String? unidadMedida;
  final double precio;
  final double stock;
  final double stockMinimo;

  Producto({
    required this.id,
    required this.nombre,
    required this.categoria,
    this.unidadMedida,
    required this.precio,
    required this.stock,
    required this.stockMinimo,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      nombre: json['nombre'],
      categoria: json['categoria'] ?? 'Sin categoría',
      unidadMedida: json['unidad_medida'],
      precio: (json['precio_unitario'] as num).toDouble(),
      stock: (json['stock_actual'] as num).toDouble(),
      stockMinimo: (json['stock_minimo'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nombre": nombre,
      "categoria": categoria,
      "unidad_medida": unidadMedida,
      "precio_unitario": precio,
      "stock_actual": stock,
      "stock_minimo": stockMinimo,
    };
  }
}
