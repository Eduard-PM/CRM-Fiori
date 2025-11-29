import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/producto.dart';
import '../../models/cliente_model.dart';
import '../../providers/clientes_provider.dart';
import '../../providers/inventario_provider.dart';

class VentasScreen extends StatefulWidget {
  const VentasScreen({super.key});

  @override
  State<VentasScreen> createState() => _VentasScreenState();
}

class _VentasScreenState extends State<VentasScreen> {
  ClienteModel? clienteSeleccionado;
  final List<Map<String, dynamic>> carrito = [];

  @override
  Widget build(BuildContext context) {
    final clientesProv = Provider.of<ClientesProvider>(context);
    final inventarioProv = Provider.of<InventarioProvider>(context);

    final clientes = clientesProv.clientes;
    final productos = inventarioProv.productos;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrar Venta"),
        backgroundColor: Colors.deepPurple,
      ),
      body: clientesProv.isLoading || inventarioProv.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  const Text(
                    "Cliente",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<ClienteModel>(
                    isExpanded: true,
                    hint: const Text("Seleccione un cliente"),
                    value: clienteSeleccionado,
                    items: clientes.map((c) {
                      return DropdownMenuItem(value: c, child: Text(c.nombre));
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        clienteSeleccionado = val;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Productos",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  ...productos.map((producto) => _productoItem(producto)),

                  const SizedBox(height: 25),

                  const Text(
                    "Carrito",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  ...carrito.map((item) => _carritoItem(item)),

                  const SizedBox(height: 20),

                  _totalWidget(),

                  const SizedBox(height: 30),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: carrito.isEmpty || clienteSeleccionado == null
                        ? null
                        : _confirmarVenta,
                    child: const Text(
                      "Registrar Venta",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // ================================
  // PRODUCTO ITEM
  // ================================
  Widget _productoItem(Producto p) {
    return Card(
      child: ListTile(
        title: Text(p.nombre),
        subtitle: Text("S/ ${p.precio} • Stock: ${p.stock}"),
        trailing: IconButton(
          icon: const Icon(Icons.add_shopping_cart),
          onPressed: () => _agregarAlCarrito(p),
        ),
      ),
    );
  }

  // ================================
  // AGREGAR AL CARRITO
  // ================================
  void _agregarAlCarrito(Producto p) {
    final itemExistente = carrito.indexWhere((i) => i['id'] == p.id);

    if (itemExistente >= 0) {
      setState(() {
        carrito[itemExistente]['cantidad'] += 1;
      });
    } else {
      setState(() {
        carrito.add({
          'id': p.id,
          'nombre': p.nombre,
          'precio': p.precio,
          'cantidad': 1,
        });
      });
    }
  }

  // ================================
  // ITEM DEL CARRITO
  // ================================
  Widget _carritoItem(Map<String, dynamic> item) {
    return Card(
      child: ListTile(
        title: Text(item['nombre']),
        subtitle: Text(
          "Cantidad: ${item['cantidad']} • S/ ${(item['cantidad'] * item['precio']).toStringAsFixed(2)}",
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            setState(() {
              carrito.remove(item);
            });
          },
        ),
      ),
    );
  }

  // ================================
  // TOTAL
  // ================================
  Widget _totalWidget() {
    double total = 0;
    for (var item in carrito) {
      total += item['cantidad'] * item['precio'];
    }

    return Text(
      "Total: S/ ${total.toStringAsFixed(2)}",
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      textAlign: TextAlign.right,
    );
  }

  // ================================
  // CONFIRMAR VENTA (MOCK)
  // ================================
  void _confirmarVenta() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Venta Registrada"),
        content: const Text("La venta se registró correctamente."),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              setState(() {
                carrito.clear();
                clienteSeleccionado = null;
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
