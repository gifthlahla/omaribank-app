class AppStrings {
  AppStrings._();

  static const String appName = 'Omari Bank';
  
  // Auth
  static const String loginTitle = 'Welcome Back';
  static const String loginSubtitle = 'Sign in to manage your digital wallet';
  static const String registerTitle = 'Create Account';
  static const String registerSubtitle = 'Join Omari Bank today';
  static const String emailHelper = 'Enter your email address';
  static const String passwordHelper = 'Enter your password';
  static const String fullNameHelper = 'Enter your full name';
  static const String phoneHelper = 'Enter your phone number (optional)';
  static const String loginButton = 'Sign In';
  static const String registerButton = 'Sign Up';
  static const String noAccount = 'Don\'t have an account? Sign Up';
  static const String haveAccount = 'Already have an account? Sign In';

  // Home/Wallet
  static const String availableBalance = 'Available Balance';
  static const String recentTransactions = 'Recent Transactions';
  static const String sendMoney = 'Send';
  static const String depositMoney = 'Deposit';
  static const String withdrawMoney = 'Withdraw';
  static const String viewAll = 'View All';

  // Transactions
  static const String amount = 'Amount';
  static const String description = 'Description (Optional)';
  static const String sendMoneyTitle = 'Send Money';
  static const String depositTitle = 'Deposit Money';
  static const String withdrawTitle = 'Withdraw Money';
  static const String transactionHistory = 'Transaction History';
  static const String transactionDetails = 'Transaction Details';

  // Dialogs
  static const String confirmTitle = 'Confirm Action';
  static const String confirmTransfer = 'Are you sure you want to send this amount?';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
  static const String success = 'Success';
  static const String error = 'Error';
  static const String ok = 'OK';

  // Profile
  static const String profile = 'Profile';
  static const String settings = 'Settings';
  static const String logout = 'Log Out';
  static const String confirmLogout = 'Are you sure you want to log out?';
  
  // Validation Errors
  static const String requiredField = 'This field is required';
  static const String invalidEmail = 'Please enter a valid email address';
  static const String minPasswordLength = 'Password must be at least 6 characters';
  static const String invalidAmount = 'Please enter a valid amount';
  static const String insufficientFunds = 'Insufficient funds for this transaction';
}
