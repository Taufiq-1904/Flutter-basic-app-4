import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/cyber_theme.dart';

class StopwatchPage extends StatefulWidget {
  const StopwatchPage({super.key});
  @override
  State<StopwatchPage> createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage>
    with SingleTickerProviderStateMixin {
  final Stopwatch _sw = Stopwatch();
  late AnimationController _ringCtrl;
  final List<Duration> _laps = [];
  Duration _display = Duration.zero;

  @override
  void initState() {
    super.initState();
    _ringCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 1))
      ..addListener(_tick)
      ..repeat();
  }

  void _tick() {
    if (_sw.isRunning) setState(() => _display = _sw.elapsed);
  }

  void _startStop() {
    if (_sw.isRunning) {
      _sw.stop();
    } else {
      _sw.start();
    }
    setState(() {});
  }

  void _lap() {
    if (_sw.isRunning) {
      setState(() => _laps.insert(0, _sw.elapsed));
    }
  }

  void _reset() {
    _sw.stop();
    _sw.reset();
    setState(() {
      _display = Duration.zero;
      _laps.clear();
    });
  }

  @override
  void dispose() {
    _ringCtrl.removeListener(_tick);
    _ringCtrl.dispose();
    _sw.stop();
    super.dispose();
  }

  String _fmtDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final ms =
        (d.inMilliseconds.remainder(1000) ~/ 10).toString().padLeft(2, '0');
    return '$m:$s.$ms';
  }

  @override
  Widget build(BuildContext context) {
    final running = _sw.isRunning;
    final secs = _display.inMilliseconds / 1000.0;
    final frac = (secs % 60) / 60.0; // 0‑1 for the sweep

    return CyberScaffold(
      title: 'Stopwatch',
      accent: Cyber.yellow,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60),

            // ── Timer ring ──
            SizedBox(
              width: 240,
              height: 240,
              child: CustomPaint(
                painter: _RingPainter(
                    progress: frac,
                    color: running ? Cyber.yellow : Cyber.textDim),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _fmtDuration(_display),
                        style: TextStyle(
                          color:
                              running ? Cyber.yellow : Cyber.textMain,
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          StatusDot(
                              color: running ? Cyber.green : Cyber.red),
                          const SizedBox(width: 6),
                          Text(
                            running ? 'RUNNING' : 'STOPPED',
                            style: TextStyle(
                                color: running ? Cyber.green : Cyber.red,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),

            // ── Controls ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                children: [
                  // Reset
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _reset,
                      icon: const Icon(Icons.stop_rounded, size: 16),
                      label: const Text('RESET'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Cyber.red,
                        side: BorderSide(color: Cyber.red.withOpacity(0.3)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Start / Pause
                  Expanded(
                    flex: 2,
                    child: CyberButton(
                      label: running ? 'PAUSE' : 'START',
                      icon: running
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      color: running ? Cyber.orange : Cyber.yellow,
                      onPressed: _startStop,
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Lap
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: running ? _lap : null,
                      icon: const Icon(Icons.flag_rounded, size: 16),
                      label: const Text('LAP'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Cyber.cyan,
                        side: BorderSide(
                            color: running
                                ? Cyber.cyan.withOpacity(0.3)
                                : Cyber.border),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Laps ──
            if (_laps.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Cyber.cyan.withOpacity(0.08),
                      border:
                          Border.all(color: Cyber.cyan.withOpacity(0.25)),
                    ),
                    child: Text('LAP LOG  [${_laps.length}]',
                        style: TextStyle(
                            color: Cyber.cyan,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2)),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                      child:
                          NeonDivider(color: Cyber.cyan.withOpacity(0.25))),
                ]),
              ),
              const SizedBox(height: 8),
            ],

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _laps.length,
                itemBuilder: (_, i) {
                  final lapNum = _laps.length - i;
                  final diff = i == _laps.length - 1
                      ? _laps[i]
                      : _laps[i] - _laps[i + 1];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Cyber.panel,
                      border: Border(
                          left: BorderSide(
                              color: Cyber.cyan.withOpacity(0.4), width: 2)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Cyber.cyan.withOpacity(0.1),
                            border: Border.all(
                                color: Cyber.cyan.withOpacity(0.2)),
                          ),
                          child: Center(
                              child: Text('$lapNum',
                                  style: TextStyle(
                                      color: Cyber.cyan,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800))),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(_fmtDuration(_laps[i]),
                              style: const TextStyle(
                                  color: Cyber.textMain,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1)),
                        ),
                        Text('+${_fmtDuration(diff)}',
                            style: TextStyle(
                                color: Cyber.yellow,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Neon ring painter ──────────────────────────────────────────────────────────
class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  _RingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;

    // Track
    canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = Cyber.border
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);

    // Tick marks
    final tickPaint = Paint()
      ..color = Cyber.textDim.withOpacity(0.3)
      ..strokeWidth = 1;
    for (int i = 0; i < 60; i++) {
      final angle = (i / 60) * 2 * math.pi - math.pi / 2;
      final outer = Offset(
          center.dx + radius * math.cos(angle),
          center.dy + radius * math.sin(angle));
      final inner = Offset(
          center.dx + (radius - (i % 5 == 0 ? 8 : 4)) * math.cos(angle),
          center.dy + (radius - (i % 5 == 0 ? 8 : 4)) * math.sin(angle));
      canvas.drawLine(inner, outer,
          i % 5 == 0 ? (tickPaint..strokeWidth = 1.5) : (tickPaint..strokeWidth = 0.5));
    }

    // Progress arc
    final sweepAngle = progress * 2 * math.pi;
    final arcRect = Rect.fromCircle(center: center, radius: radius);

    // Glow
    canvas.drawArc(
        arcRect,
        -math.pi / 2,
        sweepAngle,
        false,
        Paint()
          ..color = color.withOpacity(0.15)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6
          ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 8));

    // Arc
    canvas.drawArc(
        arcRect,
        -math.pi / 2,
        sweepAngle,
        false,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round);

    // Dot at end
    if (progress > 0) {
      final endAngle = -math.pi / 2 + sweepAngle;
      final dotPos = Offset(
          center.dx + radius * math.cos(endAngle),
          center.dy + radius * math.sin(endAngle));
      canvas.drawCircle(dotPos, 4, Paint()..color = color);
      canvas.drawCircle(
          dotPos,
          7,
          Paint()
            ..color = color.withOpacity(0.3)
            ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 4));
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter o) =>
      o.progress != progress || o.color != color;
}
