import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  // ── Form state ──
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  String _countryCode = '+966';
  bool _isLoading = false;

  // ── Saudi flag colour palette ──
  static const Color _saudiGreen = Color(0xFF006C35);
  static const Color _lightGreen = Color(0xFFE8F5E9);

  // ═══════════════════════════════════════════════════
  //  Animation Controllers
  // ═══════════════════════════════════════════════════

  // 1. Background gradient pulse
  late final AnimationController _bgPulseController;
  late final Animation<double> _bgPulseAnim;

  // 2. Floating decorative rings
  late final AnimationController _ring1Controller;
  late final AnimationController _ring2Controller;
  late final AnimationController _ring3Controller;

  // 3. Card entrance (scale + fade)
  late final AnimationController _cardEntranceController;
  late final Animation<double> _cardScaleAnim;
  late final Animation<double> _cardOpacityAnim;

  // 4. Form field stagger (fade + scale)
  late final AnimationController _formStaggerController;
  late final Animation<double> _fieldOpacity;
  late final Animation<double> _fieldScale;

  // 5. Button spring bounce
  late final AnimationController _buttonController;
  late final Animation<double> _buttonAnim;

  // ═══════════════════════════════════════════════════
  //  Ring animation values (drift via sine/cos path)
  // ═══════════════════════════════════════════════════
  late final Animation<double> _ring1Anim;
  late final Animation<double> _ring2Anim;
  late final Animation<double> _ring3Anim;

  // ──────────────────────────────────────────────────
  //  initState — set up all animations
  // ──────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();

    // ── 1. Background pulse (continuous, slow) ──
    _bgPulseController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);

    _bgPulseAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _bgPulseController,
        curve: Curves.easeInOutSine,
      ),
    );

    // ── 2. Floating rings (different durations for organic feel) ──
    _ring1Controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);

    _ring2Controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);

    _ring3Controller = AnimationController(
      duration: const Duration(seconds: 7),
      vsync: this,
    )..repeat(reverse: true);

    _ring1Anim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ring1Controller,
        curve: Curves.easeInOutSine,
      ),
    );
    _ring2Anim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ring2Controller,
        curve: Curves.easeInOutSine,
      ),
    );
    _ring3Anim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ring3Controller,
        curve: Curves.easeInOutSine,
      ),
    );

    // ── 3. Card entrance (scale 0.85 → 1.0 + fade 0 → 1) ──
    _cardEntranceController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _cardScaleAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _cardEntranceController,
        curve: Curves.easeOutCubic,
      ),
    );
    _cardOpacityAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _cardEntranceController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    // ── 4. Form field stagger (fade + slight scale) ──
    _formStaggerController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fieldOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _formStaggerController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _fieldScale = Tween<double>(begin: 1.05, end: 1.0).animate(
      CurvedAnimation(
        parent: _formStaggerController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    // ── 5. Button spring bounce ──
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _buttonAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _buttonController,
        curve: Curves.elasticOut,
      ),
    );

    // ── Kick off staggered entrance sequence ──
    _cardEntranceController.forward();
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) _formStaggerController.forward();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _buttonController.forward();
    });
  }

  // ──────────────────────────────────────────────────
  //  dispose
  // ──────────────────────────────────────────────────
  @override
  void dispose() {
    _phoneController.dispose();
    _bgPulseController.dispose();
    _ring1Controller.dispose();
    _ring2Controller.dispose();
    _ring3Controller.dispose();
    _cardEntranceController.dispose();
    _formStaggerController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  // ──────────────────────────────────────────────────
  //  _submit
  // ──────────────────────────────────────────────────
  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() => _isLoading = false);

      final phone = '$_countryCode${_phoneController.text}';
      context.go('/otp?phone=$phone');
    });
  }

  // ═══════════════════════════════════════════════════
  //  Build
  // ═══════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= 600;
        return _buildScaffold(isTablet);
      },
    );
  }

  // ═══════════════════════════════════════════════════
  //  Scaffold — full-screen animated gradient
  // ═══════════════════════════════════════════════════
  Widget _buildScaffold(bool isTablet) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // ── Animated full-screen gradient ──
          AnimatedBuilder(
            animation: _bgPulseController,
            builder: (context, child) {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              return Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      // Saudi green at top — subtly pulses between two shades
                      Color.lerp(
                        _saudiGreen,
                        const Color(0xFF005A2E),
                        _bgPulseAnim.value,
                      )!,
                      // Bottom fades to light green (light) or dark (dark mode)
                      isDark
                          ? Color.lerp(
                              const Color(0xFF001A0E),
                              const Color(0xFF002D18),
                              _bgPulseAnim.value,
                            )!
                          : Color.lerp(
                              _lightGreen,
                              const Color(0xFFD0EBD8),
                              _bgPulseAnim.value,
                            )!,
                    ],
                  ),
                ),
              );
            },
          ),

          // ── Animated decorative floating rings ──
          ..._buildFloatingRings(),

          // ── Safe content area ──
          SafeArea(
            child: isTablet ? _buildTabletLayout() : _buildPhoneLayout(),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  //  Floating Decorative Rings
  // ═══════════════════════════════════════════════════
  List<Widget> _buildFloatingRings() {
    return [
      // Ring 1 — top-left area (large, very subtle)
      _AnimatedRing(
        animation: _ring1Anim,
        size: 220,
        borderColor: Colors.white.withValues(alpha: 0.10),
        alignment: const Alignment(-0.90, -0.84),
        driftAmplitudeX: 30,
        driftAmplitudeY: 20,
      ),

      // Ring 2 — bottom-right area (largest, slowest drift)
      _AnimatedRing(
        animation: _ring2Anim,
        size: 280,
        borderColor: Colors.white.withValues(alpha: 0.07),
        alignment: const Alignment(0.50, 0.60),
        driftAmplitudeX: 25,
        driftAmplitudeY: 35,
      ),

      // Ring 3 — mid-right area (brand-tinted)
      _AnimatedRing(
        animation: _ring3Anim,
        size: 160,
        borderColor: _saudiGreen.withValues(alpha: 0.10),
        alignment: const Alignment(0.70, -0.60),
        driftAmplitudeX: 20,
        driftAmplitudeY: 25,
      ),

      // Ring 4 — small accent near center-left (shares ring1 rhythm)
      _AnimatedRing(
        animation: _ring1Anim,
        size: 100,
        borderColor: Colors.white.withValues(alpha: 0.06),
        alignment: const Alignment(-0.70, 0.10),
        driftAmplitudeX: 15,
        driftAmplitudeY: 15,
      ),
    ];
  }

  // ═══════════════════════════════════════════════════
  //  Phone Layout
  // ═══════════════════════════════════════════════════
  Widget _buildPhoneLayout() {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SizedBox(
        height: MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top -
            MediaQuery.of(context).padding.bottom,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _buildCard(),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  //  Tablet Layout
  // ═══════════════════════════════════════════════════
  Widget _buildTabletLayout() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            vertical: 32,
            horizontal: 16,
          ),
          child: _buildCard(),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  //  Floating Card (shared by phone & tablet)
  // ═══════════════════════════════════════════════════
  Widget _buildCard() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _cardEntranceController,
      builder: (context, child) {
        return Opacity(
          opacity: _cardOpacityAnim.value,
          child: Transform.scale(
            scale: _cardScaleAnim.value,
            child: Card(
              elevation: isDark ? 4 : 8,
              shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 0, 28, 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── Avatar badge (overlaps top edge) ──
                    Transform.translate(
                      offset: const Offset(0, -36),
                      child: _buildAvatarBadge(theme),
                    ),
                    // ── Content (pulled up snug against badge) ──
                    Transform.translate(
                      offset: const Offset(0, -18),
                      child: _buildCardContent(theme),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════
  //  Avatar Badge
  // ═══════════════════════════════════════════════════
  Widget _buildAvatarBadge(ThemeData theme) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _saudiGreen,
        boxShadow: [
          BoxShadow(
            color: _saudiGreen.withValues(alpha: 0.3),
            blurRadius: 16,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: _saudiGreen.withValues(alpha: 0.15),
            blurRadius: 32,
            spreadRadius: 4,
          ),
        ],
      ),
      child: const Icon(
        Icons.phone_android_rounded,
        size: 36,
        color: Colors.white,
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  //  Card Content
  // ═══════════════════════════════════════════════════
  Widget _buildCardContent(ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title
        Text(
          'Customer App',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        // Subtitle
        Text(
          'Welcome back! Sign in to continue',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 28),
        // Form fields
        _buildFormFields(theme),
        const SizedBox(height: 24),
        // Submit button
        _buildAnimatedButton(theme),
      ],
    );
  }

  // ═══════════════════════════════════════════════════
  //  Form Fields (staggered entrance)
  // ═══════════════════════════════════════════════════
  Widget _buildFormFields(ThemeData theme) {
    return AnimatedBuilder(
      animation: _formStaggerController,
      builder: (context, child) {
        return Opacity(
          opacity: _fieldOpacity.value,
          child: Transform.scale(
            scale: _fieldScale.value,
            child: child,
          ),
        );
      },
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Country code dropdown
                _buildCountryCodeDropdown(theme),
                const SizedBox(width: 12),
                // Phone number field
                Expanded(child: _buildPhoneField(theme)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  //  Country Code Dropdown
  // ═══════════════════════════════════════════════════
  Widget _buildCountryCodeDropdown(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      width: 100,
      child: DropdownButtonFormField<String>(
        initialValue: _countryCode,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
        ),
        items: const [
          DropdownMenuItem(value: '+966', child: Text('🇸🇦 +966')),
          DropdownMenuItem(value: '+971', child: Text('🇦🇪 +971')),
          DropdownMenuItem(value: '+973', child: Text('🇧🇭 +973')),
          DropdownMenuItem(value: '+965', child: Text('🇰🇼 +965')),
        ],
        onChanged: (value) {
          if (value != null) setState(() => _countryCode = value);
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  //  Phone Number Field
  // ═══════════════════════════════════════════════════
  Widget _buildPhoneField(ThemeData theme) {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _submit(),
      decoration: InputDecoration(
        labelText: 'Phone Number',
        hintText: '5XXXXXXXX',
        prefixIcon: const Icon(Icons.phone),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _saudiGreen, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a valid phone number';
        }
        // Strip any non-digit characters for clean validation
        final digits = value.replaceAll(RegExp(r'\D'), '');
        if (digits.length != 10) {
          return 'Phone number must be 10 digits';
        }
        if (!digits.startsWith('5')) {
          return 'Phone number must start with 5';
        }
        return null;
      },
    );
  }

  // ═══════════════════════════════════════════════════
  //  Animated Button (spring bounce entrance)
  // ═══════════════════════════════════════════════════
  Widget _buildAnimatedButton(ThemeData theme) {
    return AnimatedBuilder(
      animation: _buttonController,
      builder: (context, child) {
        // elasticOut goes above 1.0, creating a bounce; we translate up
        final bounceOffset = (1.0 - _buttonAnim.value) * 12.0;

        return Transform.translate(
          offset: Offset(0, bounceOffset),
          child: Opacity(
            opacity: _buttonAnim.value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: _saudiGreen,
            disabledBackgroundColor: _saudiGreen.withValues(alpha: 0.6),
            foregroundColor: Colors.white,
            disabledForegroundColor: Colors.white.withValues(alpha: 0.7),
            elevation: 2,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: _isLoading
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const Text('Send OTP'),
            secondChild: const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  _AnimatedRing — decorative floating ring with sine-wave drift
// ════════════════════════════════════════════════════════════════
class _AnimatedRing extends StatelessWidget {
  /// The animation driving the ring's drift (values 0..1).
  final Animation<double> animation;

  /// Diameter of the ring.
  final double size;

  /// Colour of the ring's border stroke.
  final Color borderColor;

  /// Base position as an [Alignment] within the parent Stack.
  final Alignment alignment;

  /// Horizontal drift amplitude in logical pixels.
  final double driftAmplitudeX;

  /// Vertical drift amplitude in logical pixels.
  final double driftAmplitudeY;

  const _AnimatedRing({
    required this.animation,
    required this.size,
    required this.borderColor,
    required this.alignment,
    required this.driftAmplitudeX,
    required this.driftAmplitudeY,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          // Sine/cosine produce a smooth drifting figure-8 / circular path
          final phase = animation.value * 2 * math.pi;
          final dx = math.sin(phase) * driftAmplitudeX;
          final dy = math.cos(phase * 0.7) * driftAmplitudeY;

          return Transform.translate(
            offset: Offset(dx, dy),
            child: child,
          );
        },
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: 2),
          ),
        ),
      ),
    );
  }
}
