import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/inventario_provider.dart';
import '../../models/producto.dart';

class ActualizarStockScreen extends StatelessWidget {
  final Producto producto;

  ActualizarStockScreen({super.key, required this.producto});

  final stockCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    stockCtrl.text = producto.stock.toString();

    final prov = Provider.of<InventarioProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Stock de ${producto.nombre}")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Stock actual: ${producto.stock}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: stockCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Nuevo stock"),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                final nuevo = double.tryParse(stockCtrl.text) ?? 0;

                final ok = await prov.actualizarStock(producto.id, nuevo);

                if (!context.mounted) return;

                if (ok) {
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Error al actualizar stock")),
                  );
                }
              },
              child: const Text("Guardar cambios"),
            ),
          ],
        ),
      ),
    );
  }
}
