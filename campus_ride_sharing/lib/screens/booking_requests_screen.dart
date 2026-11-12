import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/ride_service.dart';
import '../widgets/common_widgets.dart';

class BookingRequestsScreen extends StatefulWidget {
  const BookingRequestsScreen({super.key});

  @override
  State<BookingRequestsScreen> createState() => _BookingRequestsScreenState();
}

class _BookingRequestsScreenState extends State<BookingRequestsScreen> {
  void _update(Booking booking, String status) {
    final error = RideService.updateBooking(booking, status);
    if (error != null) {
      showMessage(context, error);
      return;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser!;
    final requests = RideService.requestsFor(user.email);

    return Scaffold(
      appBar: AppBar(title: const Text('Booking Requests')),
      body: requests.isEmpty
          ? const EmptyMessage('No booking requests yet')
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                return _buildRequestCard(requests[index]);
              },
            ),
    );
  }

  Widget _buildRequestCard(Booking booking) {
    final ride = booking.ride;

    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              booking.passengerName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text('${ride.pickup} → ${ride.destination}'),
            Text('${ride.date} at ${ride.time}'),
            const Text('Seats requested: 1'),
            const SizedBox(height: 8),
            StatusText(booking.status),
            if (booking.status == 'Pending') ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _update(booking, 'Rejected'),
                      child: const Text('Reject'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(minimumSize: const Size(0, 44)),
                      onPressed: () => _update(booking, 'Accepted'),
                      child: const Text('Accept'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
