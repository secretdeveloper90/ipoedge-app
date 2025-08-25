import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'demat_account_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoggedIn = false;
  String? _userName;
  String? _userEmail;
  String? _userPhotoUrl;
  String? _userPhoneNumber;

  bool get isLoggedIn => _isLoggedIn;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get userPhotoUrl => _userPhotoUrl;
  String? get userPhoneNumber => _userPhoneNumber;

  // Store user data in Firestore
  Future<void> _storeUserDataInFirestore({
    required String uid,
    required String name,
    required String email,
    required String mobile,
    String? photoUrl,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'name': name,
        'email': email,
        'mobile': mobile,
        'photoUrl': photoUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Error storing user data
    }
  }

  // Get user data from Firestore
  Future<Map<String, dynamic>?> _getUserDataFromFirestore(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data();
      }
    } catch (e) {}
    return null;
  }

  // Initialize authentication service and restore state from Firebase
  Future<void> initialize() async {
    // Firebase Auth persistence is enabled by default on mobile platforms

    // Check current Firebase auth state
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      // User is authenticated in Firebase - restore state
      _isLoggedIn = true;
      _userEmail = currentUser.email;
      _userName = currentUser.displayName; // Get name directly from Firebase
      _userPhotoUrl =
          currentUser.photoURL ?? _generateAvatarUrl(currentUser.email ?? '');

      // Get mobile number from Firestore
      final userData = await _getUserDataFromFirestore(currentUser.uid);
      _userPhoneNumber = userData?['mobile'] ?? currentUser.phoneNumber;
    } else {
      // No authenticated user
      _isLoggedIn = false;
      _userName = null;
      _userEmail = null;
      _userPhotoUrl = null;
      _userPhoneNumber = null;
    }

    // Listen to auth state changes for automatic persistence
    _firebaseAuth.authStateChanges().listen((User? user) async {
      if (user != null) {
        // User signed in
        _isLoggedIn = true;
        _userEmail = user.email;
        _userName = user.displayName; // Get name directly from Firebase
        _userPhotoUrl = user.photoURL ?? _generateAvatarUrl(user.email ?? '');

        // Get mobile number from Firestore (important for persistence)
        final userData = await _getUserDataFromFirestore(user.uid);
        _userPhoneNumber = userData?['mobile'] ?? user.phoneNumber;

        // Initialize demat account service for Firebase data
        DematAccountService.instance;
      } else {
        // User signed out
        _isLoggedIn = false;
        _userName = null;
        _userEmail = null;
        _userPhotoUrl = null;
        _userPhoneNumber = null;
      }
    });
  }

  // Generate avatar URL based on user name
  String _generateAvatarUrl(String name) {
    // Using UI Avatars service to generate avatar based on initials
    if (name.isEmpty) {
      return 'https://ui-avatars.com/api/?name=U&size=200&background=4F46E5&color=ffffff&bold=true&format=png';
    }

    List<String> nameParts = name.split(' ');
    String initials;

    if (nameParts.length >= 2) {
      // Use first letter of first and last name
      initials = '${nameParts[0][0]}${nameParts[nameParts.length - 1][0]}';
    } else if (name.isNotEmpty) {
      // Use first letter only
      initials = name[0];
    } else {
      initials = 'U';
    }

    // Generate a nice avatar with initials - using name parameter for better rendering
    return 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(initials)}&size=200&background=4F46E5&color=ffffff&bold=true&format=png';
  }

  // Sign in with email and password using Firebase
  Future<bool> signInWithCredentials(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        _isLoggedIn = true;
        _userEmail = userCredential.user!.email;

        // Use display name from Firebase (should be set during signup)
        _userName = userCredential.user!.displayName ?? 'User';

        // Use profile photo if available, otherwise generate avatar
        _userPhotoUrl = userCredential.user!.photoURL?.isNotEmpty == true
            ? userCredential.user!.photoURL!
            : _generateAvatarUrl(_userName!);

        // Get mobile number from Firestore
        final userData =
            await _getUserDataFromFirestore(userCredential.user!.uid);
        _userPhoneNumber =
            userData?['mobile'] ?? userCredential.user!.phoneNumber;

        // Initialize demat account service for Firebase data
        DematAccountService.instance;

        return true;
      }
    } catch (e) {
      // Handle the specific type casting error - user is actually authenticated
      if (e.toString().contains('List<Object?>') &&
          e.toString().contains('PigeonUserDetails')) {
        // Check if user is actually signed in despite the error
        final currentUser = _firebaseAuth.currentUser;
        if (currentUser != null && currentUser.email == email) {
          _isLoggedIn = true;
          _userEmail = currentUser.email;

          // Use display name from Firebase (should be set during signup)
          _userName = currentUser.displayName ?? 'User';

          // Use profile photo if available, otherwise generate avatar
          _userPhotoUrl = currentUser.photoURL?.isNotEmpty == true
              ? currentUser.photoURL!
              : _generateAvatarUrl(_userName!);

          // Get mobile number from Firestore
          final userData = await _getUserDataFromFirestore(currentUser.uid);
          _userPhoneNumber = userData?['mobile'] ?? currentUser.phoneNumber;

          return true;
        }
      }
    }
    return false;
  }

  // Legacy sign in method (for social login)
  void signIn({String? name, String? email}) {
    _isLoggedIn = true;
    _userName = name ?? 'IPO Investor';
    _userEmail = email ?? 'user@example.com';
  }

  // Sign out from all services
  Future<void> signOut() async {
    // Clear local state first to ensure UI updates immediately
    _isLoggedIn = false;
    _userName = null;
    _userEmail = null;
    _userPhotoUrl = null;
    _userPhoneNumber = null;

    try {
      // Sign out from Firebase Auth with timeout
      await _firebaseAuth.signOut().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          return;
        },
      );
    } catch (e) {}

    try {
      // Sign out from Google Sign-In with timeout
      await _googleSignIn.signOut().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          return null;
        },
      );
    } catch (e) {}
  }

  // Sign up with Firebase authentication
  Future<bool> signUpWithCredentials({
    required String name,
    required String email,
    required String password,
    required String mobile,
  }) async {
    try {
      // Create user with Firebase
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        try {
          // Try to update the user's display name
          await userCredential.user!.updateDisplayName(name);
        } catch (updateError) {
          // Continue with signup even if display name update fails
        }

        _isLoggedIn = true;
        _userName = name;
        _userEmail = email;

        // Generate avatar for new user
        _userPhotoUrl = _generateAvatarUrl(name);
        _userPhoneNumber = mobile; // Store the provided mobile number

        // Store user data in Firestore
        await _storeUserDataInFirestore(
          uid: userCredential.user!.uid,
          name: name,
          email: email,
          mobile: mobile,
          photoUrl: _userPhotoUrl,
        );

        return true;
      }
    } catch (e) {
      // Handle the specific type casting error - user might be created despite error
      if (e.toString().contains('List<Object?>') &&
          (e.toString().contains('PigeonUserDetails') ||
              e.toString().contains('PigeonUserInfo'))) {
        // Check if user was actually created despite the error
        final currentUser = _firebaseAuth.currentUser;
        if (currentUser != null && currentUser.email == email) {
          try {
            // Try to update display name if needed
            if (currentUser.displayName == null ||
                currentUser.displayName!.isEmpty) {
              await currentUser.updateDisplayName(name);
            }
          } catch (updateError) {
            // Continue anyway - the account was created successfully
          }

          _isLoggedIn = true;
          _userName = name;
          _userEmail = email;

          // Generate avatar for new user
          _userPhotoUrl = _generateAvatarUrl(name);
          _userPhoneNumber = mobile; // Store the provided mobile number

          // Store user data in Firestore
          await _storeUserDataInFirestore(
            uid: currentUser.uid,
            name: name,
            email: email,
            mobile: mobile,
            photoUrl: _userPhotoUrl,
          );
          return true;
        }
      }
    }
    return false;
  }

  // Legacy sign up method
  void signUp({required String name, required String email}) {
    _isLoggedIn = true;
    _userName = name;
    _userEmail = email;
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
        return false;
      }

      // For now, if Google Sign-In is successful, we'll use the Google user data directly
      // This bypasses the Firebase authentication type casting issue
      _isLoggedIn = true;
      _userName = googleUser.displayName ?? 'Google User';
      _userEmail = googleUser.email;
      _userPhotoUrl = googleUser.photoUrl;
      _userPhoneNumber =
          null; // Google Sign-In doesn't provide phone number directly

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
            // Update with Firebase user data if available
            _userName = userCredential.user!.displayName ?? _userName;
            _userEmail = userCredential.user!.email ?? _userEmail;
            _userPhotoUrl = userCredential.user!.photoURL ?? _userPhotoUrl;
            _userPhoneNumber =
                userCredential.user!.phoneNumber ?? _userPhoneNumber;
          }
        }
      } catch (firebaseError) {
        // Continue with Google user data
      }

      // Initialize demat account service for Firebase data
      DematAccountService.instance;

      return true;
    } on Exception catch (e) {
      return false;
    } catch (e) {
      return false;
    }
  }

  // Google Sign-Up method (same as sign-in for Google)
  Future<bool> signUpWithGoogle() async {
    return await signInWithGoogle();
  }

  // Check if user is currently signed in with Firebase
  bool get isFirebaseSignedIn => _firebaseAuth.currentUser != null;

  // Get current Firebase user
  User? get currentFirebaseUser => _firebaseAuth.currentUser;

  // Get Firebase Auth instance for listening to auth state changes
  FirebaseAuth get firebaseAuth => _firebaseAuth;

  // Check if user is already authenticated when app starts
  Future<bool> checkAuthState() async {
    try {
      final User? user = _firebaseAuth.currentUser;
      if (user != null) {
        _isLoggedIn = true;
        _userEmail = user.email;
        _userName = user.displayName ?? 'User';
        _userPhotoUrl = user.photoURL;

        // Get mobile number from Firestore
        final userData = await _getUserDataFromFirestore(user.uid);
        _userPhoneNumber = userData?['mobile'] ?? user.phoneNumber;

        return true;
      }
    } catch (e) {}
    return false;
  }
}
