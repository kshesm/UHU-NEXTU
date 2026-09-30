import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const NextUApp());
}

class NextUApp extends StatelessWidget {
  const NextUApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'NextU',
      theme: CupertinoThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFF00D2FF),
        barBackgroundColor: Color(0xCC0F111A),
        scaffoldBackgroundColor: Color(0xFF0F111A),
      ),
      home: MainTabBarView(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ==========================================
// LIQUID GLASS COMPONENT (Эффект стекла)
// ==========================================
class LiquidGlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  const LiquidGlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 22.0,
    this.padding = const EdgeInsets.all(16.0),
    this.margin = const EdgeInsets.only(bottom: 14.0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: Colors.white.withOpacity(0.18),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 25,
                  spreadRadius: -5,
                )
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

// ==========================================
// НАВИГАЦИЯ (Нижняя панель)
// ==========================================
class MainTabBarView extends StatefulWidget {
  const MainTabBarView({super.key});

  @override
  State<MainTabBarView> createState() => _MainTabBarViewState();
}

class _MainTabBarViewState extends State<MainTabBarView> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const MapTab(),
    const EventsTab(),
    const ScheduleTab(),
    const CommunityTab(),
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F111A), Color(0xFF1A1D2E), Color(0xFF0B0D15)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: IndexedStack(
            index: _selectedIndex,
            children: _pages,
          ),
        ),
        bottomNavigationBar: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (index) => setState(() => _selectedIndex = index),
              backgroundColor: const Color(0x990F111A),
              type: BottomNavigationBarType.fixed,
              selectedItemColor: const Color(0xFF00D2FF),
              unselectedItemColor: Colors.white38,
              selectedFontSize: 11,
              unselectedFontSize: 11,
              items: const [
                BottomNavigationBarItem(icon: Icon(CupertinoIcons.compass_fill), label: 'Карта'),
                BottomNavigationBarItem(icon: Icon(CupertinoIcons.calendar), label: 'События'),
                BottomNavigationBarItem(icon: Icon(CupertinoIcons.time_solid), label: 'Планы'),
                BottomNavigationBarItem(icon: Icon(CupertinoIcons.bubble_left_bubble_right_fill), label: 'Лента'),
                BottomNavigationBarItem(icon: Icon(CupertinoIcons.person_crop_circle_fill), label: 'Профиль'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 1. КАРТА
// ==========================================
class MapTab extends StatelessWidget {
  const MapTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          const SizedBox(height: 12),
          LiquidGlassContainer(
            borderRadius: 16,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: const Row(
              children: [
                Icon(CupertinoIcons.search, color: Colors.white54, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Поиск мест и событий NextU...',
                      hintStyle: TextStyle(color: Colors.white38),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: LiquidGlassContainer(
              padding: EdgeInsets.zero,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF151824),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: CustomPaint(painter: MapGridPainter()),
                    ),
                  ),
                  const Positioned(top: 100, left: 80, child: GlossyPinMarker(title: 'Хакатон NextU', icon: CupertinoIcons.sparkles, color: Color(0xFF00D2FF))),
                  const Positioned(top: 220, right: 60, child: GlossyPinMarker(title: 'Спорткомплекс', icon: CupertinoIcons.sportscourt_fill, color: Color(0xFFFF2D55))),
                  const Positioned(bottom: 120, left: 130, child: GlossyPinMarker(title: 'Лекторий BSU', icon: CupertinoIcons.book_fill, color: Color(0xFFFFCC00))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GlossyPinMarker extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const GlossyPinMarker({super.key, required this.title, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withOpacity(0.5)),
          ),
          child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
        ),
        const SizedBox(height: 4),
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [color, color.withOpacity(0.6)],
              center: const Alignment(-0.3, -0.3),
            ),
            boxShadow: [BoxShadow(color: color.withOpacity(0.5), blurRadius: 12, spreadRadius: 2)],
            border: Border.all(color: Colors.white.withOpacity(0.8), width: 1.5),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ],
    );
  }
}

class MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.04)..strokeWidth = 1.0;
    for (double i = 0; i < size.width; i += 40) canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    for (double i = 0; i < size.height; i += 40) canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ==========================================
