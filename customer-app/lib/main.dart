import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'src/providers/theme_provider.dart';
import 'src/providers/locale_provider.dart';
import 'src/providers/app_update_provider.dart';
import 'src/routing/app_router.dart';
import 'src/services/app_update_service.dart';
import 'src/theme/app_theme.dart';
import 'src/widgets/update_dialog.dart';

// Generated localization
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dsn = const String.fromEnvironment(
    'SENTRY_DSN',
    defaultValue: 'https://examplePublicKey@o0.ingest.sentry.io/0',
  );
  final environment = const String.fromEnvironment(
    'SENTRY_ENVIRONMENT',
    defaultValue: 'local',
  );

  if (dsn.isNotEmpty && dsn != 'https://examplePublicKey@o0.ingest.sentry.io/0') {
    await SentryFlutter.init(
      (options) {
        options.dsn = dsn;
        options.environment = environment;
        options.tracesSampleRate = environment == 'production' ? 0.25 : 0.0;
        options.sendDefaultPii = true;
        options.debug = false;
      },
    );

    // Global error handlers — only set when Sentry is active
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      Sentry.captureException(
        details.exception,
        stackTrace: details.stack,
        hint: Hint.withMap({
          'context': 'FlutterError.onError',
          'library': details.library ?? 'unknown',
        }),
      );
    };

    ui.PlatformDispatcher.instance.onError = (error, stack) {
      Sentry.captureException(error, stackTrace: stack);
      return true;
    };
  }

  runApp(
    const ProviderScope(
      child: HrSystemApp(),
    ),
  );
}

class HrSystemApp extends ConsumerStatefulWidget {
  const HrSystemApp({super.key});

  @override
  ConsumerState<HrSystemApp> createState() => _HrSystemAppState();
}

class _HrSystemAppState extends ConsumerState<HrSystemApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForUpdate();
    });
  }

  Future<void> _checkForUpdate() async {
    final updateService = ref.read(appUpdateServiceProvider);
    try {
      final result = await updateService.checkForUpdate();
      if (!mounted) return;

      if (result.status == UpdateStatus.forceUpdate ||
          result.status == UpdateStatus.optionalUpdate) {
        showUpdateDialog(
          context: context,
          isForceUpdate: result.status == UpdateStatus.forceUpdate,
          storeUrl: result.versionInfo.platformStoreUrl,
        );
      }
    } catch (_) {
      // Silently ignore network errors — the app works offline
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'HR System',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
    );
  }
}
