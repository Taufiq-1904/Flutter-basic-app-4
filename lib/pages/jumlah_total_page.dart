import 'package:flutter/material.dart';
import '../widgets/app_widgets.dart';

class JumlahTotalPage extends StatefulWidget {
  const JumlahTotalPage({super.key});

  @override
  State<JumlahTotalPage> createState() => _JumlahTotalPageState();
}

class _JumlahTotalPageState extends State<JumlahTotalPage> {
  final _ctrl = TextEditingController();
  double? _total;
  List<double> _angkaList = [];
  bool _dihitung = false;

  void _hitung() {
    final input = _ctrl.text.trim();
    if (input.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan setidaknya satu angka!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Pisahkan dengan spasi atau koma
    final parts = input
        .split(RegExp(r'[\s,]+'))
        .where((s) => s.isNotEmpty)
        .toList();

    final List<double> parsed = [];
    final List<String> invalid = [];

    for (final p in parts) {
      final val = double.tryParse(p);
      if (val != null) {
        parsed.add(val);
      } else {
        invalid.add(p);
      }
    }

    if (invalid.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Input tidak valid: ${invalid.join(', ')}'),
          backgroundColor: Colors.orange,
        ),
      );
      if (parsed.isEmpty) return;
    }

    setState(() {
      _angkaList = parsed;
      _total = parsed.fold<double>(0.0, (sum, val) => sum + val);
      _dihitung = true;
    });
  }

  void _reset() {
    _ctrl.clear();
    setState(() {
      _total = null;
      _angkaList = [];
      _dihitung = false;
    });
  }

  String _formatAngka(double val) {
    if (val == val.truncateToDouble()) return val.toInt().toString();
    return val.toStringAsFixed(4).replaceAll(RegExp(r'0+$'), '');
  }

  @override
  void dispose() {
    _ctrl.dispose();
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
                      child: Icon(Icons.functions_rounded, color: color),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Masukkan Angka-Angka',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Pisahkan angka dengan spasi atau koma',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _ctrl,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    labelText: 'Daftar angka',
                    hintText: 'Contoh: 10 20 30 atau 10, 20, 30',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (_) => setState(() => _dihitung = false),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _hitung,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.add_circle_outline_rounded),
                        label: const Text('Hitung Total'),
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
          if (_dihitung && _total != null) ...[
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

                  // Stats row
                  Row(
                    children: [
                      _StatBox(
                        label: 'Jumlah Data',
                        value: '${_angkaList.length}',
                        color: color,
                      ),
                      const SizedBox(width: 10),
                      _StatBox(
                        label: 'Nilai Min',
                        value: _formatAngka(
                          _angkaList.reduce((a, b) => a < b ? a : b),
                        ),
                        color: const Color(0xFF1565C0),
                      ),
                      const SizedBox(width: 10),
                      _StatBox(
                        label: 'Nilai Max',
                        value: _formatAngka(
                          _angkaList.reduce((a, b) => a > b ? a : b),
                        ),
                        color: const Color(0xFF2E7D32),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Total
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color.withOpacity(0.12),
                          color.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: color.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'TOTAL KESELURUHAN',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          _formatAngka(_total!),
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (_angkaList.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const SectionTitle('ANGKA YANG DIPROSES'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _angkaList.map((val) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: color.withOpacity(0.25)),
                          ),
                          child: Text(
                            _formatAngka(val),
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatBox({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
