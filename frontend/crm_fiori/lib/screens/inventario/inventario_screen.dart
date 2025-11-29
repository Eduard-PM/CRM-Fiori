import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/inventario_provider.dart';
import '../../models/producto.dart';

class InventarioScreen extends StatelessWidget {
  const InventarioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<InventarioProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventario"),
        backgroundColor: Colors.deepPurple,
      ),

      body: prov.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: prov.productos.length,
              itemBuilder: (_, i) {
                final p = prov.productos[i];
                return _productoItem(p);
              },
            ),

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "btnReload",
            backgroundColor: Colors.deepPurple,
            child: const Icon(Icons.refresh),
            onPressed: () => prov.cargarInventario(),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "btnAdd",
            backgroundColor: Colors.green,
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/agregarProducto');
            },
          ),
        ],
      ),
    );
  }

  Widget _productoItem(Producto producto) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                producto.nombre,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text("S/ ${producto.precio}"),
              Text("Stock: ${producto.stock}"),
            ],
          ),
          Text(
            producto.stock < 10 ? "⚠️" : "✓",
            style: TextStyle(
              fontSize: 24,
              color: producto.stock < 10 ? Colors.red : Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
