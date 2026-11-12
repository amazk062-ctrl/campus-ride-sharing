// A student account. The password is NOT part of this class.
class AppUser {
  AppUser({
    required this.name,
    required this.email,
    required this.gender,
    required this.role,
  });

  String name;
  final String email;
  final String gender;
  String role; // 'Driver' or 'Passenger'
}

// Handles register, login, logout and profile updates.
//
// RIGHT NOW: everything is kept in memory (lost when the app closes).
// A demo account exists so you can log in while building the screens:
//   email: ayesha@fast.edu.pk   password: 123456
//
// FIREBASE (later): replace the body of each method with Firebase code.
// The methods will become "Future" methods, so add async/await in the screens.
class AuthService {
  // Local test data only. With Firebase, FirebaseAuth keeps passwords,
  // and you must never save passwords in Firestore.
  static final Map<String, String> _passwords = {
    'ayesha@fast.edu.pk': '123456',
  };

  static final Map<String, AppUser> _users = {
    'ayesha@fast.edu.pk': AppUser(
      name: 'Ayesha Khan',
      email: 'ayesha@fast.edu.pk',
      gender: 'Female',
      role: 'Driver',
    ),
  };

  // The logged-in user (null when logged out).
  static AppUser? currentUser;

  // Returns an error message, or null when registration worked.
  static String? register({
    required String name,
    required String email,
    required String gender,
    required String role,
    required String password,
  }) {
    // FIREBASE: FirebaseAuth.instance.createUserWithEmailAndPassword(email, password)
    // then save name, email, gender and role in Firestore: collection "users",
    // document id = the user's uid.
    final key = email.trim().toLowerCase();
    if (_users.containsKey(key)) {
      return 'This email is already registered';
    }
    final user = AppUser(
      name: name.trim(),
      email: key,
      gender: gender,
      role: role,
    );
    _users[key] = user;
    _passwords[key] = password;
    currentUser = user;
    return null;
  }

  // Returns an error message, or null when login worked.
  static String? login(String email, String password) {
    // FIREBASE: FirebaseAuth.instance.signInWithEmailAndPassword(email, password)
    // then read the user's document from Firestore collection "users".
    final key = email.trim().toLowerCase();
    if (_passwords[key] != password) {
      return 'Wrong email or password';
    }
    currentUser = _users[key];
    return null;
  }

  static void logout() {
    // FIREBASE: FirebaseAuth.instance.signOut()
    currentUser = null;
  }

  static void updateProfile({required String name, required String role}) {
    // FIREBASE: update the user's document in Firestore collection "users".
    currentUser!.name = name.trim();
    currentUser!.role = role;
  }
}
