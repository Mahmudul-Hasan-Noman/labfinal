import 'package:flutter/material.dart';
import '../main.dart';
import 'category_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 34, 24, 26),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 235,
                height: 235,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFFF2B8), Color(0xFFE9E0FF)],
                  ),
                  borderRadius: BorderRadius.circular(62),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x18000000),
                      blurRadius: 30,
                      offset: Offset(0, 16),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 32,
                      right: 36,
                      child: Icon(Icons.auto_awesome_rounded,
                          size: 30, color: Colors.orange.shade400),
                    ),
                    const Icon(
                      Icons.psychology_alt_rounded,
                      size: 128,
                      color: Color(0xFF7D4DCE),
                    ),
                    Positioned(
                      bottom: 28,
                      left: 30,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.88),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Text(
                          'QUIZ',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Quizzical',
                style: TextStyle(
                  fontSize: 46,
                  height: 1,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.8,
                  color: inkColor,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Mahmudul Hasan Noman',
                style: TextStyle(
                  fontSize: 19,
                  height: 1.2,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                  color: Color(0xFF5D6270),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Challenge your mind with fun\nquestions from around the world.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  height: 1.45,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 62,
                child: FilledButton.icon(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const CategoryScreen()),
                  ),
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: const Text(
                    'GET STARTED',
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
}
