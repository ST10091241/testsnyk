//gamespage.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/buildDrawer.dart';
import 'package:flutter_application_1/pages/quiz.dart';
import 'package:flutter_application_1/pages/leaderboard.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();

  static void changeScreen(BuildContext context, int newIndex) {
    _GameScreenState? screenState =
        context.findAncestorStateOfType<_GameScreenState>();
    screenState!.changeIndex(newIndex);
  }
}

class _GameScreenState extends State<GameScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [    
    QuizPage(),
    leaderboard(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Games'),
      ),
      drawer: buildDrawer(context),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [          
          BottomNavigationBarItem(
            icon: Icon(Icons.games),
            label: 'Games',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Leaderboard',
          ),
        ],
      ),
    );
  }
   void changeIndex(int newIndex) {
    setState(() {
      _currentIndex = newIndex;
    });
  }
}
