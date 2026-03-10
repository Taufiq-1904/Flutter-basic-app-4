import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/app_widgets.dart';

class CekBilanganPage extends StatefulWidget {
  const CekBilanganPage({super.key});

  @override
  State<CekBilanganPage> createState() => _CekBilanganPageState();
}

class _CekBilanganPageState extends State<CekBilanganPage> {
  final _ctrl = TextEditingController();
  int? _angka;
  bool _dihitung = false;

  bool _isGanjil(int n) => n % 2 != 0;

  bool _isPrima(int n) {
    if (n < 2) return false;
    if (n == 2) return true;
    if (n % 2 == 0) return false;
    for (int i = 3; i * i <= n; i += 2) {
      if (n % i == 0) return false;
    }
    return true;
  }

  void _cek() {
    final val = int.tryParse(_ctrl.text);
    if (val == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan bilangan bulat yang valid!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() {
      _angka = val;
      _dihitung = true;
    });
  }

  void _reset() {
    _ctrl.clear();
    setState(() {
      _angka = null;
      _dihitung = false;
    });
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
                      child: Icon(Icons.search_rounded, color: color),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Masukkan Bilangan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _ctrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    signed: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9\-]')),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Masukkan angka',
                    hintText: 'Contoh: 7, 12, 100',
                    prefixIcon: const Icon(Icons.tag_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (_) => setState(() => _dihitung = false),
                  onFieldSubmitted: (_) => _cek(),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _cek,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.search_rounded),
                        label: const Text('Cek Bilangan'),
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
          if (_dihitung && _angka != null) ...[
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
                        child: Icon(Icons.fact_check_rounded, color: color),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Hasil Cek Angka: ${_angka}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Ganjil / Genap
                  _StatusBadge(
                    label: _isGanjil(_angka!)
                        ? '${_angka} adalah BILANGAN GANJIL'
                        : '${_angka} adalah BILANGAN GENAP',
                    isPositive: _isGanjil(_angka!),
                    trueColor: const Color(0xFF1565C0),
                    falseColor: const Color(0xFF2E7D32),
                    icon: Icons.exposure_neg_1_rounded,
                  ),

                  const SizedBox(height: 10),

                  // Prima / Bukan Prima
                  _StatusBadge(
                    label: _isPrima(_angka!)
                        ? '${_angka} adalah BILANGAN PRIMA'
                        : '${_angka} BUKAN bilangan prima',
                    isPositive: _isPrima(_angka!),
                    trueColor: const Color(0xFF6A1B9A),
                    falseColor: Colors.grey.shade700,
                    icon: Icons.star_rounded,
                  ),

                  const SizedBox(height: 16),

                  // Info tambahan
                  if (!_isPrima(_angka!) && _angka! >= 2) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ℹ️ Info Tambahan',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_angka} bukan bilangan prima karena memiliki faktor selain 1 dan dirinya sendiri.',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (_angka! < 2) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Text(
                        'ℹ️ Bilangan prima dimulai dari 2. Angka ${_angka} tidak termasuk bilangan prima.',
                        style: TextStyle(
                          color: Colors.orange.shade800,
                          fontSize: 13,
                        ),
                      ),
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

class _StatusBadge extends StatelessWidget {
  final String label;
  final bool isPositive;
  final Color trueColor;
  final Color falseColor;
  final IconData icon;

  const _StatusBadge({
    required this.label,
    required this.isPositive,
    required this.trueColor,
    required this.falseColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final color = isPositive ? trueColor : falseColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          Icon(
            isPositive ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: color,
            size: 20,
          ),
        ],
      ),
    );
  }
}
