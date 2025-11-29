class ClienteModel {
  final int id;
  final String nombre;
  final String telefono;
  final String direccion;
  final String email;

  ClienteModel({
    required this.id,
    required this.nombre,
    required this.telefono,
    required this.direccion,
    required this.email,
  });

  factory ClienteModel.fromJson(Map<String, dynamic> json) {
    return ClienteModel(
      id: json['id'],
      nombre: json['nombre'] ?? '',
      telefono: json['telefono'] ?? '',
      direccion: json['direccion'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
