import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/app_widgets.dart';

class HitungPiramidPage extends StatefulWidget {
  const HitungPiramidPage({super.key});

  @override
  State<HitungPiramidPage> createState() => _HitungPiramidPageState();
}

class _HitungPiramidPageState extends State<HitungPiramidPage> {
  final _alasCtrl = TextEditingController();
  final _tinggiCtrl = TextEditingController();
  double? _volume;
  bool _dihitung = false;

  void _hitung() {
    final alas = double.tryParse(_alasCtrl.text);
    final tinggi = double.tryParse(_tinggiCtrl.text);

    if (alas == null || tinggi == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan angka yang valid!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (alas <= 0 || tinggi <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Luas alas dan tinggi harus lebih dari 0!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _volume = (1 / 3) * alas * tinggi;
      _dihitung = true;
    });
  }

  void _reset() {
    _alasCtrl.clear();
    _tinggiCtrl.clear();
    setState(() {
      _volume = null;
      _dihitung = false;
    });
  }

  String _formatAngka(double val) {
    if (val == val.truncateToDouble()) return val.toInt().toString();
    return val.toStringAsFixed(6).replaceAll(RegExp(r'0+$'), '');
  }

  @override
  void dispose() {
    _alasCtrl.dispose();
    _tinggiCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Rumus card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFC62828), Color(0xFFD32F2F)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.change_history_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Rumus Volume Piramid',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'V = ⅓ × Luas Alas × Tinggi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.input_rounded, color: color),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Masukkan Dimensi',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Luas Alas
                TextFormField(
                  controller: _alasCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]')),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Luas Alas',
                    hintText: 'Masukkan luas alas (satuan²)',
                    prefixIcon: const Icon(Icons.square_foot_rounded),
                    suffixText: 'satuan²',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  onChanged: (_) => setState(() => _dihitung = false),
                ),
                const SizedBox(height: 16),

                // Tinggi
                TextFormField(
                  controller: _tinggiCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]')),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Tinggi',
                    hintText: 'Masukkan tinggi piramid (satuan)',
                    prefixIcon: const Icon(Icons.height_rounded),
                    suffixText: 'satuan',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _hitung(),
                  onChanged: (_) => setState(() => _dihitung = false),
                ),

                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _hitung,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.calculate_rounded),
                        label: const Text('Hitung Volume'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: _reset,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Reset'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          if (_dihitung && _volume != null) ...[
            const SizedBox(height: 16),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.bar_chart_rounded, color: color),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Hasil Perhitungan',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Langkah perhitungan
                  const SectionTitle('LANGKAH PERHITUNGAN'),
                  ResultTile(
                    label: 'Luas Alas (A)',
                    value: '${_alasCtrl.text} satuan²',
                    color: const Color(0xFF1565C0),
                  ),
                  ResultTile(
                    label: 'Tinggi (t)',
                    value: '${_tinggiCtrl.text} satuan',
                    color: const Color(0xFF2E7D32),
                  ),
                  ResultTile(
                    label: '⅓ × ${_alasCtrl.text} × ${_tinggiCtrl.text}',
                    value: _formatAngka(_volume!),
                    color: color,
                  ),

                  const SizedBox(height: 12),

                  // Volume besar
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color.withOpacity(0.12),
                          color.withOpacity(0.04),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: color.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'VOLUME PIRAMID',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              _formatAngka(_volume!),
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'satuan³',
                            style: TextStyle(
                              color: color.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
