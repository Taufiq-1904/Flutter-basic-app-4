import 'package:flutter/material.dart';

class Anggota {
  final String nama;
  final String nim;
  final String peran;
  final IconData icon;
  final Color color;

  const Anggota({
    required this.nama,
    required this.nim,
    required this.peran,
    required this.icon,
    required this.color,
  });
}

class DataKelompokPage extends StatelessWidget {
  const DataKelompokPage({super.key});

  static const List<Anggota> _anggota = [
    Anggota(
      nama: 'Ahmad Rizky Pratama',
      nim: '2024001001',
      peran: 'Ketua Kelompok',
      icon: Icons.stars_rounded,
      color: Color(0xFF1565C0),
    ),
    Anggota(
      nama: 'Siti Nurhaliza',
      nim: '2024001002',
      peran: 'Sekretaris',
      icon: Icons.edit_note_rounded,
      color: Color(0xFF2E7D32),
    ),
    Anggota(
      nama: 'Budi Santoso',
      nim: '2024001003',
      peran: 'Bendahara',
      icon: Icons.account_balance_wallet_rounded,
      color: Color(0xFF6A1B9A),
    ),
    Anggota(
      nama: 'Dewi Rahmawati',
      nim: '2024001004',
      peran: 'Anggota',
      icon: Icons.person_rounded,
      color: Color(0xFFE65100),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Data Kelompok',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFF1565C0), const Color(0xFF1976D2)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Icon(Icons.groups_rounded, color: Colors.white, size: 48),
                const SizedBox(height: 10),
                const Text(
                  'Kelompok 1',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Mata Kuliah Pemrograman Mobile',
                  style: TextStyle(color: Colors.white.withOpacity(0.85)),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_anggota.length} Anggota',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'DAFTAR ANGGOTA',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.grey[600],
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          ..._anggota.asMap().entries.map((entry) {
            final idx = entry.key;
            final anggota = entry.value;
            return _AnggotaCard(anggota: anggota, nomor: idx + 1);
          }),
        ],
      ),
    );
  }
}

class _AnggotaCard extends StatelessWidget {
  final Anggota anggota;
  final int nomor;

  const _AnggotaCard({required this.anggota, required this.nomor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: anggota.color.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: anggota.color.withOpacity(0.12),
              child: Icon(anggota.icon, color: anggota.color, size: 26),
            ),
            Positioned(
              bottom: -2,
              right: -2,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: anggota.color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Center(
                  child: Text(
                    '$nomor',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        title: Text(
          anggota.nama,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(
              'NIM: ${anggota.nim}',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: anggota.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                anggota.peran,
                style: TextStyle(
                  color: anggota.color,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
