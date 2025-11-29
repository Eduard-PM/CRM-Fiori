import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/inventario_provider.dart';

class AgregarProductoScreen extends StatelessWidget {
  AgregarProductoScreen({super.key});

  final nombreCtrl = TextEditingController();
  final precioCtrl = TextEditingController();
  final stockCtrl = TextEditingController();
  final categoriaCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<InventarioProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Agregar Producto"),
        backgroundColor: Colors.deepPurple,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nombreCtrl,
              decoration: const InputDecoration(labelText: "Nombre"),
            ),

            TextField(
              controller: precioCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Precio"),
            ),

            TextField(
              controller: stockCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Stock inicial"),
            ),

            TextField(
              controller: categoriaCtrl,
              decoration: const InputDecoration(labelText: "Categoría"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),

              onPressed: prov.isLoading
                  ? null
                  : () async {
                      final ok = await prov.crearProducto(
                        nombre: nombreCtrl.text.trim(),
                        precio: double.tryParse(precioCtrl.text) ?? 0,
                        stock: double.tryParse(stockCtrl.text) ?? 0,
                        categoria: categoriaCtrl.text.trim(),
                      );

                      if (!context.mounted) return;

                      if (ok) {
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Error al crear producto"),
                          ),
                        );
                      }
                    },

              child: prov.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Guardar"),
            ),
          ],
        ),
      ),
    );
  }
}
