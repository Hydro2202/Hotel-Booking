import '../models/user_model.dart';

class AuthService {
  static UserModel? _currentUser;

  static bool get isLoggedIn => _currentUser != null;

  static UserModel? get currentUser => _currentUser;

  static Future<void> login(String email, String password) async {
    // Simulate backend login
    _currentUser = UserModel(
      name: "Sample",
      email: email,
      phone: "1234567890",
      address: "123 Main Street",
      profilePicUrl: "assets/profile.jpg",
      paymentInfo: "**** **** **** 1234",
    );
  }

  static Future<void> signUp(String name, String email, String password) async {
    // Simulate backend signup
    _currentUser = UserModel(
      name: name,
      email: email,
      phone: "",
      address: "",
      profilePicUrl: "assets/profile.jpg",
      paymentInfo: "",
    );
  }

  static void logout() {
    _currentUser = null;
  }
}
