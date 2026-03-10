import 'package:flutter/material.dart';
import '../theme/cyber_theme.dart';

class Anggota {
  final String nama, nim, peran;
  final IconData icon;
  final Color color;
  const Anggota(
      {required this.nama,
      required this.nim,
      required this.peran,
      required this.icon,
      required this.color});
}

class DataKelompokPage extends StatelessWidget {
  const DataKelompokPage({super.key});

  static const _anggota = <Anggota>[
    Anggota(
        nama: 'Ahmad Rizky Pratama',
        nim: '2024001001',
        peran: 'Ketua Kelompok',
        icon: Icons.stars_rounded,
        color: Cyber.cyan),
    Anggota(
        nama: 'Siti Nurhaliza',
        nim: '2024001002',
        peran: 'Sekretaris',
        icon: Icons.edit_note_rounded,
        color: Cyber.green),
    Anggota(
        nama: 'Budi Santoso',
        nim: '2024001003',
        peran: 'Bendahara',
        icon: Icons.account_balance_wallet_rounded,
        color: Cyber.purple),
    Anggota(
        nama: 'Dewi Rahmawati',
        nim: '2024001004',
        peran: 'Anggota',
        icon: Icons.person_rounded,
        color: Cyber.orange),
  ];

  @override
  Widget build(BuildContext context) {
    return CyberScaffold(
      title: 'Data Kelompok',
      accent: Cyber.cyan,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 60, 16, 20),
          children: [
            // ── Header banner ──
            NeonCard(
              glowColor: Cyber.cyan,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Cyber.cyan.withOpacity(0.1),
                      border: Border.all(color: Cyber.cyan.withOpacity(0.3)),
                      boxShadow: [
                        BoxShadow(
                            color: Cyber.cyan.withOpacity(0.15),
                            blurRadius: 12)
                      ],
                    ),
                    child: const Icon(Icons.groups_rounded,
                        color: Cyber.cyan, size: 26),
                  ),
                  const SizedBox(height: 14),
                  const Text('KELOMPOK 1',
                      style: TextStyle(
                          color: Cyber.textMain,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 3)),
                  const SizedBox(height: 4),
                  Text('// Mata Kuliah Pemrograman Mobile',
                      style: TextStyle(
                          color: Cyber.textDim,
                          fontSize: 12,
                          letterSpacing: 0.5)),
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: Cyber.cyan.withOpacity(0.08),
                      border: Border.all(color: Cyber.cyan.withOpacity(0.25)),
                    ),
                    child: Text('${_anggota.length} MEMBERS',
                        style: TextStyle(
                            color: Cyber.cyan,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Section label ──
            Row(children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Cyber.cyan.withOpacity(0.08),
                  border: Border.all(color: Cyber.cyan.withOpacity(0.25)),
                ),
                child: Text('PERSONNEL',
                    style: TextStyle(
                        color: Cyber.cyan,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2)),
              ),
              const SizedBox(width: 8),
              Expanded(
                  child: NeonDivider(color: Cyber.cyan.withOpacity(0.25))),
            ]),
            const SizedBox(height: 14),

            // ── Member cards ──
            ..._anggota.asMap().entries.map((e) =>
                _MemberCard(anggota: e.value, index: e.key + 1)),
          ],
        ),
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  final Anggota anggota;
  final int index;
  const _MemberCard({required this.anggota, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: CustomPaint(
        painter: _MemberPainter(anggota.color),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          child: Row(
            children: [
              // Index + icon
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: anggota.color.withOpacity(0.08),
                      border:
                          Border.all(color: anggota.color.withOpacity(0.25)),
                    ),
                    child: Icon(anggota.icon, color: anggota.color, size: 22),
                  ),
                  Positioned(
                    bottom: -4,
                    right: -4,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: anggota.color,
                        boxShadow: [
                          BoxShadow(
                              color: anggota.color.withOpacity(0.4),
                              blurRadius: 6)
                        ],
                      ),
                      child: Center(
                          child: Text('$index',
                              style: const TextStyle(
                                  color: Cyber.bg,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900))),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(anggota.nama.toUpperCase(),
                        style: const TextStyle(
                            color: Cyber.textMain,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5)),
                    const SizedBox(height: 4),
                    Text('NIM: ${anggota.nim}',
                        style: TextStyle(
                            color: Cyber.textDim,
                            fontSize: 11,
                            letterSpacing: 0.5)),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: anggota.color.withOpacity(0.08),
                        border:
                            Border.all(color: anggota.color.withOpacity(0.25)),
                      ),
                      child: Text(anggota.peran.toUpperCase(),
                          style: TextStyle(
                              color: anggota.color,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MemberPainter extends CustomPainter {
  final Color accent;
  _MemberPainter(this.accent);

  @override
  void paint(Canvas canvas, Size s) {
    canvas.drawRect(
        Rect.fromLTWH(0, 0, s.width, s.height), Paint()..color = Cyber.panel);
    canvas.drawRect(
        Rect.fromLTWH(0, 0, s.width, s.height),
        Paint()
          ..color = Cyber.border
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1);
    // left accent
    canvas.drawRect(
        Rect.fromLTWH(0, 0, 3, s.height), Paint()..color = accent);
    canvas.drawRect(
        Rect.fromLTWH(0, 0, 3, s.height),
        Paint()
          ..color = accent.withOpacity(0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 4));
  }

  @override
  bool shouldRepaint(covariant CustomPainter o) => false;
}
