import 'auth_service.dart';

// One ride offered by a driver.
class Ride {
  Ride({
    required this.id,
    required this.driverName,
    required this.driverEmail,
    required this.pickup,
    required this.destination,
    required this.date,
    required this.time,
    required this.seats,
    required this.contribution,
    required this.vehicle,
  });

  final String id;
  final String driverName;
  final String driverEmail;
  final String pickup;
  final String destination;
  final String date;
  final String time;
  int seats; // available seats
  final int contribution; // PKR per seat
  final String vehicle;
}

// One seat request made by a passenger.
class Booking {
  Booking({
    required this.id,
    required this.ride,
    required this.passengerName,
    required this.passengerEmail,
    this.status = 'Pending',
  });

  final String id;
  final Ride ride;
  final String passengerName;
  final String passengerEmail;
  String status; // 'Pending', 'Accepted' or 'Rejected'
}

// Handles rides and bookings.
//
// RIGHT NOW: lists in memory with a few sample rides.
//
// FIREBASE (later): replace the lists with Cloud Firestore collections:
//   "rides"    - one document per Ride
//   "bookings" - one document per Booking (store rideId and passengerEmail)
// The methods will become "Future" methods, so add async/await in the screens.
class RideService {
  static int _nextId = 100;

  static final List<Ride> _rides = [
    Ride(
      id: '1',
      driverName: 'Sana Malik',
      driverEmail: 'sana@fast.edu.pk',
      pickup: 'Saddar, Rawalpindi',
      destination: 'NUST H-12, Islamabad',
      date: '12/11/2026',
      time: '7:30 AM',
      seats: 2,
      contribution: 300,
      vehicle: 'Honda City, White',
    ),
    Ride(
      id: '2',
      driverName: 'Hamza Ali',
      driverEmail: 'hamza@fast.edu.pk',
      pickup: 'Chandni Chowk, Rawalpindi',
      destination: 'FAST-NUCES, Islamabad',
      date: '12/11/2026',
      time: '8:00 AM',
      seats: 3,
      contribution: 350,
      vehicle: 'Suzuki Cultus, White',
    ),
    Ride(
      id: '3',
      driverName: 'Bilal Ahmed',
      driverEmail: 'bilal@fast.edu.pk',
      pickup: 'Bahria Town Phase 4',
      destination: 'COMSATS, Islamabad',
      date: '13/11/2026',
      time: '7:45 AM',
      seats: 1,
      contribution: 400,
      vehicle: 'Toyota Corolla, Silver',
    ),
  ];

  static final List<Booking> _bookings = [];

  // Driver posts a new ride.
  static void addRide({
    required String pickup,
    required String destination,
    required String date,
    required String time,
    required int seats,
    required int contribution,
    required String vehicle,
  }) {
    // FIREBASE: add a document to the "rides" collection.
    final user = AuthService.currentUser!;
    _nextId++;
    _rides.add(Ride(
      id: '$_nextId',
      driverName: user.name,
      driverEmail: user.email,
      pickup: pickup.trim(),
      destination: destination.trim(),
      date: date,
      time: time,
      seats: seats,
      contribution: contribution,
      vehicle: vehicle.trim(),
    ));
  }

  // Rides that other drivers offered and that still have seats.
  static List<Ride> searchRides(String pickup, String destination) {
    // FIREBASE: query the "rides" collection (filter the text in the app).
    final myEmail = AuthService.currentUser!.email;
    final p = pickup.trim().toLowerCase();
    final d = destination.trim().toLowerCase();
    return _rides.where((ride) {
      return ride.driverEmail != myEmail &&
          ride.seats > 0 &&
          ride.pickup.toLowerCase().contains(p) &&
          ride.destination.toLowerCase().contains(d);
    }).toList();
  }

  // Rides offered by this driver.
  static List<Ride> offeredBy(String email) {
    return _rides.where((ride) => ride.driverEmail == email).toList();
  }

  // Seat requests made by this passenger.
  static List<Booking> bookingsOf(String passengerEmail) {
    return _bookings.where((b) => b.passengerEmail == passengerEmail).toList();
  }

  // Seat requests received by this driver.
  static List<Booking> requestsFor(String driverEmail) {
    return _bookings.where((b) => b.ride.driverEmail == driverEmail).toList();
  }

  static int requestCountForRide(Ride ride) {
    return _bookings.where((b) => b.ride.id == ride.id).length;
  }

  static bool hasRequested(Ride ride, String passengerEmail) {
    return _bookings
        .any((b) => b.ride.id == ride.id && b.passengerEmail == passengerEmail);
  }

  // Passenger asks for one seat.
  static void requestSeat(Ride ride) {
    // FIREBASE: add a document to the "bookings" collection.
    final user = AuthService.currentUser!;
    _nextId++;
    _bookings.add(Booking(
      id: '$_nextId',
      ride: ride,
      passengerName: user.name,
      passengerEmail: user.email,
    ));
  }

  // Driver accepts or rejects. Returns an error message, or null when done.
  static String? updateBooking(Booking booking, String newStatus) {
    // FIREBASE: update the booking document (and the ride's seats).
    if (newStatus == 'Accepted') {
      if (booking.ride.seats <= 0) {
        return 'No seats left on this ride';
      }
      booking.ride.seats = booking.ride.seats - 1;
    }
    booking.status = newStatus;
    return null;
  }
}
