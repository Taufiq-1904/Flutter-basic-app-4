import 'package:flutter/material.dart';

class Anggota {
  final String nama;
  final String nim;
  final String peran;
  final String initials;
  final List<Color> gradientColors;

  const Anggota({
    required this.nama,
    required this.nim,
    required this.peran,
    required this.initials,
    required this.gradientColors,
  });
}

class DataKelompokPage extends StatelessWidget {
  const DataKelompokPage({super.key});

  static const List<Anggota> _anggota = [
    Anggota(
      nama: 'Taufiq Candra Kurniawan',
      nim: '123230074',
      peran: 'Controller',
      initials: 'TCK',
      gradientColors: [Color(0xFF6366F1), Color(0xFF818CF8)],
    ),
    Anggota(
      nama: 'Akmal Abrisam',
      nim: '123230084',
      peran: 'Initiator',
      initials: 'AA',
      gradientColors: [Color(0xFF06B6D4), Color(0xFF67E8F9)],
    ),
    Anggota(
      nama: 'Raffy Adrian Hidayat',
      nim: '123230125',
      peran: 'Sentinel',
      initials: 'RAH',
      gradientColors: [Color(0xFF10B981), Color(0xFF6EE7B7)],
    ),
    Anggota(
      nama: 'Athallah Joyoningrat',
      nim: '123230230',
      peran: 'Duelist',
      initials: 'AJ',
      gradientColors: [Color(0xFFF59E0B), Color(0xFFFCD34D)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Welcome banner
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primary, primary.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.groups_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Kelompok 4',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Teknologi Pemrograman Mobile',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.85),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_anggota.length} Anggota',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 28),

        Text(
          'Anggota',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 14),

        // Member cards
        ..._anggota.map((a) => _MemberCard(anggota: a)),
      ],
    );
  }
}

class _MemberCard extends StatelessWidget {
  final Anggota anggota;
  const _MemberCard({required this.anggota});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          // Profile avatar
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: anggota.gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                anggota.initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  anggota.nama,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  anggota.nim,
                  style: TextStyle(color: Colors.grey[500], fontSize: 13),
                ),
              ],
            ),
          ),

          // Role badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: anggota.gradientColors[0].withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              anggota.peran,
              style: TextStyle(
                color: anggota.gradientColors[0],
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
