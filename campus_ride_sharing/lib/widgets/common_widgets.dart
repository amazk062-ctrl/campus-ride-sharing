import 'package:flutter/material.dart';

import '../routes/app_routes.dart';
import '../services/ride_service.dart';
import '../theme/app_theme.dart';

// Shows a small message at the bottom of the screen.
void showMessage(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

// Simple validators used by the forms. They return null when the value is OK.
String? validateRequired(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'This field is required';
  }
  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Email is required';
  }
  if (!value.contains('@') || !value.contains('.')) {
    return 'Enter a valid email';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password is required';
  }
  if (value.length < 6) {
    return 'Use at least 6 characters';
  }
  return null;
}

String? validateNumber(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'This field is required';
  }
  final number = int.tryParse(value.trim());
  if (number == null || number <= 0) {
    return 'Enter a number greater than 0';
  }
  return null;
}

// A text field with a label and a little space below it.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool readOnly;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        readOnly: readOnly,
        onTap: onTap,
        onChanged: onChanged,
        decoration: InputDecoration(labelText: label, hintText: hint),
      ),
    );
  }
}

// A dropdown with a label and a little space below it.
class AppDropdown extends StatelessWidget {
  const AppDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final List<String> items;
  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(labelText: label),
        validator: (v) => v == null ? 'Please select' : null,
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}

// A white card showing one ride. "extra" can hold a status or buttons.
class RideCard extends StatelessWidget {
  const RideCard({super.key, required this.ride, this.onTap, this.extra});

  final Ride ride;
  final VoidCallback? onTap;
  final Widget? extra;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${ride.pickup} → ${ride.destination}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Driver: ${ride.driverName}'),
              Text('${ride.date} at ${ride.time}'),
              Text('Seats: ${ride.seats}   |   PKR ${ride.contribution} per seat'),
              if (extra != null) ...[
                const SizedBox(height: 8),
                extra!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// Text for a status like Pending / Accepted / Rejected.
class StatusText extends StatelessWidget {
  const StatusText(this.status, {super.key});

  final String status;

  @override
  Widget build(BuildContext context) {
    Color color = AppColors.grey;
    if (status == 'Accepted') color = AppColors.green;
    if (status == 'Rejected') color = AppColors.red;
    return Text(
      'Status: $status',
      style: TextStyle(fontWeight: FontWeight.bold, color: color),
    );
  }
}

// A short message shown when a list is empty.
class EmptyMessage extends StatelessWidget {
  const EmptyMessage(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Text(text, textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.grey)),
      ),
    );
  }
}

// Bottom navigation: Home, Search, My Rides, Profile.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.currentIndex});

  final int currentIndex;

  static const List<String> _routes = [
    AppRoutes.home,
    AppRoutes.search,
    AppRoutes.myRides,
    AppRoutes.profile,
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.navy,
      unselectedItemColor: AppColors.grey,
      onTap: (index) {
        if (index == currentIndex) return;
        Navigator.pushNamedAndRemoveUntil(context, _routes[index], (route) => false);
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.directions_car), label: 'My Rides'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
