import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/ventas_provider.dart';

class VentaDetalleScreen extends StatefulWidget {
  final int ventaId;

  const VentaDetalleScreen({super.key, required this.ventaId});

  @override
  State<VentaDetalleScreen> createState() => _VentaDetalleScreenState();
}

class _VentaDetalleScreenState extends State<VentaDetalleScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VentasProvider>().cargarVentaDetalle(widget.ventaId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<VentasProvider>();
    final venta = prov.ventaSeleccionada;

    return Scaffold(
      appBar: AppBar(
        title: Text("Venta #${widget.ventaId}"),
        backgroundColor: Colors.deepPurple,
      ),
      body: prov.isLoading || venta == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Cliente: ${venta.idCliente}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    "Fecha: ${venta.fechaVenta.day}/${venta.fechaVenta.month}/${venta.fechaVenta.year}",
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Detalles:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: venta.detalles.length,
                      itemBuilder: (_, i) {
                        final d = venta.detalles[i];
                        return ListTile(
                          title: Text("Producto ${d.idProducto}"),
                          subtitle: Text("Cantidad: ${d.cantidad}"),
                          trailing: Text(
                            "S/ ${d.subtotal.toStringAsFixed(2)}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        "Total: ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "S/ ${venta.total.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
