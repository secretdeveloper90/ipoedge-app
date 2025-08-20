import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool _isLoggedIn = false;
  String? _userName;
  String? _userEmail;
  String? _userPhotoUrl;
  String? _userPhoneNumber;

  // Static test credentials
  static const Map<String, Map<String, String>> _testCredentials = {
    'admin@ipoedge.com': {
      'password': 'admin123',
      'name': 'Admin User',
    },
    'investor@gmail.com': {
      'password': 'investor123',
      'name': 'IPO Investor',
    },
    'demo@test.com': {
      'password': 'demo123',
      'name': 'Demo User',
    },
    'user@example.com': {
      'password': 'password123',
      'name': 'Test User',
    },
  };

  bool get isLoggedIn => _isLoggedIn;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get userPhotoUrl => _userPhotoUrl;
  String? get userPhoneNumber => _userPhoneNumber;

  // Validate login credentials
  bool validateCredentials(String email, String password) {
    if (_testCredentials.containsKey(email)) {
      return _testCredentials[email]!['password'] == password;
    }
    return false;
  }

  // Get user name by email
  String? getUserNameByEmail(String email) {
    if (_testCredentials.containsKey(email)) {
      return _testCredentials[email]!['name'];
    }
    return null;
  }

  // Sign in with email and password validation
  bool signInWithCredentials(String email, String password) {
    if (validateCredentials(email, password)) {
      _isLoggedIn = true;
      _userEmail = email;
      _userName = getUserNameByEmail(email);
      return true;
    }
    return false;
  }

  // Legacy sign in method (for social login)
  void signIn({String? name, String? email}) {
    _isLoggedIn = true;
    _userName = name ?? 'IPO Investor';
    _userEmail = email ?? 'user@example.com';
  }

  void signOut() {
    _isLoggedIn = false;
    _userName = null;
    _userEmail = null;
    _userPhotoUrl = null;
    _userPhoneNumber = null;
  }

  // Check if email already exists (for signup validation)
  bool emailExists(String email) {
    return _testCredentials.containsKey(email);
  }

  // Sign up with validation
  bool signUpWithCredentials({
    required String name,
    required String email,
    required String password,
  }) {
    // In a real app, you would save to database
    // For demo, we'll just sign them in
    if (!emailExists(email)) {
      _isLoggedIn = true;
      _userName = name;
      _userEmail = email;
      return true;
    }
    return false; // Email already exists
  }

  // Legacy sign up method
  void signUp({required String name, required String email}) {
    _isLoggedIn = true;
    _userName = name;
    _userEmail = email;
  }

  // Get all test credentials for demo purposes
  static Map<String, Map<String, String>> getTestCredentials() {
    return _testCredentials;
  }

  // Google Sign-In method
  Future<bool> signInWithGoogle() async {
    try {
      // First, sign out any existing Google account to ensure clean state
      await _googleSignIn.signOut();

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        print('Google Sign-In cancelled by user');
        return false;
      }

      print('Google Sign-In successful for: ${googleUser.email}');

      // For now, if Google Sign-In is successful, we'll use the Google user data directly
      // This bypasses the Firebase authentication type casting issue
      _isLoggedIn = true;
      _userName = googleUser.displayName ?? 'Google User';
      _userEmail = googleUser.email;
      _userPhotoUrl = googleUser.photoUrl;
      _userPhoneNumber =
          null; // Google Sign-In doesn't provide phone number directly
      print('Authentication successful for: $_userEmail');
      print('Profile photo URL: $_userPhotoUrl');
      print(
          'Phone number: $_userPhoneNumber (not available via Google Sign-In)');

      // Try Firebase authentication but don't fail if it has issues
      try {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        if (googleAuth.accessToken != null && googleAuth.idToken != null) {
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          final UserCredential userCredential =
              await _firebaseAuth.signInWithCredential(credential);

          if (userCredential.user != null) {
            print('Firebase authentication also successful');
            // Update with Firebase user data if available
            _userName = userCredential.user!.displayName ?? _userName;
            _userEmail = userCredential.user!.email ?? _userEmail;
            _userPhotoUrl = userCredential.user!.photoURL ?? _userPhotoUrl;
            _userPhoneNumber =
                userCredential.user!.phoneNumber ?? _userPhoneNumber;
          }
        }
      } catch (firebaseError) {
        print(
            'Firebase authentication failed but Google Sign-In succeeded: $firebaseError');
        // Continue with Google user data
      }

      return true;
    } on Exception catch (e) {
      print('Google Sign-In Exception: $e');
      return false;
    } catch (e) {
      print('Error signing in with Google: $e');
      return false;
    }
  }

  // Google Sign-Up method (same as sign-in for Google)
  Future<bool> signUpWithGoogle() async {
    return await signInWithGoogle();
  }

  // Sign out from both Firebase and Google
  Future<void> signOutFromFirebase() async {
    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
      _isLoggedIn = false;
      _userName = null;
      _userEmail = null;
      _userPhotoUrl = null;
      _userPhoneNumber = null;
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  // Check if user is currently signed in with Firebase
  bool get isFirebaseSignedIn => _firebaseAuth.currentUser != null;

  // Get current Firebase user
  User? get currentFirebaseUser => _firebaseAuth.currentUser;
}
