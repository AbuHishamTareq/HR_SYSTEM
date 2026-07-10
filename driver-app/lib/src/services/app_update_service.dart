import 'dart:io' show Platform;

import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Response from the app-version API endpoint for a single app type.
class AppVersionResponse {
  final String minVersion;
  final String latestVersion;
  final String playStoreUrl;
  final String appStoreUrl;

  const AppVersionResponse({
    required this.minVersion,
    required this.latestVersion,
    required this.playStoreUrl,
    required this.appStoreUrl,
  });

  factory AppVersionResponse.fromJson(Map<String, dynamic> json) {
    return AppVersionResponse(
      minVersion: json['min_version'] as String? ?? '1.0.0',
      latestVersion: json['latest_version'] as String? ?? '1.0.0',
      playStoreUrl: json['play_store_url'] as String? ?? '',
      appStoreUrl: json['app_store_url'] as String? ?? '',
    );
  }

  /// Returns the correct store URL for the current platform.
  String get platformStoreUrl {
    if (Platform.isAndroid) return playStoreUrl;
    if (Platform.isIOS && appStoreUrl.isNotEmpty) return appStoreUrl;
    // Fallback to Play Store URL
    return playStoreUrl;
  }
}

/// Result of a version check.
enum UpdateStatus {
  /// App is up to date.
  upToDate,

  /// An update is available but optional.
  optionalUpdate,

  /// A minimum version upgrade is required.
  forceUpdate,
}

/// Result returned by [AppUpdateService.checkForUpdate].
class UpdateCheckResult {
  final UpdateStatus status;
  final AppVersionResponse versionInfo;

  const UpdateCheckResult({
    required this.status,
    required this.versionInfo,
  });
}

/// Service that checks the installed app version against the backend's
/// minimum and latest version requirements.
class AppUpdateService {
  final Dio _dio;

  AppUpdateService(this._dio);

  /// Fetches version info from the backend and compares it with the installed
  /// version. Returns [UpdateCheckResult] describing what to do.
  ///
  /// Throws on network errors — callers should handle gracefully.
  Future<UpdateCheckResult> checkForUpdate() async {
    // Get installed version
    final packageInfo = await PackageInfo.fromPlatform();
    final installedVersion = packageInfo.version;

    // Fetch latest versions from backend
    final response = await _dio.get('/app-version');

    final data = response.data['data'] as Map<String, dynamic>;

    // Determine which app type we are — use a compile-time constant
    // or fallback to checking the package name
    final isCustomer = packageInfo.packageName.contains('customer');
    final appKey = isCustomer ? 'customer_app' : 'driver_app';

    final appData = data[appKey] as Map<String, dynamic>;
    final versionInfo = AppVersionResponse.fromJson(appData);

    // Compare versions using semantic version comparison
    final installed = _parseVersion(installedVersion);
    final min = _parseVersion(versionInfo.minVersion);
    final latest = _parseVersion(versionInfo.latestVersion);

    if (installed < min) {
      return UpdateCheckResult(
        status: UpdateStatus.forceUpdate,
        versionInfo: versionInfo,
      );
    }

    if (installed < latest) {
      return UpdateCheckResult(
        status: UpdateStatus.optionalUpdate,
        versionInfo: versionInfo,
      );
    }

    return UpdateCheckResult(
      status: UpdateStatus.upToDate,
      versionInfo: versionInfo,
    );
  }

  /// Parse a "x.y.z" version string into a comparable integer.
  /// Assumes each segment is 0–999.
  int _parseVersion(String version) {
    final parts = version.split('.');
    final major = int.tryParse(parts.isNotEmpty ? parts[0] : '0') ?? 0;
    final minor = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0;
    final patch = int.tryParse(parts.length > 2 ? parts[2] : '0') ?? 0;
    return major * 1_000_000 + minor * 1_000 + patch;
  }

  /// Open the device's default app store at the URL appropriate for the
  /// current platform.
  Future<void> openStore({required AppVersionResponse versionInfo}) async {
    final uri = Uri.tryParse(versionInfo.platformStoreUrl);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
