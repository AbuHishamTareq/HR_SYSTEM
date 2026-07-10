// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'نظام الموارد البشرية';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get password => 'كلمة المرور';

  @override
  String get otp => 'التحقق من الرمز';

  @override
  String get verify => 'تحقق';

  @override
  String get resend => 'إعادة إرسال';

  @override
  String get home => 'الرئيسية';

  @override
  String get bookings => 'الحجوزات';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get settings => 'الإعدادات';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get lightMode => 'الوضع الفاتح';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get onboardingTitle1 => 'مرحباً بك في نظام الموارد البشرية';

  @override
  String get onboardingSubtitle1 => 'ابحث عن أفضل خدمات المنزل بنقرات قليلة';

  @override
  String get onboardingTitle2 => 'احجز الخدمات بسهولة';

  @override
  String get onboardingSubtitle2 => 'جدول المواعيد وأدر حجوزاتك بكل سهولة';

  @override
  String get onboardingTitle3 => 'سائقون محترفون';

  @override
  String get onboardingSubtitle3 => 'احصل على سائقين محترفين وموثوقين لاحتياجاتك';

  @override
  String get getStarted => 'ابدأ الآن';

  @override
  String get skip => 'تخطي';

  @override
  String get next => 'التالي';

  @override
  String get welcome => 'مرحباً';

  @override
  String get sendOtp => 'إرسال الرمز';

  @override
  String get enterPhone => 'أدخل رقم هاتفك';

  @override
  String get enterOtp => 'أدخل رمز التحقق';

  @override
  String otpSent(Object phone) {
    return 'تم إرسال الرمز إلى $phone';
  }

  @override
  String resendIn(Object seconds) {
    return 'إعادة الإرسال بعد $secondsث';
  }

  @override
  String get invalidPhone => 'يرجى إدخال رقم هاتف صحيح';

  @override
  String get invalidOtp => 'يرجى إدخال رمز تحقق صحيح';

  @override
  String get noAccount => 'ليس لديك حساب؟';

  @override
  String get contactSupport => 'اتصل بالدعم';

  @override
  String get loading => 'جارٍ التحميل...';

  @override
  String get error => 'خطأ';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';
}
