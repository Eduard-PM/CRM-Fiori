import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/clientes_provider.dart';
import '../../providers/auth_provider.dart';

class ClientesScreen extends StatefulWidget {
  const ClientesScreen({super.key});

  @override
  State<ClientesScreen> createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final clientesProvider = Provider.of<ClientesProvider>(
        context,
        listen: false,
      );

      if (auth.token != null) {
        await clientesProvider.cargarClientes();
      }

      if (!mounted) return; // FIX
    });
  }

  @override
  Widget build(BuildContext context) {
    final clientesProvider = Provider.of<ClientesProvider>(context);
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("Clientes")),

      body: clientesProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: clientesProvider.clientes.length,
              itemBuilder: (_, i) {
                final c = clientesProvider.clientes[i];
                return ListTile(
                  title: Text(c.nombre),
                  subtitle: Text(c.telefono),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (auth.token == null) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Debes iniciar sesión")),
            );
            return;
          }

          await clientesProvider.cargarClientes();

          if (!mounted) return; // FIX

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Clientes actualizados")),
          );
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
