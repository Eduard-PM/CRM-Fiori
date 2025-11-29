import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/ventas_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/venta.dart';
import 'venta_detalle_screen.dart';

class VentasHistoryScreen extends StatefulWidget {
  const VentasHistoryScreen({super.key});

  @override
  State<VentasHistoryScreen> createState() => _VentasHistoryScreenState();
}

class _VentasHistoryScreenState extends State<VentasHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final auth = context.read<AuthProvider>();
      final prov = context.read<VentasProvider>();

      if (auth.token != null && auth.token!.isNotEmpty) {
        await prov.cargarVentas();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<VentasProvider>();
    final List<VentaListItem> ventas = prov.ventas;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Historial de Ventas"),
        backgroundColor: Colors.deepPurple,
      ),
      body: prov.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ventas.isEmpty
          ? const Center(child: Text("No hay ventas"))
          : ListView.builder(
              itemCount: ventas.length,
              itemBuilder: (_, i) {
                final v = ventas[i];
                return ListTile(
                  leading: const Icon(Icons.receipt_long),
                  title: Text("Venta #${v.id}"),
                  subtitle: Text(
                    "${v.fechaVenta.day}/${v.fechaVenta.month}/${v.fechaVenta.year}",
                  ),
                  trailing: Text(
                    "S/ ${v.total.toStringAsFixed(2)}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VentaDetalleScreen(ventaId: v.id),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
