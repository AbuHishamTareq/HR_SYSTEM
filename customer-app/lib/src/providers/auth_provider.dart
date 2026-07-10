import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'router_notifier.dart';

/// Represents the authentication state of the user.
class AuthState {
  final String? token;
  final Map<String, dynamic>? user;
  final bool isLoading;

  const AuthState({
    this.token,
    this.user,
    this.isLoading = false,
  });

  bool get isAuthenticated => token != null && user != null;

  AuthState copyWith({
    String? token,
    Map<String, dynamic>? user,
    bool? isLoading,
    bool clearUser = false,
    bool clearToken = false,
  }) {
    return AuthState(
      token: clearToken ? null : (token ?? this.token),
      user: clearUser ? null : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Provider for authentication state.
final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState();
  }

  /// Save the authentication token.
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    state = state.copyWith(token: token);
    ref.read(routerNotifierProvider).refresh();
  }

  /// Save user data after login.
  Future<void> setUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', user.toString());
    state = state.copyWith(user: user);
    ref.read(routerNotifierProvider).refresh();

    // Identify user in Sentry for error tracking
    Sentry.configureScope((scope) {
      scope.setUser(SentryUser(
        id: user['email']?.toString() ?? '',
        email: user['email']?.toString(),
        username: user['name']?.toString(),
      ));
    });
  }

  /// Load persisted auth state (e.g., on app start).
  Future<void> loadAuthState() async {
    state = state.copyWith(isLoading: true);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token != null) {
      state = state.copyWith(token: token, isLoading: false);
      final userString = prefs.getString('user_data');
      if (userString != null) {
        state = state.copyWith(user: {'name': userString}, isLoading: false);
      }
    } else {
      state = state.copyWith(isLoading: false);
    }
    ref.read(routerNotifierProvider).refresh();
  }

  /// Clear auth state (logout).
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_data');
    state = const AuthState();
    ref.read(routerNotifierProvider).refresh();

    // Clear Sentry user context
    Sentry.configureScope((scope) {
      scope.setUser(null);
    });
  }

  /// Set loading state.
  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }
}

/// Notifies GoRouter to re-evaluate redirects on auth state changes.
final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  return RouterNotifier();
});
