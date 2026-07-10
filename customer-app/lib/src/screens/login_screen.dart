import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  String _countryCode = '+966';
  bool _isLoading = false;

  // ── Animation controllers ──
  late final AnimationController _entranceController;

  // ── Entrance animations (staggered) ──
  late final Animation<double> _headerOpacity;
  late final Animation<Offset> _headerOffset;
  late final Animation<double> _formOpacity;
  late final Animation<Offset> _formOffset;
  late final Animation<double> _buttonOpacity;
  late final Animation<Offset> _buttonOffset;

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 900),
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

    _formOpacity = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.2, 0.55, curve: Curves.easeOut),
    );
    _formOffset = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.2, 0.55, curve: Curves.easeOutCubic),
    ));

    _buttonOpacity = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.40, 0.75, curve: Curves.easeOut),
    );
    _buttonOffset = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.40, 0.75, curve: Curves.easeOutCubic),
    ));

    _entranceController.forward();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate API call delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() => _isLoading = false);

      final phone = '$_countryCode${_phoneController.text}';
      context.go('/otp?phone=$phone');
    });
  }

  // ── Saudi Flag Color Palette ──
  static const Color _saudiGreen = Color(0xFF006C35);
  static const Color _lightGreen = Color(0xFFE8F5E9);
  static const Color _darkGreen = Color(0xFF004D26);

  @override
  Widget build(BuildContext context) {
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
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              isDark ? _darkGreen : _lightGreen,
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
                  shadowColor:
                      theme.colorScheme.shadow.withValues(alpha: 0.3),
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
    final isDark = theme.brightness == Brightness.dark;

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
                colors: isDark
                    ? [const Color(0xFF004D26), const Color(0xFF003D1E)]
                    : [const Color(0xFF006C35), const Color(0xFF008847)],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                // Icon with glow shadow
                Container(
                  width: circleSize,
                  height: circleSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.15),
                    boxShadow: [
                      BoxShadow(
                        color: (isDark
                                ? const Color(0xFF004D26)
                                : const Color(0xFF006C35))
                            .withValues(alpha: 0.5),
                        blurRadius: 28,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.phone_android,
                    size: iconSize,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Customer App',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'HR System',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
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
            color: theme.brightness == Brightness.dark
                ? _darkGreen
                : _saudiGreen,
            boxShadow: [
              BoxShadow(
                color: (theme.brightness == Brightness.dark
                        ? _darkGreen
                        : _saudiGreen)
                    .withValues(alpha: 0.3),
                blurRadius: 16,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(
            Icons.phone_android,
            size: 40,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Customer App',
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
      offset: const Offset(0, -40),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 32),
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
    final isDark = theme.brightness == Brightness.dark;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Country code + Phone number row ──
          SlideTransition(
            position: _formOffset,
            child: FadeTransition(
              opacity: _formOpacity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Country code dropdown
                  Container(
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isDark
                            ? Colors.grey.shade700
                            : Colors.grey.shade300,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonFormField<String>(
                      initialValue: _countryCode,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: '+966',
                          child: Text('🇸🇦 +966'),
                        ),
                        DropdownMenuItem(
                          value: '+971',
                          child: Text('🇦🇪 +971'),
                        ),
                        DropdownMenuItem(
                          value: '+973',
                          child: Text('🇧🇭 +973'),
                        ),
                        DropdownMenuItem(
                          value: '+965',
                          child: Text('🇰🇼 +965'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _countryCode = value);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Phone number field
                  Expanded(
                    child: TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submit(),
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        hintText: '5XXXXXXXX',
                        prefixIcon: const Icon(Icons.phone),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF006C35),
                            width: 2,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid phone number';
                        }
                        if (value.length != 10) {
                          return 'Phone number must be 10 digits';
                        }
                        if (!value.startsWith('5')) {
                          return 'Phone number must start with 5';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),

          // ── Send OTP Button ──
          SlideTransition(
            position: _buttonOffset,
            child: FadeTransition(
              opacity: _buttonOpacity,
              child: _buildSubmitButton(theme),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────
  //  Submit Button (loading cross-fade)
  // ──────────────────────────────────────────────
  Widget _buildSubmitButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: _saudiGreen,
          disabledBackgroundColor: _saudiGreen.withValues(alpha: 0.6),
          foregroundColor: Colors.white,
          disabledForegroundColor: Colors.white.withValues(alpha: 0.7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
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
    path.lineTo(0, size.height - 50);

    // First curve (left third) — deeper dip for a more pronounced wave
    final firstControlPoint = Offset(size.width / 4, size.height + 15);
    final firstEndPoint = Offset(size.width / 2, size.height - 10);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    // Second curve (right two-thirds)
    final secondControlPoint = Offset(
      3 * size.width / 4,
      size.height - 25,
    );
    final secondEndPoint = Offset(size.width, size.height - 5);
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
