import 'dart:async';
import 'package:flutter/material.dart';

// ══════════════════════════════════════════════════════════════════════════════
//  C Y B E R P U N K   C O L O R   P A L E T T E
// ══════════════════════════════════════════════════════════════════════════════
class Cyber {
  Cyber._();
  static const bg        = Color(0xFF050A18);
  static const surface   = Color(0xFF0A1628);
  static const panel     = Color(0xFF0D1B2A);
  static const border    = Color(0xFF0F2847);
  static const cyan      = Color(0xFF00F0FF);
  static const pink      = Color(0xFFFF0066);
  static const yellow    = Color(0xFFFFE000);
  static const green     = Color(0xFF00FF88);
  static const purple    = Color(0xFFBB00FF);
  static const orange    = Color(0xFFFF6B00);
  static const red       = Color(0xFFFF2244);
  static const textMain  = Color(0xFFE0F0FF);
  static const textDim   = Color(0xFF4A6A8A);
}

// ══════════════════════════════════════════════════════════════════════════════
//  C Y B E R   S C A F F O L D  — full‑screen bg, grid, scan line
// ══════════════════════════════════════════════════════════════════════════════
class CyberScaffold extends StatefulWidget {
  final String? title;
  final Widget body;
  final bool showBack;
  final Color accent;
  final List<Widget>? actions;

  const CyberScaffold({
    super.key,
    this.title,
    required this.body,
    this.showBack = true,
    this.accent = Cyber.cyan,
    this.actions,
  });

  @override
  State<CyberScaffold> createState() => _CyberScaffoldState();
}

class _CyberScaffoldState extends State<CyberScaffold>
    with SingleTickerProviderStateMixin {
  late AnimationController _scanCtrl;

  @override
  void initState() {
    super.initState();
    _scanCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _scanCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cyber.bg,
      extendBodyBehindAppBar: true,
      appBar: widget.title != null
          ? AppBar(
              backgroundColor: Cyber.bg.withOpacity(0.8),
              elevation: 0,
              centerTitle: true,
              leading: widget.showBack
                  ? IconButton(
                      icon: Icon(Icons.arrow_back_ios_new_rounded,
                          color: widget.accent, size: 16),
                      onPressed: () => Navigator.pop(context),
                    )
                  : null,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('[ ',
                      style: TextStyle(
                          color: widget.accent,
                          fontSize: 13,
                          fontWeight: FontWeight.w300)),
                  Text(widget.title!.toUpperCase(),
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2.5,
                          color: Cyber.textMain)),
                  Text(' ]',
                      style: TextStyle(
                          color: widget.accent,
                          fontSize: 13,
                          fontWeight: FontWeight.w300)),
                ],
              ),
              actions: widget.actions,
            )
          : null,
      body: Stack(
        children: [
          // ── Gradient bg ──
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF080E24), Cyber.bg, Color(0xFF030612)],
              ),
            ),
          ),
          // ── Dot grid ──
          Positioned.fill(
            child: RepaintBoundary(
              child: CustomPaint(painter: _GridPainter(widget.accent)),
            ),
          ),
          // ── Content ──
          widget.body,
          // ── Animated scan line ──
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _scanCtrl,
                builder: (_, __) => CustomPaint(
                  painter:
                      _ScanLinePainter(_scanCtrl.value, widget.accent),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Grid painter ───────────────────────────────────────────────────────────────
class _GridPainter extends CustomPainter {
  final Color accent;
  _GridPainter(this.accent);

  @override
  void paint(Canvas canvas, Size size) {
    const sp = 36.0;
    final line = Paint()
      ..color = accent.withOpacity(0.025)
      ..strokeWidth = 0.5;
    for (double x = 0; x < size.width; x += sp) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), line);
    }
    for (double y = 0; y < size.height; y += sp) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), line);
    }
    final dot = Paint()..color = accent.withOpacity(0.06);
    for (double x = 0; x < size.width; x += sp) {
      for (double y = 0; y < size.height; y += sp) {
        canvas.drawCircle(Offset(x, y), 0.8, dot);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Scan line painter ──────────────────────────────────────────────────────────
class _ScanLinePainter extends CustomPainter {
  final double t;
  final Color color;
  _ScanLinePainter(this.t, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final y = t * size.height;
    canvas.drawRect(
      Rect.fromLTWH(0, y - 12, size.width, 24),
      Paint()
        ..color = color.withOpacity(0.04)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16),
    );
    canvas.drawLine(
      Offset(0, y),
      Offset(size.width, y),
      Paint()
        ..color = color.withOpacity(0.12)
        ..strokeWidth = 0.5,
    );
  }

  @override
  bool shouldRepaint(covariant _ScanLinePainter o) => o.t != t;
}

// ══════════════════════════════════════════════════════════════════════════════
//  N E O N   C A R D  — cut‑corner panel with neon border & outer glow
// ══════════════════════════════════════════════════════════════════════════════
class NeonCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color glowColor;
  final double cutSize;

  const NeonCard({
    super.key,
    required this.child,
    this.padding,
    this.glowColor = Cyber.cyan,
    this.cutSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _NeonCardPainter(glowColor, cutSize),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(20),
        child: child,
      ),
    );
  }
}

