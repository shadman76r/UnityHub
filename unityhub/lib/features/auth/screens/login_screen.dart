import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/primary_button.dart';
import 'register_screen.dart';
import '../../../shell/home_shell.dart';

class LoginScreen extends StatefulWidget {
  static const route = "/login";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final pass = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            const SizedBox(height: 30),
            Text(AppStrings.appName, style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            const Text(AppStrings.tagline, style: TextStyle(color: AppColors.textMuted)),
            const SizedBox(height: 30),

            _Input(label: "Email", controller: email, icon: Icons.email_outlined),
            const SizedBox(height: 12),
            _Input(label: "Password", controller: pass, icon: Icons.lock_outline, obscure: true),
            const SizedBox(height: 18),

            PrimaryButton(
              text: "Login",
              onPressed: () {
                // UI only: go to app shell
                Navigator.pushReplacementNamed(context, HomeShell.route);
              },
            ),
            const SizedBox(height: 10),

            TextButton(
              onPressed: () => Navigator.pushNamed(context, RegisterScreen.route),
              child: const Text("Create a new account"),
            ),
          ],
        ),
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
