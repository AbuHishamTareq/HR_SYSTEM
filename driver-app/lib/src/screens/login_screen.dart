import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';

class DriverLoginScreen extends ConsumerStatefulWidget {
  const DriverLoginScreen({super.key});

  @override
  ConsumerState<DriverLoginScreen> createState() => _DriverLoginScreenState();
}

class _DriverLoginScreenState extends ConsumerState<DriverLoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  // ── Animation controllers ──
  late final AnimationController _entranceController;
  late final AnimationController _shakeController;

  // ── Entrance animations (staggered) ──
  late final Animation<double> _headerOpacity;
  late final Animation<Offset> _headerOffset;
  late final Animation<Offset> _usernameOffset;
  late final Animation<double> _usernameOpacity;
  late final Animation<Offset> _passwordOffset;
  late final Animation<double> _passwordOpacity;
  late final Animation<Offset> _buttonOffset;
  late final Animation<double> _buttonOpacity;

  // ── Error shake animation ──
  late final Animation<double> _shakeAnimation;

  // ── Tracking state ──
  String? _previousErrorMessage;
  bool _isButtonPressed = false;

  @override
  void initState() {
    super.initState();

    // ── Entrance controller — plays once on screen open ──
    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 1100),
      vsync: this,
    );

    _headerOpacity = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
    );
    _headerOffset = Tween<Offset>(
      begin: const Offset(0, -0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.35, curve: Curves.easeOutCubic),
    ));

    _usernameOffset = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.15, 0.45, curve: Curves.easeOutCubic),
    ));
    _usernameOpacity = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.15, 0.45, curve: Curves.easeOut),
    ));

    _passwordOffset = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.30, 0.60, curve: Curves.easeOutCubic),
    ));
    _passwordOpacity = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.30, 0.60, curve: Curves.easeOut),
    ));

    _buttonOffset = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.45, 0.75, curve: Curves.easeOutCubic),
    ));
    _buttonOpacity = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.45, 0.75, curve: Curves.easeOut),
    ));

    // ── Shake controller — plays when error appears ──
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 12.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 12.0, end: -10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8.0, end: -6.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -6.0, end: 4.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 4.0, end: -2.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -2.0, end: 0.0), weight: 1),
    ]).animate(_shakeController);

    // Kick off entrance
    _entranceController.forward();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _entranceController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  /// ═══════════════════════════════════════════════
  ///  Login logic — UNCHANGED (exact original)
  /// ═══════════════════════════════════════════════
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    // Simulate auth check
    if (username == 'driver' && password == '123456') {
      await ref.read(authProvider.notifier).saveToken('fake_driver_token');
      await ref.read(authProvider.notifier).setUser({
        'name': 'Ahmed Driver',
        'email': 'ahmed@example.com',
        'phone': '+966501234567',
        'role': 'driver',
        'rating': 4.8,
      });

      // Trigger GoRouter to re-evaluate redirects
      ref.read(routerNotifierProvider).refresh();

      if (mounted) {
        context.go('/');
      }
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Invalid username or password';
      });
    }
  }

  // ──────────────────────────────────────────────
  //  Build
  // ──────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    // Trigger shake animation when a *new* error appears
    if (_errorMessage != null && _previousErrorMessage == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _shakeController.forward(from: 0);
        }
      });
    }
    _previousErrorMessage = _errorMessage;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= 600;
        if (isTablet) {
          return _buildTabletLayout(context);
        }
        return _buildPhoneLayout(context);
      },
    );
  }

  // ──────────────────────────────────────────────
  //  Phone Layout (< 600px)
  // ──────────────────────────────────────────────
  Widget _buildPhoneLayout(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final headerHeight = size.height * 0.38;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              _buildGradientHeader(theme, headerHeight, isTablet: false),
              _buildFormCard(theme),
            ],
          ),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────
  //  Tablet Layout (>= 600px)
  // ──────────────────────────────────────────────
  Widget _buildTabletLayout(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primaryContainer,
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 16,
                ),
                child: Card(
                  elevation: 8,
                  shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 32,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Tablet header (simpler, inside card)
                        _buildTabletHeader(theme),
                        const SizedBox(height: 28),
                        _buildFormContent(theme),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────
  //  Header — Phone (gradient + wave clip)
  // ──────────────────────────────────────────────
  Widget _buildGradientHeader(
    ThemeData theme,
    double height, {
    required bool isTablet,
  }) {
    final iconSize = isTablet ? 64.0 : 72.0;
    final circleSize = isTablet ? 80.0 : 88.0;

    return SlideTransition(
      position: _headerOffset,
      child: FadeTransition(
        opacity: _headerOpacity,
        child: ClipPath(
          clipper: const _HeaderWaveClipper(),
          child: Container(
            width: double.infinity,
            height: height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primaryContainer,
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                // Icon with glow
                Container(
                  width: circleSize,
                  height: circleSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.surface.withValues(alpha: 0.15),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withValues(alpha: 0.35),
                        blurRadius: 28,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.local_shipping,
                    size: iconSize,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Driver App',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'HR System',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onPrimary.withValues(alpha: 0.85),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(flex: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────
  //  Header — Tablet (inside card, no wave)
  // ──────────────────────────────────────────────
  Widget _buildTabletHeader(ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.primaryContainer,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.2),
                blurRadius: 16,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(
            Icons.local_shipping,
            size: 40,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Driver App',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'HR System',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ──────────────────────────────────────────────
  //  Form Card (Phone) — overlaps the header wave
  // ──────────────────────────────────────────────
  Widget _buildFormCard(ThemeData theme) {
    return Transform.translate(
      offset: const Offset(0, -28),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Card(
          elevation: 8,
          shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.25),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 28,
            ),
            child: _buildFormContent(theme),
          ),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────
  //  Shared Form Content (phone + tablet)
  // ──────────────────────────────────────────────
  Widget _buildFormContent(ThemeData theme) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Error banner ──
          if (_errorMessage != null) ...[
            _buildErrorBanner(theme),
            const SizedBox(height: 20),
          ],

          // ── Username field ──
          SlideTransition(
            position: _usernameOffset,
            child: FadeTransition(
              opacity: _usernameOpacity,
              child: TextFormField(
                controller: _usernameController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  hintText: 'Enter your username',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ── Password field ──
          SlideTransition(
            position: _passwordOffset,
            child: FadeTransition(
              opacity: _passwordOpacity,
              child: TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _login(),
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
            ),
          ),
          const SizedBox(height: 28),

          // ── Login button ──
          SlideTransition(
            position: _buttonOffset,
            child: FadeTransition(
              opacity: _buttonOpacity,
              child: _buildLoginButton(theme),
            ),
          ),
          const SizedBox(height: 12),

          // ── Contact Admin ──
          Center(
            child: TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Please contact your administrator for account issues.',
                    ),
                  ),
                );
              },
              child: const Text('Contact Admin'),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────
  //  Error Banner (shake + dismiss)
  // ──────────────────────────────────────────────
  Widget _buildErrorBanner(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value, 0),
          child: child,
        );
      },
      child: GestureDetector(
        onTap: () => setState(() => _errorMessage = null),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.red.shade900.withValues(alpha: 0.55)
                : Colors.red.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? Colors.red.shade800 : Colors.red.shade200,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: isDark ? Colors.red.shade300 : Colors.red.shade700,
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _errorMessage!,
                  style: TextStyle(
                    color: isDark ? Colors.red.shade200 : Colors.red.shade800,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
              Icon(
                Icons.close,
                size: 18,
                color: isDark ? Colors.red.shade400 : Colors.red.shade500,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────
  //  Login Button (press scale + loading cross-fade)
  // ──────────────────────────────────────────────
  Widget _buildLoginButton(ThemeData theme) {
    return Listener(
      onPointerDown: (_) {
        if (!_isLoading) setState(() => _isButtonPressed = true);
      },
      onPointerUp: (_) {
        if (_isButtonPressed) setState(() => _isButtonPressed = false);
      },
      onPointerCancel: (_) {
        if (_isButtonPressed) setState(() => _isButtonPressed = false);
      },
      child: AnimatedScale(
        scale: _isButtonPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _login,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: _isButtonPressed ? 1 : 2,
            ),
            child: AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              crossFadeState: _isLoading
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: Text(
                'Login',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              secondChild: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  Wave Clipper — creates a subtle wave at the header bottom
// ═══════════════════════════════════════════════════════════
class _HeaderWaveClipper extends CustomClipper<Path> {
  const _HeaderWaveClipper();

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 35);

    // First curve (left third)
    final firstControlPoint = Offset(size.width / 4, size.height + 5);
    final firstEndPoint = Offset(size.width / 2, size.height - 15);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    // Second curve (right two-thirds)
    final secondControlPoint = Offset(
      3 * size.width / 4,
      size.height - 45,
    );
    final secondEndPoint = Offset(size.width, size.height - 10);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
