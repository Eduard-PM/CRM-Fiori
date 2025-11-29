import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/clientes_provider.dart';
import '../../providers/inventario_provider.dart';
import '../../providers/ventas_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    // Cargar datos al entrar al Home
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      final auth = context.read<AuthProvider>();
      final ventasProv = context.read<VentasProvider>();
      final inventarioProv = context.read<InventarioProvider>();
      final clientesProv = context.read<ClientesProvider>();

      await Future.wait([
        ventasProv.cargarVentas(),
        inventarioProv.cargarInventario(),
        if (auth.token != null && auth.token!.isNotEmpty)
          clientesProv.cargarClientes(),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final ventasProv = context.watch<VentasProvider>();
    final clientesProv = context.watch<ClientesProvider>();
    final inventarioProv = context.watch<InventarioProvider>();

    // ====== STATS ======
    final ventasHoy = ventasProv.ventasDelDia.toStringAsFixed(2);
    final transaccionesHoy = ventasProv.numeroTransaccionesDia.toString();
    final totalHistorico = ventasProv.ventas
        .fold<double>(0.0, (sum, v) => sum + v.total)
        .toStringAsFixed(2);

    final totalClientes = clientesProv.clientes.length;

    // Productos con stock bajo (ej: <= 5 unidades)
    final productosStockBajo = inventarioProv.productos
        .where((p) => p.stock <= 5)
        .toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Hola, ${auth.usuario?.nombre ?? ''}"),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthProvider>().logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // ========== FILA 1: ACCESOS RÁPIDOS ==========
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _quickAccess(
                  icon: Icons.inventory,
                  label: "Inventario",
                  onTap: () async {
                    final inv = context.read<InventarioProvider>();
                    await inv.cargarInventario();
                    if (!context.mounted) return;
                    Navigator.pushNamed(context, '/inventario');
                  },
                ),
                _quickAccess(
                  icon: Icons.people,
                  label: "Clientes",
                  onTap: () async {
                    final auth = context.read<AuthProvider>();
                    final clientesProvider = context.read<ClientesProvider>();

                    if (auth.token != null && auth.token!.isNotEmpty) {
                      await clientesProvider.cargarClientes();
                    }

                    if (!context.mounted) return;
                    Navigator.pushNamed(context, '/clientes');
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ========== FILA 2: ACCESOS RÁPIDOS ==========
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _quickAccess(
                  icon: Icons.shopping_cart,
                  label: "Ventas",
                  onTap: () => Navigator.pushNamed(context, '/ventas'),
                ),
                _quickAccess(
                  icon: Icons.receipt_long,
                  label: "Historial",
                  onTap: () => Navigator.pushNamed(context, '/ventasHistory'),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // ========== STATS REALES ==========
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard("S/ $ventasHoy", "Ventas Hoy"),
                _buildStatCard(transaccionesHoy, "Transacciones"),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard(totalClientes.toString(), "Clientes"),
                _buildStatCard(
                  productosStockBajo.length.toString(),
                  "Stock Bajo ⚠️",
                ),
              ],
            ),

            const SizedBox(height: 25),

            const Text(
              "Alertas de Stock",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // ========== ALERTAS DE STOCK REALES ==========
            if (productosStockBajo.isEmpty)
              const Text(
                "No hay productos con stock bajo",
                style: TextStyle(color: Colors.grey),
              )
            else
              Column(
                children: productosStockBajo.map((p) {
                  return _alertItem(p.nombre, "${p.stock}", true);
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // COMPONENTES
  // ============================================================

  Widget _quickAccess({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap, // ✅ GestureTapCallback correcto
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withValues(alpha: 0.2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Colors.deepPurple),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.blue.withValues(alpha: 0.2), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _alertItem(String name, String stock, bool low) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 10),
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
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text("Stock: $stock", style: const TextStyle(fontSize: 12)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
            decoration: BoxDecoration(
              color: low ? Colors.red[100] : Colors.green[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              low ? "BAJO" : "OK",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: low ? Colors.red : Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
