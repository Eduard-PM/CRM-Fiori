import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/clientes_provider.dart';
import '../../providers/inventario_provider.dart';
import '../../providers/ventas_provider.dart';

import '../../models/cliente_model.dart';
import '../../models/producto.dart';
import '../../models/venta.dart';

class RegistrarVentaScreen extends StatefulWidget {
  const RegistrarVentaScreen({super.key});

  @override
  State<RegistrarVentaScreen> createState() => _RegistrarVentaScreenState();
}

class _RegistrarVentaScreenState extends State<RegistrarVentaScreen> {
  ClienteModel? _cliente;

  /// Lista dinámica: cada ítem tiene producto + cantidad
  final List<Map<String, dynamic>> _items = [];

  void _agregarItem(Producto p) {
    setState(() {
      _items.add({"producto": p, "cantidad": 1});
    });
  }

  void _eliminarItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  double get total {
    double sum = 0.0;
    for (var item in _items) {
      final Producto p = item["producto"];
      final int cant = item["cantidad"];
      sum += p.precio * cant;
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final clientesProv = context.watch<ClientesProvider>();
    final inventarioProv = context.watch<InventarioProvider>();
    final ventasProv = context.watch<VentasProvider>();

    final clientes = clientesProv.clientes;
    final productos = inventarioProv.productos;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrar Venta"),
        backgroundColor: Colors.deepPurple,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
        onPressed: () {
          _mostrarSelectorProductos(context, productos);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // =================== CLIENTE ===================
            const Text(
              "Cliente",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<ClienteModel>(
              value: _cliente,
              items: clientes.map((c) {
                return DropdownMenuItem(value: c, child: Text(c.nombre));
              }).toList(),
              decoration: const InputDecoration(border: OutlineInputBorder()),
              onChanged: (c) => setState(() => _cliente = c),
            ),

            const SizedBox(height: 20),

            const Text(
              "Productos",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            if (_items.isEmpty)
              const Text(
                "Agrega productos con el botón +",
                style: TextStyle(color: Colors.grey),
              )
            else
              Column(
                children: _items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;

                  final Producto p = item["producto"];
                  final int cant = item["cantidad"];

                  return Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.15),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${p.nombre} (S/ ${p.precio})"),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: cant > 1
                                  ? () {
                                      setState(() => item["cantidad"]--);
                                    }
                                  : null,
                            ),
                            Text(
                              cant.toString(),
                              style: const TextStyle(fontSize: 16),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() => item["cantidad"]++);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _eliminarItem(index),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

            const Divider(height: 40),

            ListTile(
              tileColor: Colors.grey[100],
              title: const Text("TOTAL"),
              subtitle: Text("S/ ${total.toStringAsFixed(2)}"),
            ),

            const SizedBox(height: 25),

            ElevatedButton.icon(
              icon: ventasProv.isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save),
              label: const Text("Registrar Venta"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: ventasProv.isSaving
                  ? null
                  : () async {
                      if (_cliente == null || _items.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Selecciona cliente y agrega productos",
                            ),
                          ),
                        );
                        return;
                      }

                      final req = VentaCreateRequest(
                        idCliente: _cliente!.id,
                        items: _items
                            .map(
                              (item) => VentaItemCreate(
                                idProducto: item["producto"].id,
                                cantidad: item["cantidad"],
                              ),
                            )
                            .toList(),
                      );

                      final venta = await ventasProv.registrarVenta(req);

                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Venta registrada con éxito"),
                        ),
                      );

                      Navigator.pop(context);
                    },
            ),
          ],
        ),
      ),
    );
  }

  // SELECCIONAR PRODUCTO EN DIÁLOGO
  void _mostrarSelectorProductos(
    BuildContext context,
    List<Producto> productos,
  ) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Seleccionar producto"),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView(
              children: productos.map((p) {
                return ListTile(
                  title: Text(p.nombre),
                  subtitle: Text("S/ ${p.precio}"),
                  onTap: () {
                    Navigator.pop(context);
                    _agregarItem(p);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
