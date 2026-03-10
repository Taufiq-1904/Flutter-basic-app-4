import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/app_widgets.dart';

class OperasiHitungPage extends StatefulWidget {
  const OperasiHitungPage({super.key});

  @override
  State<OperasiHitungPage> createState() => _OperasiHitungPageState();
}

class _OperasiHitungPageState extends State<OperasiHitungPage> {
  final _aCtrl = TextEditingController();
  final _bCtrl = TextEditingController();
  double? hasil_tambah;
  double? hasil_kurang;
  bool _dihitung = false;

  void _hitung() {
    final a = double.tryParse(_aCtrl.text);
    final b = double.tryParse(_bCtrl.text);
    if (a == null || b == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan angka yang valid!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() {
      hasil_tambah = a + b;
      hasil_kurang = a - b;
      _dihitung = true;
    });
  }

  void _reset() {
    _aCtrl.clear();
    _bCtrl.clear();
    setState(() {
      hasil_tambah = null;
      hasil_kurang = null;
      _dihitung = false;
    });
  }

  String _formatAngka(double val) {
    if (val == val.truncate()) {
      return val.truncate().toString();
    }
    return val.toStringAsFixed(4).replaceAll(RegExp(r'0+$'), '');
  }

  @override
  void dispose() {
    _aCtrl.dispose();
    _bCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = const Color(0xFF2E7D32);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Penjumlahan & Pengurangan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
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
                        child: Icon(Icons.input_rounded, color: color),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Masukkan Dua Angka',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _aCtrl,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9\.\-]'),
                            ),
                          ],
                          decoration: InputDecoration(
                            labelText: 'Angka A',
                            prefixIcon: const Icon(Icons.looks_one_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onChanged: (_) => setState(() => _dihitung = false),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _bCtrl,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9\.\-]'),
                            ),
                          ],
                          decoration: InputDecoration(
                            labelText: 'Angka B',
                            prefixIcon: const Icon(Icons.looks_two_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onChanged: (_) => setState(() => _dihitung = false),
                        ),
                      ),
                    ],
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
                          label: const Text('Hitung'),
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
            if (_dihitung && hasil_tambah != null) ...[
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
                    ResultTile(
                      label: '${_aCtrl.text} + ${_bCtrl.text}',
                      value: _formatAngka(hasil_tambah!),
                      color: const Color(0xFF1565C0),
                    ),
                    ResultTile(
                      label: '${_aCtrl.text} − ${_bCtrl.text}',
                      value: _formatAngka(hasil_kurang!),
                      color: const Color(0xFFE65100),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
