import 'package:flutter/material.dart';

import '../routes/app_routes.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late String _role;

  @override
  void initState() {
    super.initState();
    final user = AuthService.currentUser!;
    _nameController = TextEditingController(text: user.name);
    _role = user.role;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    AuthService.updateProfile(name: _nameController.text, role: _role);
    showMessage(context, 'Profile updated');
  }

  void _logout() {
    AuthService.logout();
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser!;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.navy,
                child: Icon(Icons.person, size: 40, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(user.email, style: const TextStyle(color: AppColors.grey)),
              Text('Gender: ${user.gender}',
                  style: const TextStyle(color: AppColors.grey)),
              const SizedBox(height: 24),
              AppTextField(
                label: 'Full Name',
                controller: _nameController,
                validator: validateRequired,
              ),
              AppDropdown(
                label: 'Role',
                items: const ['Driver', 'Passenger'],
                value: _role,
                onChanged: (value) => setState(() => _role = value!),
              ),
              const SizedBox(height: 8),
              ElevatedButton(onPressed: _save, child: const Text('Save Changes')),
              const SizedBox(height: 12),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  foregroundColor: AppColors.navy,
                ),
                onPressed: _logout,
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
