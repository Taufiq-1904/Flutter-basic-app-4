import 'dart:async';
import 'package:flutter/material.dart';

class StopwatchPage extends StatefulWidget {
  const StopwatchPage({super.key});

  @override
  State<StopwatchPage> createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  int _milliseconds = 0;
  bool _isRunning = false;
  final List<String> _laps = [];
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  void _start() {
    _timer = Timer.periodic(const Duration(milliseconds: 10), (_) {
      setState(() => _milliseconds += 10);
    });
    setState(() => _isRunning = true);
  }

  void _stop() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _milliseconds = 0;
      _isRunning = false;
      _laps.clear();
    });
  }

  void _addLap() {
    setState(() {
      _laps.insert(0, _formatTime(_milliseconds));
    });
  }

  String _formatTime(int ms) {
    final minutes = (ms ~/ 60000).toString().padLeft(2, '0');
    final seconds = ((ms % 60000) ~/ 1000).toString().padLeft(2, '0');
    final centiseconds = ((ms % 1000) ~/ 10).toString().padLeft(2, '0');
    return '$minutes:$seconds.$centiseconds';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Column(
      children: [
        // Timer display
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 40),
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(32),
            ),
          ),
          child: Column(
            children: [
              // Animated ring
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: _isRunning
                        ? AnimatedBuilder(
                            animation: _animController,
                            builder: (_, __) => CircularProgressIndicator(
                              value: (_milliseconds % 60000) / 60000,
                              strokeWidth: 6,
                              backgroundColor: Colors.white.withOpacity(0.2),
                              color: Colors.white,
                            ),
                          )
                        : CircularProgressIndicator(
                            value: (_milliseconds % 60000) / 60000,
                            strokeWidth: 6,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            color: Colors.white,
                          ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(_milliseconds),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                          fontFeatures: [FontFeature.tabularFigures()],
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isRunning ? 'Berjalan...' : 'Berhenti',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.75),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Control buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Reset
                  _CircleButton(
                    icon: Icons.refresh_rounded,
                    label: 'Reset',
                    onPressed: _reset,
                    backgroundColor: Colors.white.withOpacity(0.15),
                    foregroundColor: Colors.white,
                  ),
                  const SizedBox(width: 16),

                  // Start / Stop
                  _CircleButton(
                    icon: _isRunning
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    label: _isRunning ? 'Stop' : 'Start',
                    onPressed: _isRunning ? _stop : _start,
                    backgroundColor: Colors.white,
                    foregroundColor: color,
                    large: true,
                  ),

                  const SizedBox(width: 16),

                  // Lap
                  _CircleButton(
                    icon: Icons.flag_rounded,
                    label: 'Lap',
                    onPressed: _isRunning ? _addLap : null,
                    backgroundColor: Colors.white.withOpacity(0.15),
                    foregroundColor: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ),

        // Lap list
        Expanded(
          child: _laps.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.flag_outlined,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Tekan Lap saat stopwatch berjalan\nuntuk mencatat waktu',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[500], fontSize: 14),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'CATATAN LAP',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey[600],
                              letterSpacing: 1.2,
                            ),
                          ),
                          Text(
                            '${_laps.length} lap',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _laps.length,
                        itemBuilder: (ctx, i) {
                          final lapNum = _laps.length - i;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: color.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '$lapNum',
                                          style: TextStyle(
                                            color: color,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Lap $lapNum',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  _laps[i],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    fontFeatures: const [
                                      FontFeature.tabularFigures(),
                                    ],
                                    color: color,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final bool large;

  const _CircleButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.backgroundColor,
    required this.foregroundColor,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = large ? 72.0 : 54.0;
    final iconSize = large ? 32.0 : 24.0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: onPressed == null
              ? backgroundColor.withOpacity(0.5)
              : backgroundColor,
          shape: const CircleBorder(),
          elevation: large ? 4 : 0,
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            child: SizedBox(
              width: size,
              height: size,
              child: Icon(
                icon,
                color: onPressed == null
                    ? foregroundColor.withOpacity(0.5)
                    : foregroundColor,
                size: iconSize,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12),
        ),
      ],
    );
  }
}
