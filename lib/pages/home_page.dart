import 'package:flutter/material.dart';
import '../theme/cyber_theme.dart';
import 'data_kelompok_page.dart';
import 'operasi_hitung_page.dart';
import 'cek_bilangan_page.dart';
import 'jumlah_total_page.dart';
import 'stopwatch_page.dart';
import 'hitung_piramid_page.dart';
import 'login_page.dart';

class _MenuData {
  final String title, subtitle, code;
  final IconData icon;
  final Color color;
  final Widget page;
  const _MenuData(
      {required this.title,
      required this.subtitle,
      required this.code,
      required this.icon,
      required this.color,
      required this.page});
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _stagger;

  static final _items = <_MenuData>[
    _MenuData(
        title: 'Data Kelompok',
        subtitle: 'Team member database',
        code: 'MOD_01',
        icon: Icons.group_rounded,
        color: Cyber.cyan,
        page: const DataKelompokPage()),
    _MenuData(
        title: 'Operasi Hitung',
        subtitle: 'Arithmetic processor',
        code: 'MOD_02',
        icon: Icons.calculate_rounded,
        color: Cyber.green,
        page: const OperasiHitungPage()),
    _MenuData(
        title: 'Cek Bilangan',
        subtitle: 'Number analysis',
        code: 'MOD_03',
        icon: Icons.search_rounded,
        color: Cyber.purple,
        page: const CekBilanganPage()),
    _MenuData(
        title: 'Jumlah Total',
        subtitle: 'Sum calculator',
        code: 'MOD_04',
        icon: Icons.functions_rounded,
        color: Cyber.orange,
        page: const JumlahTotalPage()),
    _MenuData(
        title: 'Stopwatch',
        subtitle: 'Chrono tracker',
        code: 'MOD_05',
        icon: Icons.timer_rounded,
        color: Cyber.yellow,
        page: const StopwatchPage()),
    _MenuData(
        title: 'Hitung Piramid',
        subtitle: 'Volume calculator',
        code: 'MOD_06',
        icon: Icons.change_history_rounded,
        color: Cyber.pink,
        page: const HitungPiramidPage()),
  ];

  @override
  void initState() {
    super.initState();
    _stagger = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..forward();
  }

  @override
  void dispose() {
    _stagger.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CyberScaffold(
      showBack: false,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 16, 0),
              child: Column(
                children: [
                  // Status bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        const StatusDot(color: Cyber.green),
                        const SizedBox(width: 6),
                        Text('SYS_STATUS: ONLINE',
                            style: TextStyle(
                                color: Cyber.green,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5)),
                      ]),
                      Text('v3.0.26',
                          style: TextStyle(
                              color: Cyber.textDim,
                              fontSize: 9,
                              letterSpacing: 1)),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // User row
                  Row(
                    children: [
                      // Avatar with HUD corners
                      _CyberAvatar(),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('WELCOME, ADMIN',
                                style: TextStyle(
                                    color: Cyber.textMain,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 2)),
                            const SizedBox(height: 3),
                            Text('// Select module to proceed',
                                style: TextStyle(
                                    color: Cyber.textDim,
                                    fontSize: 11,
                                    letterSpacing: 0.5)),
                          ],
                        ),
                      ),
                      // Logout
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _logout(context),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Cyber.red.withOpacity(0.3))),
                            child: const Icon(Icons.logout_rounded,
                                color: Cyber.red, size: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const NeonDivider(),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // ── Modules label ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Cyber.cyan.withOpacity(0.08),
                      border: Border.all(color: Cyber.cyan.withOpacity(0.25)),
                    ),
                    child: Text('MODULES',
                        style: TextStyle(
                            color: Cyber.cyan,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2)),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                      child:
                          NeonDivider(color: Cyber.cyan.withOpacity(0.25))),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ── Grid ──
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: GridView.builder(
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: _items.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.95,
                  ),
                  itemBuilder: (_, i) {
                    final delay = i * 0.12;
                    return AnimatedBuilder(
                      animation: _stagger,
                      builder: (_, child) {
                        final t = Curves.easeOutCubic.transform(
                            (_stagger.value - delay).clamp(0.0, 1.0));
                        return Opacity(
                          opacity: t,
                          child: Transform.translate(
                              offset: Offset(0, 24 * (1 - t)), child: child),
                        );
                      },
                      child: _ModuleCard(data: _items[i]),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logout(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (c) => AlertDialog(
        backgroundColor: Cyber.panel,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
          side: BorderSide(color: Cyber.red.withOpacity(0.3)),
        ),
        title: Row(children: [
          const Icon(Icons.warning_amber_rounded, color: Cyber.red, size: 20),
          const SizedBox(width: 8),
          const Text('CONFIRM DISCONNECT',
              style: TextStyle(
                  color: Cyber.textMain, fontSize: 13, letterSpacing: 1.5)),
        ]),
        content: Text('// Terminate current session?',
            style: TextStyle(color: Cyber.textDim, fontSize: 13)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(c),
              child: Text('CANCEL',
                  style:
                      TextStyle(color: Cyber.textDim, letterSpacing: 1.5))),
          CyberButton(
            label: 'DISCONNECT',
            icon: Icons.logout_rounded,
            color: Cyber.red,
            expanded: false,
            onPressed: () {
              Navigator.pop(c);
              Navigator.pushReplacement(
                  ctx,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const LoginPage(),
                    transitionsBuilder: (_, a, __, ch) =>
                        FadeTransition(opacity: a, child: ch),
                    transitionDuration: const Duration(milliseconds: 400),
                  ));
            },
          ),
        ],
      ),
    );
  }
}

