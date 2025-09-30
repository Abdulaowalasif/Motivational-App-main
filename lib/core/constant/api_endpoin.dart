class ApiEndpoint {
  static const String siteUrl = 'http://';
  static const String privacyPolicyUrl = 'https://example.com/privacy-policy';
  static const String termsOfServiceUrl = 'https://example.com/terms-of-service';
  static const String baseUrl = 'http://103.186.20.115:9001/api';
  // static const String baseUrl = 'http://10.10.7.91:8210/api';

  // User-related endpoints
  static const String login = '$baseUrl/login/';
  static const String register = '$baseUrl/register/';
  static const String verifyOTP = '$baseUrl/verify-otp/';
  static const String resendOTP = '$baseUrl/resend-otp/';
  static const String passwordResetRequest = '$baseUrl/password-reset-request/';
  static const String resetPassword = '$baseUrl/password-reset/';
  static const String changePassword = '$baseUrl/change-password/';
  static const String verifyRestOTP = '$baseUrl/verify-reset-otp/';
  static const String logOut = '$baseUrl/logout/';

  // Profile-related endpoints
  static const String profile = '$baseUrl/profile';
  static const String profileUpdate = '$baseUrl/profile/update/';

  // Product-related endpoints
  static const String products = '$baseUrl/products';
  static const String productDetails = '$baseUrl/products/details';

  // Order-related endpoints
  static const String orders = '$baseUrl/orders';
  static const String orderDetails = '$baseUrl/orders/details';

  // Cart-related endpoints
  static const String cart = '$baseUrl/cart';

  static String motivationProfileSetup = '$baseUrl/motivation/profile/';
  static String motivationProfile = '$baseUrl/motivation/profile/';

  static String motivation = '$baseUrl/motivation/generate/';
  static String motivationHistory = '$baseUrl/motivation/history/';

  // Subscription-related endpoints
  static const String getFreeTrile = '$baseUrl/start-free-trial/';

  static String giveReaction = '$baseUrl/motivation/reactions/create/';

  // Payment-related endpoints
  static String initiatePayment = '$baseUrl/stripe/payment/initiate/';
  static String verifyPayment = '$baseUrl/stripe/payment/confirm/';
  static String checkOut = '$baseUrl/subscriptions/initiate-subscription/';

  // Leaderboard-related endpoints
  static String leaderboard = '$baseUrl/leaderboard/';

  static String userPoints = '$baseUrl/points/';
}