import 'package:flutter/material.dart';
import '../../../core/mock/dummy_data.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            CircleAvatar(radius: 42, child: Text(DummyData.userName.characters.first)),
            const SizedBox(height: 12),
            Text(DummyData.userName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            const Text("Frontend-only UI • UnityHub", style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 18),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text("Settings (UI only)"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text("Privacy (UI only)"),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