// ── Cyber avatar ───────────────────────────────────────────────────────────────
class _CyberAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Cyber.surface,
        border: Border.all(color: Cyber.cyan.withOpacity(0.25)),
      ),
      child: Stack(
        children: [
          const Center(
              child: Icon(Icons.person_rounded, color: Cyber.cyan, size: 22)),
          _cornerMark(true, true),
          _cornerMark(true, false),
          _cornerMark(false, true),
          _cornerMark(false, false),
        ],
      ),
    );
  }

  Widget _cornerMark(bool top, bool left) {
    return Positioned(
      top: top ? 0 : null,
      bottom: top ? null : 0,
      left: left ? 0 : null,
      right: left ? null : 0,
      child: Container(
        width: 5,
        height: 5,
        decoration: BoxDecoration(
          border: Border(
            top: top
                ? const BorderSide(color: Cyber.cyan, width: 1)
                : BorderSide.none,
            bottom: !top
                ? const BorderSide(color: Cyber.cyan, width: 1)
                : BorderSide.none,
            left: left
                ? const BorderSide(color: Cyber.cyan, width: 1)
                : BorderSide.none,
            right: !left
                ? const BorderSide(color: Cyber.cyan, width: 1)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}

// ── Module card ────────────────────────────────────────────────────────────────
class _ModuleCard extends StatelessWidget {
  final _MenuData data;
  const _ModuleCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => data.page,
              transitionsBuilder: (_, a, __, c) =>
                  FadeTransition(opacity: a, child: c),
              transitionDuration: const Duration(milliseconds: 300),
            )),
        child: CustomPaint(
          painter: _CardPainter(data.color),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  // Code tag
                  Text(data.code,
                      style: TextStyle(
                          color: data.color,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2)),
                  const SizedBox(height: 10),
                  // Icon
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: data.color.withOpacity(0.08),
                      border: Border.all(color: data.color.withOpacity(0.2)),
                    ),
                    child: Icon(data.icon, color: data.color, size: 18),
                  ),
                ]),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(data.title.toUpperCase(),
                      style: const TextStyle(
                          color: Cyber.textMain,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 3),
                  Text('// ${data.subtitle}',
                      style: TextStyle(
                          color: Cyber.textDim,
                          fontSize: 9,
                          letterSpacing: 0.3),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CardPainter extends CustomPainter {
  final Color accent;
  _CardPainter(this.accent);

  @override
  void paint(Canvas canvas, Size s) {
    // fill
    canvas.drawRect(Rect.fromLTWH(0, 0, s.width, s.height),
        Paint()..color = Cyber.panel);
    // border
    canvas.drawRect(
        Rect.fromLTWH(0, 0, s.width, s.height),
        Paint()
          ..color = Cyber.border
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1);
    // left accent bar
    canvas.drawRect(
        Rect.fromLTWH(0, 0, 3, s.height), Paint()..color = accent);
    // left accent glow
    canvas.drawRect(
        Rect.fromLTWH(0, 0, 3, s.height),
        Paint()
          ..color = accent.withOpacity(0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 6));
    // top‑right corner mark
    final cp = Paint()
      ..color = accent.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawLine(Offset(s.width - 12, 0), Offset(s.width, 0), cp);
    canvas.drawLine(Offset(s.width, 0), Offset(s.width, 12), cp);
    // bottom‑right corner mark
    canvas.drawLine(
        Offset(s.width, s.height - 12), Offset(s.width, s.height), cp);
    canvas.drawLine(
        Offset(s.width - 12, s.height), Offset(s.width, s.height), cp);
  }

  @override
  bool shouldRepaint(covariant CustomPainter o) => false;
}
