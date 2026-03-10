import 'package:flutter/material.dart';
import '../theme/cyber_theme.dart';
import '../widgets/app_widgets.dart';

class JumlahTotalPage extends StatefulWidget {
  const JumlahTotalPage({super.key});
  @override
  State<JumlahTotalPage> createState() => _JumlahTotalPageState();
}

class _JumlahTotalPageState extends State<JumlahTotalPage> {
  final _ctrl = TextEditingController();
  List<double>? _nums;

  void _hitung() {
    FocusScope.of(context).unfocus();
    final raw = _ctrl.text.trim();
    if (raw.isEmpty) return;
    final parts =
        raw.split(RegExp(r'[,;\s]+')).where((s) => s.isNotEmpty).toList();
    final parsed = <double>[];
    for (final p in parts) {
      final n = double.tryParse(p.replaceAll(',', '.'));
      if (n == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(children: [
            const Icon(Icons.error_outline, color: Cyber.red, size: 16),
            const SizedBox(width: 8),
            Text('// "$p" bukan angka valid',
                style:
                    const TextStyle(color: Cyber.textMain, letterSpacing: 0.5)),
          ]),
          backgroundColor: Cyber.panel,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2),
              side: BorderSide(color: Cyber.red.withOpacity(0.3))),
        ));
        return;
      }
      parsed.add(n);
    }
    setState(() => _nums = parsed);
  }

  void _reset() => setState(() {
        _ctrl.clear();
        _nums = null;
      });

  String _fmt(double v) => v == v.roundToDouble()
      ? v.toStringAsFixed(0)
      : v.toStringAsFixed(4).replaceAll(RegExp(r'0+$'), '');

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = _nums?.fold<double>(0, (s, e) => s + e);
    final min = _nums != null
        ? _nums!.reduce((a, b) => a < b ? a : b)
        : null;
    final max = _nums != null
        ? _nums!.reduce((a, b) => a > b ? a : b)
        : null;

    return CyberScaffold(
      title: 'Jumlah Total',
      accent: Cyber.orange,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 60, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Input ──
              NeonCard(
                glowColor: Cyber.orange,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CardHeader(
                        label: 'DATA STREAM',
                        icon: Icons.dataset_rounded,
                        color: Cyber.orange),
                    const SizedBox(height: 18),
                    _inputLabel('DATA_INPUT'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _ctrl,
                      style: const TextStyle(
                          color: Cyber.textMain, letterSpacing: 1),
                      decoration: const InputDecoration(
                        hintText: 'e.g. 10 20 30  or  10,20,30',
                        prefixIcon: Icon(Icons.numbers_rounded),
                      ),
                      maxLines: 3,
                      minLines: 1,
                    ),
                    const SizedBox(height: 8),
                    Text('// Pisahkan angka dengan spasi, koma, atau titik koma',
                        style: TextStyle(
                            color: Cyber.textDim,
                            fontSize: 10,
                            letterSpacing: 0.3)),
                    const SizedBox(height: 18),
                    Row(children: [
                      Expanded(
                        child: CyberButton(
                          label: 'CALCULATE',
                          icon: Icons.functions_rounded,
                          color: Cyber.orange,
                          onPressed: _hitung,
                        ),
                      ),
                      const SizedBox(width: 10),
                      OutlinedButton.icon(
                        onPressed: _reset,
                        icon: const Icon(Icons.refresh_rounded, size: 15),
                        label: const Text('RESET'),
                      ),
                    ]),
                  ],
                ),
              ),

              // ── Results ──
              if (_nums != null && total != null) ...[
                const SizedBox(height: 16),

                // Big total display
                NeonCard(
                  glowColor: Cyber.orange,
                  padding:
                      const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
                  child: Column(
                    children: [
                      Text('TOTAL SUM',
                          style: TextStyle(
                              color: Cyber.textDim,
                              fontSize: 9,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      HudCorners(
                        color: Cyber.orange,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 28, vertical: 8),
                          child: Text(_fmt(total),
                              style: const TextStyle(
                                  color: Cyber.orange,
                                  fontSize: 38,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Stats row
                Row(children: [
                  Expanded(child: _StatBox(label: 'COUNT', value: '${_nums!.length}', color: Cyber.cyan)),
                  const SizedBox(width: 8),
                  Expanded(child: _StatBox(label: 'MIN', value: _fmt(min!), color: Cyber.green)),
                  const SizedBox(width: 8),
                  Expanded(child: _StatBox(label: 'MAX', value: _fmt(max!), color: Cyber.pink)),
                ]),
                const SizedBox(height: 12),

                // Parsed data list
                NeonCard(
                  glowColor: Cyber.orange,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CardHeader(
                          label: 'PARSED DATA',
                          icon: Icons.list_rounded,
                          color: Cyber.orange),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _nums!
                            .asMap()
                            .entries
                            .map((e) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Cyber.orange.withOpacity(0.06),
                                    border: Border.all(
                                        color: Cyber.orange.withOpacity(0.2)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('[${e.key}] ',
                                          style: TextStyle(
                                              color: Cyber.textDim,
                                              fontSize: 10,
                                              letterSpacing: 0.5)),
                                      Text(_fmt(e.value),
                                          style: const TextStyle(
                                              color: Cyber.orange,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w800)),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 14),
                      NeonDivider(color: Cyber.orange.withOpacity(0.3)),
                      const SizedBox(height: 10),
                      ResultTile(
                          label: 'Jumlah Total',
                          value: _fmt(total),
                          color: Cyber.orange),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputLabel(String t) => Text(t,
      style: TextStyle(
          color: Cyber.orange,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 2));
}

class _StatBox extends StatelessWidget {
  final String label, value;
  final Color color;
  const _StatBox(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      glowColor: color,
      cutSize: 8,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Text(label,
              style: TextStyle(
                  color: Cyber.textDim,
                  fontSize: 8,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}
