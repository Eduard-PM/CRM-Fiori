import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.microtask(() async {
      final auth = Provider.of<AuthProvider>(context, listen: false);

      final ok = await auth.tryRestoreSession();

      if (!context.mounted) return; // FIX

      Navigator.pushReplacementNamed(context, ok ? '/home' : '/login');
    });

    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