// 2. СОБЫТИЯ
// ==========================================
class EventsTab extends StatelessWidget {
  const EventsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text('События', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
        const Text('Предстоящие встречи и лекции', style: TextStyle(color: Colors.white54, fontSize: 14)),
        const SizedBox(height: 16),
        _buildEventCard(title: 'IT-Хакатон NextU 2026', category: 'УЧЕБА', date: '5 Октября, 14:00', location: 'Минск / Онлайн', tagColor: const Color(0xFF00D2FF)),
        _buildEventCard(title: 'Открытый турнир по футболу', category: 'СПОРТ', date: '12 Октября, 11:00', location: 'Спорткомплекс Арена', tagColor: const Color(0xFFFF2D55)),
      ],
    );
  }

  Widget _buildEventCard({required String title, required String category, required String date, required String location, required Color tagColor}) {
    return LiquidGlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: tagColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: tagColor.withOpacity(0.5)),
                ),
                child: Text(category, style: TextStyle(color: tagColor, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(CupertinoIcons.clock, color: Colors.white54, size: 14),
              const SizedBox(width: 6),
              Text(date, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: CupertinoButton(
              color: const Color(0xFF007AFF),
              borderRadius: BorderRadius.circular(12),
              padding: const EdgeInsets.symmetric(vertical: 10),
              onPressed: () {},
              child: const Text('Записаться', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            ),
          )
        ],
      ),
    );
  }
}

// ==========================================
// 3. РАСПИСАНИЕ
// ==========================================
class ScheduleTab extends StatelessWidget {
  const ScheduleTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text('Расписание', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        LiquidGlassContainer(
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Октябрь 2026', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  Row(children: [Icon(CupertinoIcons.chevron_left, color: Colors.white54, size: 18), SizedBox(width: 12), Icon(CupertinoIcons.chevron_right, color: Colors.white54, size: 18)])
                ],
              ),
              const SizedBox(height: 14),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'].map((d) => Text(d, style: const TextStyle(color: Colors.white38, fontSize: 12))).toList()),
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, mainAxisSpacing: 6, crossAxisSpacing: 6),
                itemCount: 28,
                itemBuilder: (context, index) {
                  final day = index + 1;
                  final isSelected = day == 5;
                  return Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: isSelected ? const Color(0xFF007AFF) : Colors.transparent, borderRadius: BorderRadius.circular(10)),
                    child: Text('$day', style: TextStyle(color: isSelected ? Colors.white : Colors.white70, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                  );
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}

// ==========================================
// 4. СООБЩЕСТВО
// ==========================================
class CommunityTab extends StatefulWidget {
  const CommunityTab({super.key});

  @override
  State<CommunityTab> createState() => _CommunityTabState();
}

class _CommunityTabState extends State<CommunityTab> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _posts = [
    {'author': 'Алексей М.', 'time': '10 мин назад', 'text': 'Кто идет на хакатон NextU в субботу? Ищем фронтендера в команду!', 'likes': 4},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text('Сообщество', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        LiquidGlassContainer(
          child: Row(
            children: [
              Expanded(child: TextField(controller: _controller, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: 'Поделитесь новостью...', hintStyle: TextStyle(color: Colors.white38), border: InputBorder.none))),
              IconButton(
                icon: const Icon(CupertinoIcons.paperplane_fill, color: Color(0xFF00D2FF)),
                onPressed: () {
                  if (_controller.text.trim().isNotEmpty) {
                    setState(() { _posts.insert(0, {'author': 'Михаил К.', 'time': 'Только что', 'text': _controller.text, 'likes': 0}); _controller.clear(); });
                  }
                },
              )
            ],
          ),
        ),
        ..._posts.map((post) => LiquidGlassContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(post['author'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), Text(post['time'], style: const TextStyle(color: Colors.white38, fontSize: 11))]),
                  const SizedBox(height: 8), Text(post['text'], style: const TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 10), Row(children: [const Icon(CupertinoIcons.heart, color: Color(0xFF00D2FF), size: 16), const SizedBox(width: 6), Text('${post['likes']} Нравится', style: const TextStyle(color: Color(0xFF00D2FF), fontSize: 12))])
                ],
              ),
            ))
      ],
    );
  }
}

// ==========================================
// 5. ПРОФИЛЬ
// ==========================================
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        LiquidGlassContainer(
          child: Column(
            children: [
              Container(
                width: 70, height: 70,
                decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [Color(0xFFFF007A), Color(0xFF007AFF)])),
                alignment: Alignment.center,
                child: const Text('М', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 10),
              const Text('Михаил К.', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const Text('Студент • 11 класс', style: TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }
}
