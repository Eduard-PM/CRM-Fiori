import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/clientes_provider.dart';
import 'providers/ventas_provider.dart';
import 'providers/inventario_provider.dart';

// Services
import 'services/ventas_service.dart';

// Screens
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/clientes/clientes_screen.dart';
import 'screens/inventario/inventario_screen.dart';
import 'screens/inventario/agregar_producto_screen.dart';
import 'screens/inventario/actualizar_stock_screen.dart';
import 'screens/ventas/registrar_venta_screen.dart';
import 'screens/ventas/ventas_history_screen.dart';
import 'screens/ventas/venta_detalle_screen.dart';

import 'models/producto.dart';

void main() {
  runApp(const CRMFioriApp());
}

class CRMFioriApp extends StatelessWidget {
  const CRMFioriApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Auth primero, para que otros providers puedan leerlo
        ChangeNotifierProvider(create: (_) => AuthProvider()),

        ChangeNotifierProvider(create: (_) => ClientesProvider()),

        // VentasProvider necesita el AuthProvider y el VentasService
        ChangeNotifierProvider(
          create: (ctx) => VentasProvider(
            service: VentasService(),
            authProvider: ctx.read<AuthProvider>(),
          ),
        ),

        ChangeNotifierProvider(create: (_) => InventarioProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CRM Fiori',

        initialRoute: '/login',

        routes: {
          '/login': (_) => const LoginScreen(),
          '/home': (_) => const HomeScreen(),
          '/clientes': (_) => const ClientesScreen(),
          '/inventario': (_) => const InventarioScreen(),
          '/ventas': (_) => const RegistrarVentaScreen(),
          '/ventasHistory': (_) => const VentasHistoryScreen(),
          '/agregarProducto': (_) => AgregarProductoScreen(), // sin const
        },

        // Rutas con argumentos
        onGenerateRoute: (settings) {
          if (settings.name == '/actualizarStock') {
            final producto = settings.arguments as Producto;
            return MaterialPageRoute(
              builder: (_) => ActualizarStockScreen(producto: producto),
            );
          }

          if (settings.name == '/ventaDetalle') {
            final ventaId = settings.arguments as int;
            return MaterialPageRoute(
              builder: (_) => VentaDetalleScreen(ventaId: ventaId),
            );
          }

          return null;
        },
      ),
    );
  }
}
