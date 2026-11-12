import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/ride_service.dart';
import '../widgets/common_widgets.dart';

class RideDetailsScreen extends StatefulWidget {
  const RideDetailsScreen({super.key, required this.ride});

  final Ride ride;

  @override
  State<RideDetailsScreen> createState() => _RideDetailsScreenState();
}

class _RideDetailsScreenState extends State<RideDetailsScreen> {
  void _requestSeat() {
    RideService.requestSeat(widget.ride);
    setState(() {});
    showMessage(context, 'Seat requested. Wait for the driver to reply.');
  }

  @override
  Widget build(BuildContext context) {
    final ride = widget.ride;
    final user = AuthService.currentUser!;
    final alreadyRequested = RideService.hasRequested(ride, user.email);

    return Scaffold(
      appBar: AppBar(title: const Text('Ride Details')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              color: Colors.white,
              surfaceTintColor: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _InfoRow(label: 'Driver', value: ride.driverName),
                    _InfoRow(label: 'Vehicle', value: ride.vehicle),
                    _InfoRow(label: 'Pickup', value: ride.pickup),
                    _InfoRow(label: 'Destination', value: ride.destination),
                    _InfoRow(label: 'Date', value: ride.date),
                    _InfoRow(label: 'Time', value: ride.time),
                    _InfoRow(label: 'Available Seats', value: '${ride.seats}'),
                    _InfoRow(label: 'Contribution', value: 'PKR ${ride.contribution}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: alreadyRequested ? null : _requestSeat,
              child: Text(alreadyRequested ? 'Request Sent' : 'Request Seat'),
            ),
          ],
        ),
      ),
    );
  }
}

// One line of the details card: label on the left, value on the right.
class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: Text(label)),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
