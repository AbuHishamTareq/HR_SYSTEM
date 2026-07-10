import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/api_client.dart';
import '../services/app_update_service.dart';

/// Provider that exposes the [AppUpdateService] singleton.
final appUpdateServiceProvider = Provider<AppUpdateService>((ref) {
  return AppUpdateService(ref.read(apiClientProvider).dio);
});
