import 'package:flutter/material.dart';

import '../services/ride_service.dart';
import '../widgets/common_widgets.dart';
import 'ride_details_screen.dart';

class SearchRidesScreen extends StatefulWidget {
  const SearchRidesScreen({super.key});

  @override
  State<SearchRidesScreen> createState() => _SearchRidesScreenState();
}

class _SearchRidesScreenState extends State<SearchRidesScreen> {
  final _pickupController = TextEditingController();
  final _destinationController = TextEditingController();

  @override
  void dispose() {
    _pickupController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  Future<void> _openDetails(Ride ride) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RideDetailsScreen(ride: ride)),
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final rides = RideService.searchRides(
      _pickupController.text,
      _destinationController.text,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Find a Ride')),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              children: [
                AppTextField(
                  label: 'Pickup Location',
                  controller: _pickupController,
                  onChanged: (value) => setState(() {}),
                ),
                AppTextField(
                  label: 'Destination',
                  controller: _destinationController,
                  onChanged: (value) => setState(() {}),
                ),
              ],
            ),
          ),
          Expanded(
            child: rides.isEmpty
                ? const EmptyMessage('No rides found')
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: rides.length,
                    itemBuilder: (context, index) {
                      final ride = rides[index];
                      return RideCard(ride: ride, onTap: () => _openDetails(ride));
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
