import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.directions_car,
                  size: 85,
                  color: Color(0xFF2563EB),
                ),

                const SizedBox(height: 15),

                const Text(
                  'Campus Ride',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2563EB),
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Share your ride, save your money!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),

                const SizedBox(height: 45),

                const Text(
                  'Email Address',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),

                const SizedBox(height: 10),

                TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Enter your university email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                const Text(
                  'Password',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),

                const SizedBox(height: 10),

                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Don't have an account? Register",
                    style: TextStyle(color: Color(0xFF2563EB)),
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
