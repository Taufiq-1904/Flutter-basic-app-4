import 'package:flutter/material.dart';
import '../widgets/app_widgets.dart';

class UsiaKabisatPage extends StatefulWidget {
  const UsiaKabisatPage({super.key});

  @override
  State<UsiaKabisatPage> createState() => _UsiaKabisatPageState();
}

class _UsiaKabisatPageState extends State<UsiaKabisatPage> {
  DateTime? _birthDate;
  _AgeResult? _result;

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

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: now,
      initialDate: _birthDate ?? DateTime(now.year - 20, now.month, now.day),
    );

    if (picked == null) return;

    setState(() {
      _birthDate = picked;
      _result = _calculateAge(picked, DateTime.now());
    });
  }

  _AgeResult _calculateAge(DateTime birth, DateTime now) {
    final normalizedBirth = DateTime(birth.year, birth.month, birth.day);
    final normalizedNow = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
    );

    if (normalizedNow.isBefore(normalizedBirth)) {
      return const _AgeResult(
        years: 0,
        months: 0,
        days: 0,
        hours: 0,
        minutes: 0,
      );
    }

    DateTime cursor = normalizedBirth;
    int years = 0;
    int months = 0;

    while (true) {
      final next = _addYearsSafe(cursor, 1);
      if (next.isAfter(normalizedNow)) break;
      years++;
      cursor = next;
    }

    while (true) {
      final next = _addMonthsSafe(cursor, 1);
      if (next.isAfter(normalizedNow)) break;
      months++;
      cursor = next;
    }

    final diff = normalizedNow.difference(cursor);

    return _AgeResult(
      years: years,
      months: months,
      days: diff.inDays,
      hours: diff.inHours.remainder(24),
      minutes: diff.inMinutes.remainder(60),
    );
  }

  DateTime _addYearsSafe(DateTime date, int yearsToAdd) {
    final year = date.year + yearsToAdd;
    final maxDay = DateTime(year, date.month + 1, 0).day;
    final day = date.day <= maxDay ? date.day : maxDay;
    return DateTime(year, date.month, day, date.hour, date.minute);
  }

  DateTime _addMonthsSafe(DateTime date, int monthsToAdd) {
    final totalMonths = date.month - 1 + monthsToAdd;
    final year = date.year + totalMonths ~/ 12;
    final month = totalMonths % 12 + 1;
    final maxDay = DateTime(year, month + 1, 0).day;
    final day = date.day <= maxDay ? date.day : maxDay;
    return DateTime(year, month, day, date.hour, date.minute);
  }

  bool _isLeapYear(int year) {
    if (year % 400 == 0) return true;
    if (year % 100 == 0) return false;
    return year % 4 == 0;
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
                      child: Icon(Icons.cake_rounded, color: color),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Hitung Usia dan Kabisat',
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
                  'Pilih tanggal lahir untuk menghitung usia detail.',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _pickBirthDate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.date_range_rounded),
                    label: Text(
                      _birthDate == null
                          ? 'Pilih Tanggal Lahir'
                          : _formatDate(_birthDate!),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_birthDate != null && _result != null) ...[
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
                    label: 'Usia (tahun, bulan, hari)',
                    value:
                        '${_result!.years} th ${_result!.months} bln ${_result!.days} hr',
                    color: const Color(0xFF1565C0),
                  ),
                  ResultTile(
                    label: 'Sisa waktu',
                    value: '${_result!.hours} jam ${_result!.minutes} menit',
                    color: const Color(0xFFE65100),
                  ),
                  ResultTile(
                    label: 'Tahun lahir',
                    value: _isLeapYear(_birthDate!.year)
                        ? '${_birthDate!.year} (Kabisat)'
                        : '${_birthDate!.year} (Bukan kabisat)',
                    color: const Color(0xFF2E7D32),
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

class _AgeResult {
  final int years;
  final int months;
  final int days;
  final int hours;
  final int minutes;

  const _AgeResult({
    required this.years,
    required this.months,
    required this.days,
    required this.hours,
    required this.minutes,
  });
}
