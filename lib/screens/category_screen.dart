import 'package:flutter/material.dart';
import '../main.dart';
import 'config_screen.dart';

class QuizCategory {
  final String name;
  final int? apiId;
  final Color color;
  final IconData icon;

  const QuizCategory(this.name, this.apiId, this.color, this.icon);
}

const categories = [
  QuizCategory('General Knowledge', 9, Color(0xFFDCE6FF), Icons.public_rounded),
  QuizCategory('Books', 10, Color(0xFFD8F7DE), Icons.menu_book_rounded),
  QuizCategory('History', 23, Color(0xFFFFF4BF), Icons.history_edu_rounded),
  QuizCategory('Science & Nature', 17, Color(0xFFF0D8FA), Icons.science_rounded),
  QuizCategory('Art', 25, Color(0xFFFFD4D4), Icons.palette_rounded),
  QuizCategory('Vehicles', 28, Color(0xFFFFE8C7), Icons.directions_car_rounded),
];

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 26, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(Icons.bolt_rounded, color: primaryColor),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Quizzical',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                      color: inkColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              const Text(
                'Pick a category',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -.8,
                  color: inkColor,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Choose a topic and make your best score.',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: categories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: .86,
                  ),
                  itemBuilder: (_, index) {
                    final category = categories[index];
                    return Material(
                      color: category.color,
                      borderRadius: BorderRadius.circular(25),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(25),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ConfigScreen(category: category),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(.55),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.arrow_outward_rounded,
                                    size: 19,
                                    color: inkColor,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Icon(
                                    category.icon,
                                    size: 70,
                                    color: inkColor.withOpacity(.9),
                                  ),
                                ),
                              ),
                              Text(
                                category.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16.5,
                                  height: 1.15,
                                  fontWeight: FontWeight.w900,
                                  color: inkColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
