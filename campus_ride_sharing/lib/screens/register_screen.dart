import 'package:flutter/material.dart';

import '../routes/app_routes.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  String? _gender;
  String? _role;

  bool _hidePassword = true;
  bool _hideConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _register() {
    if (!_formKey.currentState!.validate()) return;

    final gender = _gender;
    final role = _role;

    if (gender == null || role == null) {
      showMessage(context, 'Please select gender and role.');
      return;
    }

    final error = AuthService.register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      gender: gender,
      role: role,
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (error != null) {
      showMessage(context, error);
      return;
    }

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.home,
      (route) => false,
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  InputDecoration _decoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.person_add_alt_1,
                  size: 70,
                  color: AppColors.navy,
                ),

                const SizedBox(height: 15),

                const Text(
                  'Join Campus Ride!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navy,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Create your student account',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.grey),
                ),

                const SizedBox(height: 30),

                // Full Name
                _buildLabel('Full Name'),

                TextFormField(
                  controller: _nameController,
                  validator: validateRequired,
                  decoration: _decoration(
                    hint: 'Enter your full name',
                    icon: Icons.person_outline,
                  ),
                ),

                const SizedBox(height: 18),

                // University Email
                _buildLabel('University Email'),

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: validateEmail,
                  decoration: _decoration(
                    hint: 'Enter your university email',
                    icon: Icons.email_outlined,
                  ),
                ),

                const SizedBox(height: 18),

                // Password
                _buildLabel('Password'),

                TextFormField(
                  controller: _passwordController,
                  obscureText: _hidePassword,
                  validator: validatePassword,
                  decoration: _decoration(
                    hint: 'Create password',
                    icon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _hidePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _hidePassword = !_hidePassword;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // Confirm Password
                _buildLabel('Confirm Password'),

                TextFormField(
                  controller: _confirmController,
                  obscureText: _hideConfirmPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }

                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }

                    return null;
                  },
                  decoration: _decoration(
                    hint: 'Confirm your password',
                    icon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _hideConfirmPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _hideConfirmPassword = !_hideConfirmPassword;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                // Gender
                _buildLabel('Gender'),

                DropdownButtonFormField<String>(
                  value: _gender,
                  isExpanded: true,
                  decoration: _decoration(
                    hint: 'Select your gender',
                    icon: Icons.people_outline,
                  ),
                  items: const ['Female', 'Male'].map((gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select your gender';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _gender = value;
                    });
                  },
                ),

                const SizedBox(height: 22),

                // Role
                _buildLabel('Select Your Role'),

                DropdownButtonFormField<String>(
                  value: _role,
                  isExpanded: true,
                  decoration: _decoration(
                    hint: 'Select your role',
                    icon: Icons.directions_car_outlined,
                  ),
                  items: const ['Passenger', 'Driver'].map((role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select your role';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _role = value;
                    });
                  },
                ),

                const SizedBox(height: 30),

                // Register Button
                SizedBox(
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _register,
                    child: const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Already have an account? Login',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
