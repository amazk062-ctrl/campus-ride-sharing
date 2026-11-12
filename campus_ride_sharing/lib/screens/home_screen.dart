import 'package:flutter/material.dart';

import '../routes/app_routes.dart';
import '../services/auth_service.dart';
import '../services/ride_service.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Opens a screen, then refreshes the numbers when we come back.
  Future<void> _open(String route) async {
    await Navigator.pushNamed(context, route);
    if (mounted) setState(() {});
  }

  void _offerRide(AppUser user) {
    if (user.role != 'Driver') {
      showMessage(context, 'Only drivers can offer rides. Change your role in Profile.');
      return;
    }
    _open(AppRoutes.offerRide);
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser!;
    final offeredCount = RideService.offeredBy(user.email).length;
    final bookedCount = RideService.bookingsOf(user.email).length;
    final pendingCount = RideService.requestsFor(user.email)
        .where((booking) => booking.status == 'Pending')
        .length;

    return Scaffold(
      appBar: AppBar(title: const Text('Campus Ride')),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Welcome, ${user.name}',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text('Where are you going today?',
              style: TextStyle(color: AppColors.grey)),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => _offerRide(user),
            icon: const Icon(Icons.add),
            label: const Text('Offer a Ride'),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () => _open(AppRoutes.search),
            icon: const Icon(Icons.search),
            label: const Text('Find a Ride'),
          ),
          const SizedBox(height: 24),
          _SectionCard(
            title: 'My Rides',
            text: '$offeredCount offered, $bookedCount booked',
            onTap: () => _open(AppRoutes.myRides),
          ),
          _SectionCard(
            title: 'Booking Requests',
            text: '$pendingCount pending',
            onTap: () => _open(AppRoutes.bookingRequests),
          ),
        ],
      ),
    );
  }
}

// A small white card with a title, one line of text and an arrow.
class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.text, required this.onTap});

  final String title;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(text),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
