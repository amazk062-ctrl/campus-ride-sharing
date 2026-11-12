import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/ride_service.dart';
import '../widgets/common_widgets.dart';

class MyRidesScreen extends StatelessWidget {
  const MyRidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser!;
    final offered = RideService.offeredBy(user.email);
    final booked = RideService.bookingsOf(user.email);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Rides'),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Offered Rides'),
              Tab(text: 'Booked Rides'),
            ],
          ),
        ),
        bottomNavigationBar: const AppBottomNav(currentIndex: 2),
        body: TabBarView(
          children: [
            // Rides this user offered
            offered.isEmpty
                ? const EmptyMessage('You have not offered any rides')
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: offered.map((ride) {
                      return RideCard(
                        ride: ride,
                        extra: Text('Requests: ${RideService.requestCountForRide(ride)}'),
                      );
                    }).toList(),
                  ),
            // Rides this user asked a seat for
            booked.isEmpty
                ? const EmptyMessage('You have not booked any rides')
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: booked.map((booking) {
                      return RideCard(
                        ride: booking.ride,
                        extra: StatusText(booking.status),
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }
}
