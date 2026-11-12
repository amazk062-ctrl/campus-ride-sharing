import 'package:flutter/material.dart';

import '../services/ride_service.dart';
import '../widgets/common_widgets.dart';

class OfferRideScreen extends StatefulWidget {
  const OfferRideScreen({super.key});

  @override
  State<OfferRideScreen> createState() => _OfferRideScreenState();
}

class _OfferRideScreenState extends State<OfferRideScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pickupController = TextEditingController();
  final _destinationController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _seatsController = TextEditingController();
  final _contributionController = TextEditingController();
  final _vehicleController = TextEditingController();

  @override
  void dispose() {
    _pickupController.dispose();
    _destinationController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _seatsController.dispose();
    _contributionController.dispose();
    _vehicleController.dispose();
    super.dispose();
  }

  // Opens the date picker and writes the chosen date in the field.
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 90)),
    );
    if (picked != null) {
      _dateController.text = '${picked.day}/${picked.month}/${picked.year}';
    }
  }

  // Opens the time picker and writes the chosen time in the field.
  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 8, minute: 0),
    );
    if (picked != null && mounted) {
      _timeController.text = picked.format(context);
    }
  }

  void _postRide() {
    if (!_formKey.currentState!.validate()) return;

    RideService.addRide(
      pickup: _pickupController.text,
      destination: _destinationController.text,
      date: _dateController.text,
      time: _timeController.text,
      seats: int.parse(_seatsController.text.trim()),
      contribution: int.parse(_contributionController.text.trim()),
      vehicle: _vehicleController.text,
    );
    showMessage(context, 'Ride posted');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Offer a Ride')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                AppTextField(
                  label: 'Pickup Location',
                  controller: _pickupController,
                  validator: validateRequired,
                ),
                AppTextField(
                  label: 'Destination',
                  controller: _destinationController,
                  validator: validateRequired,
                ),
                AppTextField(
                  label: 'Date',
                  controller: _dateController,
                  readOnly: true,
                  onTap: _pickDate,
                  validator: validateRequired,
                ),
                AppTextField(
                  label: 'Time',
                  controller: _timeController,
                  readOnly: true,
                  onTap: _pickTime,
                  validator: validateRequired,
                ),
                AppTextField(
                  label: 'Available Seats',
                  controller: _seatsController,
                  keyboardType: TextInputType.number,
                  validator: validateNumber,
                ),
                AppTextField(
                  label: 'Contribution per Seat (PKR)',
                  controller: _contributionController,
                  keyboardType: TextInputType.number,
                  validator: validateNumber,
                ),
                AppTextField(
                  label: 'Vehicle Details',
                  hint: 'Suzuki Cultus, White',
                  controller: _vehicleController,
                  validator: validateRequired,
                ),
                const SizedBox(height: 8),
                ElevatedButton(onPressed: _postRide, child: const Text('Post Ride')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
