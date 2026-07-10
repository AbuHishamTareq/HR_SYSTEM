import 'package:flutter/foundation.dart';

/// Notifies GoRouter to re-evaluate redirects when auth state changes.
/// This avoids rebuilding the entire GoRouter instance.
class RouterNotifier extends ChangeNotifier {
  void refresh() {
    notifyListeners();
  }
}
