class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  bool _isLoggedIn = false;
  String? _userName;
  String? _userEmail;

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
}