class _NeonCardPainter extends CustomPainter {
  final Color glow;
  final double cut;
  _NeonCardPainter(this.glow, this.cut);

  Path _path(Size s) => Path()
    ..moveTo(cut, 0)
    ..lineTo(s.width, 0)
    ..lineTo(s.width, s.height - cut)
    ..lineTo(s.width - cut, s.height)
    ..lineTo(0, s.height)
    ..lineTo(0, cut)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final p = _path(size);
    // outer glow
    canvas.drawPath(
        p,
        Paint()
          ..color = glow.withOpacity(0.06)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6
          ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 10));
    // fill
    canvas.drawPath(p, Paint()..color = Cyber.panel);
    // border
    canvas.drawPath(
        p,
        Paint()
          ..color = glow.withOpacity(0.18)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1);
    // bright corners
    _drawCornerDot(canvas, Offset(cut, 0), glow);
    _drawCornerDot(canvas, Offset(size.width, 0), glow);
    _drawCornerDot(canvas, Offset(size.width - cut, size.height), glow);
    _drawCornerDot(canvas, Offset(0, size.height), glow);
  }

  void _drawCornerDot(Canvas c, Offset pos, Color col) {
    c.drawCircle(pos, 2, Paint()..color = col.withOpacity(0.5));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ══════════════════════════════════════════════════════════════════════════════
//  H U D   C O R N E R S  — bracket marks around a widget
// ══════════════════════════════════════════════════════════════════════════════
class HudCorners extends StatelessWidget {
  final Widget child;
  final Color color;
  final double size;

  const HudCorners({
    super.key,
    required this.child,
    this.color = Cyber.cyan,
    this.size = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(padding: EdgeInsets.all(size * 0.6), child: child),
        Positioned(top: 0, left: 0, child: _mark(true, true)),
        Positioned(top: 0, right: 0, child: _mark(true, false)),
        Positioned(bottom: 0, left: 0, child: _mark(false, true)),
        Positioned(bottom: 0, right: 0, child: _mark(false, false)),
      ],
    );
  }

  Widget _mark(bool top, bool left) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _BracketPainter(color, top, left)),
    );
  }
}

class _BracketPainter extends CustomPainter {
  final Color c;
  final bool top, left;
  _BracketPainter(this.c, this.top, this.left);

  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()
      ..color = c
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;
    final path = Path();
    if (top && left) {
      path
        ..moveTo(0, s.height)
        ..lineTo(0, 0)
        ..lineTo(s.width, 0);
    } else if (top && !left) {
      path
        ..moveTo(0, 0)
        ..lineTo(s.width, 0)
        ..lineTo(s.width, s.height);
    } else if (!top && left) {
      path
        ..moveTo(0, 0)
        ..lineTo(0, s.height)
        ..lineTo(s.width, s.height);
    } else {
      path
        ..moveTo(0, s.height)
        ..lineTo(s.width, s.height)
        ..lineTo(s.width, 0);
    }
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter o) => false;
}

