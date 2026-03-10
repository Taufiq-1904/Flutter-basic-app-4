import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/cyber_theme.dart';
import '../widgets/app_widgets.dart';

class CekBilanganPage extends StatefulWidget {
  const CekBilanganPage({super.key});
  @override
  State<CekBilanganPage> createState() => _CekBilanganPageState();
}

class _CekBilanganPageState extends State<CekBilanganPage> {
  final _ctrl = TextEditingController();
  int? _num;

  bool get _isEven => _num != null && _num! % 2 == 0;
  bool get _isPrime {
    if (_num == null || _num! < 2) return false;
    for (int i = 2; i * i <= _num!; i++) {
      if (_num! % i == 0) return false;
    }
    return true;
  }

  void _cek() {
    FocusScope.of(context).unfocus();
    final n = int.tryParse(_ctrl.text.trim());
    if (n == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(children: [
          const Icon(Icons.error_outline, color: Cyber.red, size: 16),
          const SizedBox(width: 8),
          const Text('// Input harus berupa bilangan bulat',
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
    setState(() => _num = n);
  }

  void _reset() => setState(() {
        _ctrl.clear();
        _num = null;
      });

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CyberScaffold(
      title: 'Cek Bilangan',
      accent: Cyber.purple,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 60, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Input ──
              NeonCard(
                glowColor: Cyber.purple,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CardHeader(
                        label: 'NUMBER SCANNER',
                        icon: Icons.radar_rounded,
                        color: Cyber.purple),
                    const SizedBox(height: 18),
                    _inputLabel('TARGET_NUMBER'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _ctrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[\d\-]'))
                      ],
                      style: const TextStyle(
                          color: Cyber.textMain, letterSpacing: 1),
                      decoration: const InputDecoration(
                        hintText: 'Enter integer...',
                        prefixIcon: Icon(Icons.tag_rounded),
                      ),
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _cek(),
                    ),
                    const SizedBox(height: 22),
                    Row(children: [
                      Expanded(
                        child: CyberButton(
                          label: 'ANALYZE',
                          icon: Icons.search_rounded,
                          color: Cyber.purple,
                          onPressed: _cek,
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
              if (_num != null) ...[
                const SizedBox(height: 16),

                // Big number display
                NeonCard(
                  glowColor: Cyber.purple,
                  padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
                  child: Column(
                    children: [
                      Text('SCANNED VALUE',
                          style: TextStyle(
                              color: Cyber.textDim,
                              fontSize: 9,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      HudCorners(
                        color: Cyber.purple,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          child: Text('$_num',
                              style: TextStyle(
                                  color: Cyber.purple,
                                  fontSize: 40,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 3)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Analysis badges
                Row(children: [
                  Expanded(
                      child:
                          _Badge(label: 'PARITY', value: _isEven ? 'GENAP' : 'GANJIL', color: _isEven ? Cyber.cyan : Cyber.orange, icon: _isEven ? Icons.view_stream_rounded : Icons.view_column_rounded)),
                  const SizedBox(width: 10),
                  Expanded(
                      child:
                          _Badge(label: 'PRIMALITY', value: _isPrime ? 'PRIMA' : 'BUKAN PRIMA', color: _isPrime ? Cyber.green : Cyber.red, icon: _isPrime ? Icons.verified_rounded : Icons.cancel_rounded)),
                ]),
                const SizedBox(height: 12),

                // Detail results
                NeonCard(
                  glowColor: Cyber.purple,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CardHeader(
                          label: 'ANALYSIS REPORT',
                          icon: Icons.description_rounded,
                          color: Cyber.purple),
                      const SizedBox(height: 14),
                      ResultTile(
                          label: 'Bilangan',
                          value: '$_num',
                          color: Cyber.purple),
                      ResultTile(
                          label: 'Ganjil / Genap',
                          value: _isEven ? 'Genap' : 'Ganjil',
                          color: _isEven ? Cyber.cyan : Cyber.orange),
                      ResultTile(
                          label: 'Bilangan Prima',
                          value: _isPrime ? 'Ya' : 'Tidak',
                          color: _isPrime ? Cyber.green : Cyber.red),
                      if (_num! > 0) ResultTile(
                          label: 'Positif / Negatif',
                          value: 'Positif',
                          color: Cyber.green)
                      else if (_num! < 0) ResultTile(
                          label: 'Positif / Negatif',
                          value: 'Negatif',
                          color: Cyber.red)
                      else ResultTile(
                          label: 'Positif / Negatif',
                          value: 'Nol',
                          color: Cyber.textDim),
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
          color: Cyber.purple,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 2));
}

// ── Badge card ─────────────────────────────────────────────────────────────────
class _Badge extends StatelessWidget {
  final String label, value;
  final Color color;
  final IconData icon;
  const _Badge(
      {required this.label,
      required this.value,
      required this.color,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      glowColor: color,
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(color: color.withOpacity(0.15), blurRadius: 8)
              ],
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 10),
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
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
