import 'package:flutter/material.dart';

import '../screens/booking_requests_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/my_rides_screen.dart';
import '../screens/offer_ride_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/register_screen.dart';
import '../screens/search_rides_screen.dart';
import '../screens/splash_screen.dart';

// Route names and the screen for each name.
// Ride Details is not listed here because it needs a Ride.
// It is opened with MaterialPageRoute from the ride lists.
class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String offerRide = '/offer-ride';
  static const String search = '/search';
  static const String bookingRequests = '/booking-requests';
  static const String myRides = '/my-rides';
  static const String profile = '/profile';

  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      home: (context) => const HomeScreen(),
      offerRide: (context) => const OfferRideScreen(),
      search: (context) => const SearchRidesScreen(),
      bookingRequests: (context) => const BookingRequestsScreen(),
      myRides: (context) => const MyRidesScreen(),
      profile: (context) => const ProfileScreen(),
    };
  }
}