// ══════════════════════════════════════════════════════════════════════════════
//  G L I T C H   T E X T
// ══════════════════════════════════════════════════════════════════════════════
class GlitchText extends StatelessWidget {
  final String text;
  final double fontSize;

  const GlitchText({super.key, required this.text, this.fontSize = 32});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Transform.translate(
          offset: const Offset(-2.5, -1),
          child: Text(text,
              style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w900,
                  color: Cyber.cyan.withOpacity(0.55),
                  letterSpacing: 6)),
        ),
        Transform.translate(
          offset: const Offset(2.5, 1),
          child: Text(text,
              style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w900,
                  color: Cyber.pink.withOpacity(0.55),
                  letterSpacing: 6)),
        ),
        Text(text,
            style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 6)),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
//  C Y B E R   B U T T O N  — cut‑corner neon button
// ══════════════════════════════════════════════════════════════════════════════
class CyberButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color color;
  final bool expanded;

  const CyberButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.color = Cyber.cyan,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    final off = onPressed == null;
    final c = off ? color.withOpacity(0.3) : color;
    Widget btn = CustomPaint(
      painter: _CyberBtnPainter(c),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: off ? Cyber.bg.withOpacity(0.5) : Cyber.bg,
                      size: 16),
                  const SizedBox(width: 8),
                ],
                Text(label.toUpperCase(),
                    style: TextStyle(
                        color: off ? Cyber.bg.withOpacity(0.5) : Cyber.bg,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        letterSpacing: 1.5)),
              ],
            ),
          ),
        ),
      ),
    );
    if (expanded) btn = SizedBox(width: double.infinity, child: btn);
    return btn;
  }
}

class _CyberBtnPainter extends CustomPainter {
  final Color c;
  _CyberBtnPainter(this.c);

  @override
  void paint(Canvas canvas, Size s) {
    const cut = 10.0;
    final path = Path()
      ..moveTo(cut, 0)
      ..lineTo(s.width, 0)
      ..lineTo(s.width, s.height - cut)
      ..lineTo(s.width - cut, s.height)
      ..lineTo(0, s.height)
      ..lineTo(0, cut)
      ..close();
    // glow
    canvas.drawPath(
        path,
        Paint()
          ..color = c.withOpacity(0.25)
          ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 8));
    // fill
    canvas.drawPath(path, Paint()..color = c);
  }

  @override
  bool shouldRepaint(covariant CustomPainter o) => false;
}

// ══════════════════════════════════════════════════════════════════════════════
//  N E O N   D I V I D E R
// ══════════════════════════════════════════════════════════════════════════════
class NeonDivider extends StatelessWidget {
  final Color color;
  const NeonDivider({super.key, this.color = Cyber.cyan});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.transparent,
          color.withOpacity(0.4),
          color,
          color.withOpacity(0.4),
          Colors.transparent,
        ]),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
//  T Y P I N G   T E X T  — terminal typewriter effect
// ══════════════════════════════════════════════════════════════════════════════
class TypingText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration speed;
  const TypingText(
      {super.key,
      required this.text,
      this.style,
      this.speed = const Duration(milliseconds: 40)});

  @override
  State<TypingText> createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText> {
  int _i = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(widget.speed, (_) {
      if (_i < widget.text.length) {
        setState(() => _i++);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${widget.text.substring(0, _i)}█',
      style: widget.style ??
          TextStyle(
              color: Cyber.cyan.withOpacity(0.7), fontSize: 11, letterSpacing: 1),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
//  S T A T U S   D O T
// ══════════════════════════════════════════════════════════════════════════════
class StatusDot extends StatelessWidget {
  final Color color;
  const StatusDot({super.key, this.color = Cyber.green});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [BoxShadow(color: color.withOpacity(0.6), blurRadius: 4)],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
//  C A R D   H E A D E R
// ══════════════════════════════════════════════════════════════════════════════
class CardHeader extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const CardHeader(
      {super.key,
      required this.label,
      required this.icon,
      this.color = Cyber.cyan});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Icon(icon, color: color, size: 14),
            ),
            const SizedBox(width: 10),
            Text(label,
                style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2)),
          ],
        ),
        const SizedBox(height: 8),
        NeonDivider(color: color),
      ],
    );
  }
}
