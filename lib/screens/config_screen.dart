import 'package:flutter/material.dart';
import '../main.dart';
import 'category_screen.dart';
import 'quiz_screen.dart';

class ConfigScreen extends StatefulWidget {
  final QuizCategory category;

  const ConfigScreen({super.key, required this.category});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  double amount = 10;
  String difficulty = 'Any Difficulty';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text(
          'Quiz Setup',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 30),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  widget.category.color,
                  widget.category.color.withOpacity(.62),
                ],
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Row(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.62),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Icon(widget.category.icon, size: 42, color: inkColor),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ready to play?',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF4D5361),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        widget.category.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: inkColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          const Text(
            'Number of Questions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Text(
                'Choose from 1 to 50',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  amount.round().toString(),
                  style: const TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          Slider(
            min: 1,
            max: 50,
            divisions: 49,
            value: amount,
            activeColor: primaryColor,
            onChanged: (value) => setState(() => amount = value),
          ),
          const SizedBox(height: 14),
          const Text(
            'Difficulty Level',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 9),
          DropdownButtonFormField<String>(
            initialValue: difficulty,
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            items: const [
              DropdownMenuItem(value: 'Any Difficulty', child: Text('Any Difficulty')),
              DropdownMenuItem(value: 'Easy', child: Text('Easy')),
              DropdownMenuItem(value: 'Medium', child: Text('Medium')),
              DropdownMenuItem(value: 'Hard', child: Text('Hard')),
            ],
            onChanged: (value) {
              if (value != null) setState(() => difficulty = value);
            },
          ),
          const SizedBox(height: 20),
          const Text(
            'Question Type',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 9),
          DropdownButtonFormField<String>(
            initialValue: 'Multiple Choice',
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            items: const [
              DropdownMenuItem(
                value: 'Multiple Choice',
                child: Text('Multiple Choice'),
              ),
            ],
            onChanged: null,
          ),
          const SizedBox(height: 28),
          SizedBox(
            height: 62,
            child: FilledButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => QuizScreen(
                    category: widget.category,
                    amount: amount.round(),
                    difficulty: difficulty,
                  ),
                ),
              ),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text(
                'START QUIZ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
