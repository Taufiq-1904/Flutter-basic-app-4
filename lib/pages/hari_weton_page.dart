import 'package:flutter/material.dart';
import '../widgets/app_widgets.dart';

class HariWetonPage extends StatefulWidget {
  const HariWetonPage({super.key});

  @override
  State<HariWetonPage> createState() => _HariWetonPageState();
}

class _HariWetonPageState extends State<HariWetonPage> {
  DateTime? _selectedDate;
  String? _weekday;
  String? _pasaran;

  static const List<String> _weekdayNames = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  static const List<String> _pasaranNames = [
    'Legi',
    'Pahing',
    'Pon',
    'Wage',
    'Kliwon',
  ];

  static const List<String> _monthNames = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year + 50),
      initialDate: _selectedDate ?? now,
    );

    if (picked == null) return;

    final weekday = _weekdayNames[picked.weekday - 1];
    final pasaran = _getPasaran(picked);

    setState(() {
      _selectedDate = picked;
      _weekday = weekday;
      _pasaran = pasaran;
    });
  }

  String _getPasaran(DateTime date) {
    final onlyDate = DateTime(date.year, date.month, date.day);

    // 17 Agustus 1945 dikenal sebagai Jumat Legi.
    final referenceDate = DateTime(1945, 8, 17);
    final dayDiff = onlyDate.difference(referenceDate).inDays;
    final index = ((dayDiff % 5) + 5) % 5;
    return _pasaranNames[index];
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_monthNames[date.month - 1]} ${date.year}';
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
                      child: Icon(Icons.calendar_today_rounded, color: color),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Cek Hari dan Weton',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Pilih tanggal, lalu aplikasi menampilkan hari dan weton Jawa.',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _pickDate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.date_range_rounded),
                    label: Text(
                      _selectedDate == null
                          ? 'Pilih Tanggal'
                          : _formatDate(_selectedDate!),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_selectedDate != null &&
              _weekday != null &&
              _pasaran != null) ...[
            const SizedBox(height: 16),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hasil',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ResultTile(
                    label: 'Hari',
                    value: _weekday!,
                    color: const Color(0xFF1565C0),
                  ),
                  ResultTile(
                    label: 'Pasaran',
                    value: _pasaran!,
                    color: const Color(0xFF2E7D32),
                  ),
                  ResultTile(
                    label: 'Weton',
                    value: '$_weekday $_pasaran',
                    color: const Color(0xFF6A1B9A),
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
