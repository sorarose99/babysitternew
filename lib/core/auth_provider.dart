import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  String? _userRole;
  String? get userRole => _userRole;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthProvider() {
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isAuthenticated') ?? false;
    String? savedRole = prefs.getString('userRole');

    if (isLoggedIn) {
      _isAuthenticated = true;
      _userRole = savedRole;
    } else {
      _isAuthenticated = false;
    }

    // Listen to Firebase auth state changes to sync the provider state
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        logout(); // If no user is found, logout the user.
      }
    });

    notifyListeners();
  }

  Future<void> login(String role) async {
    _isAuthenticated = true;
    _userRole = role;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', true);
    await prefs.setString('userRole', role);

    notifyListeners();
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    _userRole = null;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    await _auth.signOut();
    notifyListeners();
  }
}
