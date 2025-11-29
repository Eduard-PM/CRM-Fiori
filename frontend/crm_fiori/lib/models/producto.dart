class Producto {
  final int id;
  final String nombre;
  final double precio;
  final double stock;
  final String categoria;

  Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.stock,
    required this.categoria,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      nombre: json['nombre'],
      precio: (json['precio'] as num).toDouble(),
      stock: (json['stock'] as num).toDouble(),
      categoria: json['categoria'] ?? 'Sin categoría',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nombre": nombre,
      "precio": precio,
      "stock": stock,
      "categoria": categoria,
    };
  }
}
