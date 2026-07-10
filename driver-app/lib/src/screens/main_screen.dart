import 'package:flutter/material.dart';

/// Main screen placeholder — the actual scaffold is handled by ShellRoute in app_router.dart.
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // This screen is replaced by DriverMainShell in the router.
    // Tab content is rendered in the individual tab screens.
    return const SizedBox.shrink();
  }
}
