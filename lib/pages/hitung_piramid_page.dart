import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/cyber_theme.dart';
import '../widgets/app_widgets.dart';

class HitungPiramidPage extends StatefulWidget {
  const HitungPiramidPage({super.key});
  @override
  State<HitungPiramidPage> createState() => _HitungPiramidPageState();
}

class _HitungPiramidPageState extends State<HitungPiramidPage> {
  final _ctrlA = TextEditingController();
  final _ctrlT = TextEditingController();
  double? _luas, _tinggi, _volume;

  void _hitung() {
    FocusScope.of(context).unfocus();
    final a = double.tryParse(_ctrlA.text.replaceAll(',', '.'));
    final t = double.tryParse(_ctrlT.text.replaceAll(',', '.'));
    if (a == null || t == null || a <= 0 || t <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(children: [
          const Icon(Icons.error_outline, color: Cyber.red, size: 16),
          const SizedBox(width: 8),
          const Text('// Nilai harus angka positif',
              style: TextStyle(color: Cyber.textMain, letterSpacing: 0.5)),
        ]),
        backgroundColor: Cyber.panel,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
            side: BorderSide(color: Cyber.red.withOpacity(0.3))),
      ));
      return;
    }
    setState(() {
      _luas = a;
      _tinggi = t;
      _volume = (1.0 / 3.0) * a * t;
    });
  }

  void _reset() => setState(() {
        _ctrlA.clear();
        _ctrlT.clear();
        _luas = _tinggi = _volume = null;
      });

  String _fmt(double v) => v == v.roundToDouble()
      ? v.toStringAsFixed(0)
      : v.toStringAsFixed(4).replaceAll(RegExp(r'0+$'), '');

  @override
  void dispose() {
    _ctrlA.dispose();
    _ctrlT.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CyberScaffold(
      title: 'Hitung Piramid',
      accent: Cyber.pink,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 60, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Formula display ──
              NeonCard(
                glowColor: Cyber.pink,
                padding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                child: Column(
                  children: [
                    Text('FORMULA',
                        style: TextStyle(
                            color: Cyber.textDim,
                            fontSize: 9,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 10),
                    HudCorners(
                      color: Cyber.pink,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w800),
                            children: [
                              TextSpan(
                                  text: 'V',
                                  style: TextStyle(color: Cyber.pink)),
                              TextSpan(
                                  text: ' = ',
                                  style:
                                      TextStyle(color: Cyber.textDim)),
                              TextSpan(
                                  text: '⅓',
                                  style: TextStyle(color: Cyber.yellow)),
                              TextSpan(
                                  text: ' × ',
                                  style:
                                      TextStyle(color: Cyber.textDim)),
                              TextSpan(
                                  text: 'A',
                                  style: TextStyle(color: Cyber.cyan)),
                              TextSpan(
                                  text: ' × ',
                                  style:
                                      TextStyle(color: Cyber.textDim)),
                              TextSpan(
                                  text: 't',
                                  style: TextStyle(color: Cyber.green)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('V = Volume  |  A = Luas Alas  |  t = Tinggi',
                        style: TextStyle(
                            color: Cyber.textDim,
                            fontSize: 10,
                            letterSpacing: 0.3),
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── Input ──
              NeonCard(
                glowColor: Cyber.pink,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CardHeader(
                        label: 'PARAMETER INPUT',
                        icon: Icons.architecture_rounded,
                        color: Cyber.pink),
                    const SizedBox(height: 18),

                    // Luas Alas
                    _inputLabel('LUAS_ALAS (A)'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _ctrlA,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[\d.,]'))
                      ],
                      style: const TextStyle(
                          color: Cyber.textMain, letterSpacing: 1),
                      decoration: InputDecoration(
                        hintText: 'Enter base area...',
                        prefixIcon: Container(
                            width: 40,
                            alignment: Alignment.center,
                            child: Text('A',
                                style: TextStyle(
                                    color: Cyber.cyan,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16))),
                        suffixText: 'cm²',
                        suffixStyle: TextStyle(
                            color: Cyber.textDim, fontSize: 12),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),

                    // Tinggi
                    _inputLabel('TINGGI (t)'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _ctrlT,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[\d.,]'))
                      ],
                      style: const TextStyle(
                          color: Cyber.textMain, letterSpacing: 1),
                      decoration: InputDecoration(
                        hintText: 'Enter height...',
                        prefixIcon: Container(
                            width: 40,
                            alignment: Alignment.center,
                            child: Text('t',
                                style: TextStyle(
                                    color: Cyber.green,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16))),
                        suffixText: 'cm',
                        suffixStyle: TextStyle(
                            color: Cyber.textDim, fontSize: 12),
                      ),
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _hitung(),
                    ),
                    const SizedBox(height: 22),
                    Row(children: [
                      Expanded(
                        child: CyberButton(
                          label: 'COMPUTE',
                          icon: Icons.bolt_rounded,
                          color: Cyber.pink,
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
              if (_volume != null) ...[
                const SizedBox(height: 16),

                // Volume display
                NeonCard(
                  glowColor: Cyber.pink,
                  padding: const EdgeInsets.symmetric(
                      vertical: 28, horizontal: 20),
                  child: Column(
                    children: [
                      Text('COMPUTED VOLUME',
                          style: TextStyle(
                              color: Cyber.textDim,
                              fontSize: 9,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      HudCorners(
                        color: Cyber.pink,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 8),
                          child: Text('${_fmt(_volume!)} cm³',
                              style: const TextStyle(
                                  color: Cyber.pink,
                                  fontSize: 34,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Detail
                NeonCard(
                  glowColor: Cyber.pink,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CardHeader(
                          label: 'COMPUTATION LOG',
                          icon: Icons.receipt_long_rounded,
                          color: Cyber.pink),
                      const SizedBox(height: 14),

                      // Expression
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Cyber.pink.withOpacity(0.04),
                          border: Border.all(
                              color: Cyber.pink.withOpacity(0.15)),
                        ),
                        child: Text(
                            'V = ⅓ × ${_fmt(_luas!)} × ${_fmt(_tinggi!)} = ${_fmt(_volume!)}',
                            style: TextStyle(
                                color: Cyber.textMain,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5),
                            textAlign: TextAlign.center),
                      ),
                      const SizedBox(height: 12),
                      ResultTile(
                          label: 'Luas Alas (A)',
                          value: '${_fmt(_luas!)} cm²',
                          color: Cyber.cyan),
                      ResultTile(
                          label: 'Tinggi (t)',
                          value: '${_fmt(_tinggi!)} cm',
                          color: Cyber.green),
                      ResultTile(
                          label: 'Volume (V)',
                          value: '${_fmt(_volume!)} cm³',
                          color: Cyber.pink),
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
          color: Cyber.pink,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 2));
}
