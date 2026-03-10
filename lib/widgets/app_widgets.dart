import 'package:flutter/material.dart';
import '../theme/cyber_theme.dart';

// ── Backward‑compatible AppCard → NeonCard ─────────────────────────────────
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  const AppCard({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) =>
      NeonCard(padding: padding, child: child);
}

// ── Result Tile ────────────────────────────────────────────────────────────
class ResultTile extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const ResultTile(
      {super.key, required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? Cyber.cyan;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: c.withOpacity(0.04),
        border: Border(left: BorderSide(color: c, width: 2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
              child: Text(label,
                  style: TextStyle(
                      color: Cyber.textDim, fontSize: 13, letterSpacing: 0.3))),
          const SizedBox(width: 12),
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: c,
                  letterSpacing: 0.5)),
        ],
      ),
    );
  }
}

// ── Section Title ──────────────────────────────────────────────────────────
class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(width: 8, height: 1.5, color: Cyber.cyan),
          const SizedBox(width: 6),
          Text(text,
              style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: Cyber.textDim,
                  letterSpacing: 2)),
        ],
      ),
    );
  }
}
