import 'package:flutter/material.dart';
import '../main.dart';
import 'category_screen.dart';

class ResultScreen extends StatelessWidget {
  final String category;
  final int total;
  final int correct;
  final int wrong;

  const ResultScreen({
    super.key,
    required this.category,
    required this.total,
    required this.correct,
    required this.wrong,
  });

  @override
  Widget build(BuildContext context) {
    final percent = total == 0 ? 0 : (correct / total * 100).round();
    final message = percent >= 80
        ? 'Excellent work!'
        : percent >= 60
            ? 'Great job!'
            : 'Keep practicing!';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFE9A8), Color(0xFFFFC95C)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x20F5B301),
                      blurRadius: 28,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                child: const Icon(Icons.emoji_events_rounded, size: 66, color: Color(0xFF8A5A00)),
              ),
              const SizedBox(height: 22),
              Text(
                message,
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 5),
              Text(category, style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
              const SizedBox(height: 25),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: const Color(0xFFE7E9EF)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0C000000),
                      blurRadius: 22,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      '$percent%',
                      style: const TextStyle(
                        fontSize: 64,
                        height: 1,
                        fontWeight: FontWeight.w900,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _stat('Correct', correct, const Color(0xFFD7F2EC))),
                        const SizedBox(width: 10),
                        Expanded(child: _stat('Wrong', wrong, const Color(0xFFFFE0E2))),
                        const SizedBox(width: 10),
                        Expanded(child: _stat('Total', total, const Color(0xFFE7E9F1))),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: FilledButton.icon(
                  onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const CategoryScreen()),
                    (route) => false,
                  ),
                  icon: const Icon(Icons.replay_rounded),
                  label: const Text(
                    'PLAY AGAIN',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stat(String label, int value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        children: [
          Text('$value', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 3),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
