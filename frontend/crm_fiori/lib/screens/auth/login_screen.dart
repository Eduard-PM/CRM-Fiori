import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "CRM Fiori",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),

              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              TextField(
                controller: passCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Contraseña"),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: auth.isLoading
                    ? null
                    : () async {
                        final ok = await auth.login(
                          emailCtrl.text.trim(),
                          passCtrl.text.trim(),
                        );

                        if (!mounted) return; // FIX

                        if (ok) {
                          Navigator.pushReplacementNamed(context, '/home');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Credenciales incorrectas"),
                            ),
                          );
                        }
                      },
                child: auth.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Ingresar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
