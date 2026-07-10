// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'HR System';

  @override
  String get login => 'Login';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get password => 'Password';

  @override
  String get otp => 'OTP Verification';

  @override
  String get verify => 'Verify';

  @override
  String get resend => 'Resend';

  @override
  String get home => 'Home';

  @override
  String get bookings => 'Bookings';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get logout => 'Logout';

  @override
  String get onboardingTitle1 => 'Welcome to HR System';

  @override
  String get onboardingSubtitle1 => 'Find the best home services with just a few taps';

  @override
  String get onboardingTitle2 => 'Book Services Easily';

  @override
  String get onboardingSubtitle2 => 'Schedule appointments and manage your bookings effortlessly';

  @override
  String get onboardingTitle3 => 'Professional Drivers';

  @override
  String get onboardingSubtitle3 => 'Get matched with verified professional drivers for your needs';

  @override
  String get getStarted => 'Get Started';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get welcome => 'Welcome';

  @override
  String get sendOtp => 'Send OTP';

  @override
  String get enterPhone => 'Enter your phone number';

  @override
  String get enterOtp => 'Enter the verification code';

  @override
  String otpSent(Object phone) {
    return 'OTP sent to $phone';
  }

  @override
  String resendIn(Object seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get invalidPhone => 'Please enter a valid phone number';

  @override
  String get invalidOtp => 'Please enter a valid OTP';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get retry => 'Retry';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';
}
