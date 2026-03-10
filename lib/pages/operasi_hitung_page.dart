import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/cyber_theme.dart';
import '../widgets/app_widgets.dart';

class OperasiHitungPage extends StatefulWidget {
  const OperasiHitungPage({super.key});
  @override
  State<OperasiHitungPage> createState() => _OperasiHitungPageState();
}

class _OperasiHitungPageState extends State<OperasiHitungPage> {
  final _ctrlA = TextEditingController();
  final _ctrlB = TextEditingController();
  double? _a, _b;

  void _hitung() {
    FocusScope.of(context).unfocus();
    final a = double.tryParse(_ctrlA.text.replaceAll(',', '.'));
    final b = double.tryParse(_ctrlB.text.replaceAll(',', '.'));
    if (a == null || b == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(children: [
            const Icon(Icons.error_outline, color: Cyber.red, size: 16),
            const SizedBox(width: 8),
            const Text('// Input harus berupa angka',
                style: TextStyle(color: Cyber.textMain, letterSpacing: 0.5)),
          ]),
          backgroundColor: Cyber.panel,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2),
              side: BorderSide(color: Cyber.red.withOpacity(0.3))),
        ),
      );
      return;
    }
    setState(() {
      _a = a;
      _b = b;
    });
  }

  void _reset() {
    setState(() {
      _ctrlA.clear();
      _ctrlB.clear();
      _a = _b = null;
    });
  }

  String _fmt(double v) => v == v.roundToDouble()
      ? v.toStringAsFixed(0)
      : v.toStringAsFixed(4).replaceAll(RegExp(r'0+$'), '');

  @override
  void dispose() {
    _ctrlA.dispose();
    _ctrlB.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CyberScaffold(
      title: 'Operasi Hitung',
      accent: Cyber.green,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 60, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Input card ──
              NeonCard(
                glowColor: Cyber.green,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CardHeader(
                        label: 'DATA INPUT',
                        icon: Icons.input_rounded,
                        color: Cyber.green),
                    const SizedBox(height: 18),

                    // Value A
                    _inputLabel('VARIABLE_A'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _ctrlA,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[\d.,\-]'))
                      ],
                      style:
                          const TextStyle(color: Cyber.textMain, letterSpacing: 1),
                      decoration: InputDecoration(
                        hintText: 'Enter value A...',
                        prefixIcon: Container(
                          width: 40,
                          alignment: Alignment.center,
                          child: Text('A',
                              style: TextStyle(
                                  color: Cyber.green,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16)),
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),

                    // Value B
                    _inputLabel('VARIABLE_B'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _ctrlB,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[\d.,\-]'))
                      ],
                      style:
                          const TextStyle(color: Cyber.textMain, letterSpacing: 1),
                      decoration: InputDecoration(
                        hintText: 'Enter value B...',
                        prefixIcon: Container(
                          width: 40,
                          alignment: Alignment.center,
                          child: Text('B',
                              style: TextStyle(
                                  color: Cyber.green,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16)),
                        ),
                      ),
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _hitung(),
                    ),
                    const SizedBox(height: 22),

                    // Buttons
                    Row(children: [
                      Expanded(
                        child: CyberButton(
                          label: 'COMPUTE',
                          icon: Icons.bolt_rounded,
                          color: Cyber.green,
                          onPressed: _hitung,
                        ),
                      ),
                      const SizedBox(width: 10),
                      OutlinedButton.icon(
                        onPressed: _reset,
                        icon:
                            const Icon(Icons.refresh_rounded, size: 15),
                        label: const Text('RESET'),
                      ),
                    ]),
                  ],
                ),
              ),

              // ── Results ──
              if (_a != null && _b != null) ...[
                const SizedBox(height: 16),
                NeonCard(
                  glowColor: Cyber.green,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CardHeader(
                          label: 'COMPUTATION OUTPUT',
                          icon: Icons.analytics_rounded,
                          color: Cyber.green),
                      const SizedBox(height: 14),

                      // Expression display
                      _exprBox('${ _fmt(_a!)} + ${_fmt(_b!)}',
                          _fmt(_a! + _b!), Cyber.green),
                      const SizedBox(height: 10),
                      _exprBox('${_fmt(_a!)} − ${_fmt(_b!)}',
                          _fmt(_a! - _b!), Cyber.cyan),

                      const SizedBox(height: 14),
                      const NeonDivider(color: Cyber.green),
                      const SizedBox(height: 12),

                      ResultTile(
                          label: 'Penjumlahan (A + B)',
                          value: _fmt(_a! + _b!),
                          color: Cyber.green),
                      ResultTile(
                          label: 'Pengurangan (A − B)',
                          value: _fmt(_a! - _b!),
                          color: Cyber.cyan),
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
          color: Cyber.green,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 2));

  Widget _exprBox(String expr, String result, Color c) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: c.withOpacity(0.04),
        border: Border.all(color: c.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(expr,
                style: TextStyle(
                    color: Cyber.textDim, fontSize: 14, letterSpacing: 0.5)),
          ),
          Row(children: [
            Text('= ',
                style: TextStyle(
                    color: c.withOpacity(0.5),
                    fontSize: 14,
                    fontWeight: FontWeight.w300)),
            Text(result,
                style: TextStyle(
                    color: c,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5)),
          ]),
        ],
      ),
    );
  }
}
