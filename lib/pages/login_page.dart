import 'package:flutter/material.dart';
import '../theme/cyber_theme.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _error;

  late AnimationController _fadeCtrl;
  late AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..forward();
    _pulseCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    if (_userCtrl.text.trim() == 'admin' && _passCtrl.text.trim() == '123') {
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const HomePage(),
            transitionsBuilder: (_, a, __, c) =>
                FadeTransition(opacity: a, child: c),
            transitionDuration: const Duration(milliseconds: 500),
          ));
    } else {
      setState(() {
        _loading = false;
        _error = 'ACCESS DENIED // Invalid credentials';
      });
    }
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _pulseCtrl.dispose();
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CyberScaffold(
      showBack: false,
      accent: Cyber.cyan,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: FadeTransition(
              opacity: CurvedAnimation(
                  parent: _fadeCtrl, curve: Curves.easeOut),
              child: SlideTransition(
                position: Tween<Offset>(
                        begin: const Offset(0, 0.06), end: Offset.zero)
                    .animate(CurvedAnimation(
                        parent: _fadeCtrl, curve: Curves.easeOutCubic)),
                child: Column(
                  children: [
                    // ── Terminal header ──
                    TypingText(
                        text: '> INITIALIZING SECURE TERMINAL v3.0.26...'),
                    const SizedBox(height: 28),

                    // ── Glitch title ──
                    const GlitchText(text: 'LOGIN'),
                    const SizedBox(height: 6),
                    Text('// AUTHENTICATION REQUIRED',
                        style: TextStyle(
                            color: Cyber.textDim,
                            fontSize: 11,
                            letterSpacing: 2.5)),
                    const SizedBox(height: 36),

                    // ── Login panel ──
                    HudCorners(
                      color: Cyber.cyan,
                      child: AnimatedBuilder(
                        animation: _pulseCtrl,
                        builder: (_, child) => Container(
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: Cyber.cyan.withOpacity(
                                  0.03 + _pulseCtrl.value * 0.04),
                              blurRadius: 30,
                              spreadRadius: -4,
                            ),
                          ]),
                          child: child,
                        ),
                        child: NeonCard(
                          glowColor: Cyber.cyan,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Panel header bar
                                Row(children: [
                                  const StatusDot(color: Cyber.green),
                                  const SizedBox(width: 8),
                                  Text('CREDENTIALS INPUT',
                                      style: TextStyle(
                                          color: Cyber.textDim,
                                          fontSize: 9,
                                          letterSpacing: 2,
                                          fontWeight: FontWeight.w700)),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Cyber.cyan.withOpacity(0.08),
                                      border: Border.all(
                                          color: Cyber.cyan.withOpacity(0.2)),
                                    ),
                                    child: Text('SECURE',
                                        style: TextStyle(
                                            color: Cyber.cyan,
                                            fontSize: 8,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 1.5)),
                                  ),
                                ]),
                                const SizedBox(height: 8),
                                const NeonDivider(),
                                const SizedBox(height: 20),

                                // USERNAME
                                _label('USER_ID'),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _userCtrl,
                                  style: const TextStyle(
                                      color: Cyber.textMain, letterSpacing: 1),
                                  decoration: const InputDecoration(
                                    hintText: 'Enter username...',
                                    prefixIcon:
                                        Icon(Icons.person_outline_rounded),
                                  ),
                                  textInputAction: TextInputAction.next,
                                  validator: (v) =>
                                      (v == null || v.isEmpty) ? 'Required' : null,
                                ),
                                const SizedBox(height: 18),

                                // PASSWORD
                                _label('ACCESS_KEY'),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _passCtrl,
                                  obscureText: _obscure,
                                  style: const TextStyle(
                                      color: Cyber.textMain, letterSpacing: 1),
                                  decoration: InputDecoration(
                                    hintText: 'Enter password...',
                                    prefixIcon:
                                        const Icon(Icons.lock_outline_rounded),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                          _obscure
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                          color: Cyber.textDim,
                                          size: 18),
                                      onPressed: () =>
                                          setState(() => _obscure = !_obscure),
                                    ),
                                  ),
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (_) => _login(),
                                  validator: (v) =>
                                      (v == null || v.isEmpty) ? 'Required' : null,
                                ),

                                // ERROR
                                if (_error != null) ...[
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Cyber.red.withOpacity(0.06),
                                      border: const Border(
                                          left: BorderSide(
                                              color: Cyber.red, width: 2)),
                                    ),
                                    child: Row(children: [
                                      const Icon(Icons.warning_amber_rounded,
                                          color: Cyber.red, size: 16),
                                      const SizedBox(width: 8),
                                      Flexible(
                                          child: Text(_error!,
                                              style: const TextStyle(
                                                  color: Cyber.red,
                                                  fontSize: 12,
                                                  letterSpacing: 0.5))),
                                    ]),
                                  ),
                                ],
                                const SizedBox(height: 24),

                                // LOGIN BUTTON
                                CyberButton(
                                  label: _loading
                                      ? 'AUTHENTICATING...'
                                      : 'INITIALIZE LOGIN',
                                  icon: _loading ? null : Icons.login_rounded,
                                  onPressed: _loading ? null : _login,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // ── Hint ──
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                          border: Border.all(color: Cyber.border)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.info_outline_rounded,
                              color: Cyber.textDim, size: 14),
                          const SizedBox(width: 8),
                          Text('user: admin  //  key: 123',
                              style: TextStyle(
                                  color: Cyber.textDim,
                                  fontSize: 11,
                                  letterSpacing: 1)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String t) => Text(t,
      style: TextStyle(
          color: Cyber.cyan,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 2));
}
