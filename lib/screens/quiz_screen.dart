import 'package:flutter/material.dart';
import '../main.dart';
import '../models/quiz_question.dart';
import '../services/quiz_api.dart';
import '../services/firebase_service.dart';
import 'category_screen.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final QuizCategory category;
  final int amount;
  final String difficulty;

  const QuizScreen({
    super.key,
    required this.category,
    required this.amount,
    required this.difficulty,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final api = QuizApi();
  late Future<List<QuizQuestion>> future;
  int current = 0;
  int correct = 0;
  int wrong = 0;
  String? selected;
  bool answered = false;
  final stopwatch = Stopwatch()..start();

  @override
  void initState() {
    super.initState();
    future = api.fetchQuestions(
      amount: widget.amount,
      category: widget.category.apiId,
      difficulty: widget.difficulty,
    );
  }

  void choose(String answer, QuizQuestion question) {
    if (answered) return;
    setState(() {
      selected = answer;
      answered = true;
      if (answer == question.correctAnswer) {
        correct++;
      } else {
        wrong++;
      }
    });
  }

  Future<void> next(List<QuizQuestion> questions) async {
    if (current < questions.length - 1) {
      setState(() {
        current++;
        selected = null;
        answered = false;
      });
      return;
    }

    stopwatch.stop();
    await FirebaseService.saveQuizResult(
      category: widget.category.name,
      total: questions.length,
      correct: correct,
      wrong: wrong,
      durationSeconds: stopwatch.elapsed.inSeconds,
    );

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          category: widget.category.name,
          total: questions.length,
          correct: correct,
          wrong: wrong,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<QuizQuestion>>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.hasError) return _error(snapshot.error.toString());
            if (!snapshot.hasData) return _loading();

            final questions = snapshot.data!;
            final question = questions[current];
            final progress = (current + 1) / questions.length;

            return Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(.1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          '${current + 1}/${questions.length}',
                          style: const TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w900,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const CategoryScreen()),
                          (route) => false,
                        ),
                        icon: const Icon(Icons.logout_rounded, size: 19),
                        label: const Text(
                          'EXIT',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 9),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 9,
                      backgroundColor: const Color(0xFFE4E7EE),
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(24, 28, 24, 30),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(color: const Color(0xFFE8EAF0)),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x0D000000),
                                blurRadius: 22,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Text(
                            question.question,
                            style: const TextStyle(
                              fontSize: 21,
                              height: 1.5,
                              fontWeight: FontWeight.w800,
                              color: inkColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        ...question.answers.asMap().entries.map(
                          (entry) => _option(entry.key, entry.value, question),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: FilledButton(
                      onPressed: answered ? () => next(questions) : null,
                      child: Text(
                        current == questions.length - 1 ? 'FINISH' : 'NEXT',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _option(int index, String answer, QuizQuestion question) {
    final isCorrect = answered && answer == question.correctAnswer;
    final isWrong = answered && answer == selected && !isCorrect;
    final isSelected = answer == selected;
    final background = isCorrect
        ? const Color(0xFFD7F2EC)
        : isWrong
            ? const Color(0xFFFFD8DA)
            : Colors.white;
    final border = isCorrect
        ? primaryColor
        : isWrong
            ? const Color(0xFFE05262)
            : const Color(0xFFE5E7ED);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () => choose(answer, question),
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: border, width: isSelected ? 1.6 : 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: answered ? Colors.white.withOpacity(.72) : const Color(0xFFF0F2F7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    String.fromCharCode(65 + index),
                    style: const TextStyle(fontWeight: FontWeight.w900, color: inkColor),
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Text(
                    answer,
                    style: const TextStyle(fontSize: 16.5, fontWeight: FontWeight.w700),
                  ),
                ),
                if (!answered)
                  const Icon(Icons.radio_button_unchecked_rounded, color: Color(0xFF777C88))
                else if (isCorrect)
                  const Icon(Icons.check_circle_rounded, color: primaryColor)
                else if (isWrong)
                  const Icon(Icons.cancel_rounded, color: Color(0xFFE05262))
                else
                  const Icon(Icons.radio_button_unchecked_rounded, color: Color(0xFFB0B4BE)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loading() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Preparing your quiz...',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 5),
          Text('Fetching fresh questions', style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _error(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE1E3),
                borderRadius: BorderRadius.circular(26),
              ),
              child: const Icon(Icons.wifi_off_rounded, size: 42, color: Color(0xFFE05262)),
            ),
            const SizedBox(height: 18),
            const Text(
              'Could not load quiz',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              message.replaceFirst('Exception: ', ''),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, height: 1.4),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
