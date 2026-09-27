import 'dart:convert';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;
import '../models/quiz_question.dart';

class QuizApi {
  static const _base = 'https://opentdb.com/api.php';
  final _unescape = HtmlUnescape();

  Future<List<QuizQuestion>> fetchQuestions({
    required int amount,
    required int? category,
    required String difficulty,
  }) async {
    final params = <String, String>{
      'amount': '$amount',
      'type': 'multiple',
    };

    if (category != null) params['category'] = '$category';
    if (difficulty != 'Any Difficulty') {
      params['difficulty'] = difficulty.toLowerCase();
    }

    final uri = Uri.parse(_base).replace(queryParameters: params);
    final response = await http.get(uri).timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Quiz API returned ${response.statusCode}.');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final responseCode = data['response_code'] as int? ?? -1;

    if (responseCode != 0) {
      throw Exception('Not enough questions. Try fewer questions or another difficulty.');
    }

    final results = data['results'] as List<dynamic>;
    return results.map((item) {
      final map = item as Map<String, dynamic>;
      final correct = _decode(map['correct_answer'] as String);
      final incorrect = (map['incorrect_answers'] as List<dynamic>)
          .map((e) => _decode(e as String))
          .toList();
      final answers = <String>[...incorrect, correct]..shuffle();

      return QuizQuestion(
        question: _decode(map['question'] as String),
        correctAnswer: correct,
        answers: answers,
      );
    }).toList();
  }

  String _decode(String value) => _unescape.convert(value);
}
