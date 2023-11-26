import 'package:flutter/material.dart';

class QuizCompletionScreen extends StatelessWidget {
  final double score;
  final Function() onResetPressed;

  QuizCompletionScreen({required this.score, required this.onResetPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Completed'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Your Score: $score'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: onResetPressed,
              child: Text('Start New Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
