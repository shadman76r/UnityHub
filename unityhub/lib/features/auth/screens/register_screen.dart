import 'package:flutter/material.dart';
import '../../../shared/widgets/primary_button.dart';

class RegisterScreen extends StatefulWidget {
  static const route = "/register";
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final name = TextEditingController();
  final email = TextEditingController();
  final pass = TextEditingController();

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create account")),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          _Input(label: "Full name", controller: name, icon: Icons.person_outline),
          const SizedBox(height: 12),
          _Input(label: "Email", controller: email, icon: Icons.email_outlined),
          const SizedBox(height: 12),
          _Input(label: "Password", controller: pass, icon: Icons.lock_outline, obscure: true),
          const SizedBox(height: 18),
          PrimaryButton(
            text: "Register",
            onPressed: () => Navigator.pop(context), // UI only
          ),
        ],
      ),
    );
  }
}

class _Input extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final bool obscure;

  const _Input({
    required this.label,
    required this.controller,
    required this.icon,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      ),
    );
  }
}
