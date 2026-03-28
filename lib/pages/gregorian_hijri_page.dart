import 'package:flutter/material.dart';
import '../widgets/app_widgets.dart';

class GregorianHijriPage extends StatefulWidget {
  const GregorianHijriPage({super.key});

  @override
  State<GregorianHijriPage> createState() => _GregorianHijriPageState();
}

class _GregorianHijriPageState extends State<GregorianHijriPage> {
  DateTime? _gregorianDate;
  _HijriDate? _hijriDate;

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

  static const List<String> _hijriMonthNames = [
    'Muharram',
    'Safar',
    'Rabiul Awal',
    'Rabiul Akhir',
    'Jumadil Awal',
    'Jumadil Akhir',
    'Rajab',
    'Syaban',
    'Ramadan',
    'Syawal',
    'Dzulkaidah',
    'Dzulhijjah',
  ];

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year + 50),
      initialDate: _gregorianDate ?? now,
    );

    if (picked == null) return;

    setState(() {
      _gregorianDate = picked;
      _hijriDate = _convertGregorianToHijri(picked);
    });
  }

  _HijriDate _convertGregorianToHijri(DateTime date) {
    final jd = _gregorianToJd(date.year, date.month, date.day);
    return _jdToHijri(jd);
  }

  int _gregorianToJd(int year, int month, int day) {
    final a = (14 - month) ~/ 12;
    final y = year + 4800 - a;
    final m = month + (12 * a) - 3;

    return day +
        ((153 * m + 2) ~/ 5) +
        (365 * y) +
        (y ~/ 4) -
        (y ~/ 100) +
        (y ~/ 400) -
        32045;
  }

  _HijriDate _jdToHijri(int jd) {
    int l = jd - 1948440 + 10632;
    final n = (l - 1) ~/ 10631;
    l = l - 10631 * n + 354;

    final j =
        (((10985 - l) ~/ 5316) * ((50 * l) ~/ 17719)) +
        ((l ~/ 5670) * ((43 * l) ~/ 15238));

    l =
        l -
        (((30 - j) ~/ 15) * ((17719 * j) ~/ 50)) -
        (j ~/ 16) * ((15238 * j) ~/ 43) +
        29;

    final month = (24 * l) ~/ 709;
    final day = l - ((709 * month) ~/ 24);
    final year = 30 * n + j - 30;

    return _HijriDate(year: year, month: month, day: day);
  }

  String _formatGregorian(DateTime date) {
    return '${date.day} ${_monthNames[date.month - 1]} ${date.year}';
  }

  String _formatHijri(_HijriDate date) {
    return '${date.day} ${_hijriMonthNames[date.month - 1]} ${date.year} H';
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
                      child: Icon(Icons.swap_horiz_rounded, color: color),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Konversi Masehi ke Hijriah',
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
                  'Pilih tanggal Masehi untuk melihat padanan tanggal Hijriah.',
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
                      _gregorianDate == null
                          ? 'Pilih Tanggal Masehi'
                          : _formatGregorian(_gregorianDate!),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_gregorianDate != null && _hijriDate != null) ...[
            const SizedBox(height: 16),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hasil Konversi',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ResultTile(
                    label: 'Tanggal Masehi',
                    value: _formatGregorian(_gregorianDate!),
                    color: const Color(0xFF1565C0),
                  ),
                  ResultTile(
                    label: 'Tanggal Hijriah',
                    value: _formatHijri(_hijriDate!),
                    color: const Color(0xFF2E7D32),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Catatan: hasil konversi menggunakan perhitungan aritmetika kalender Hijriah.',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
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

class _HijriDate {
  final int year;
  final int month;
  final int day;

  const _HijriDate({
    required this.year,
    required this.month,
    required this.day,
  });
}
