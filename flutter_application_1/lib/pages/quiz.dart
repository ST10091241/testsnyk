import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/Auth-Provider.dart';
import 'package:flutter_application_1/data%20classes/LeaderboardDataClass.dart';
import 'package:flutter_application_1/data%20classes/QuizQuestion.dart';
import 'package:flutter_application_1/data%20classes/UserInfo.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<QuizQuestion> questions = [];
  int currentQuestionIndex = 0;
  double score = 0;
  String? selectedAnswer;
  late Timer questionTimer;
  double timerValue = 1.0;
  int maxTimeInSeconds = 10;

  @override
  void initState() {
    super.initState();
    fetchQuestions();
    startTimer();
  }

  @override
  void dispose() {
    questionTimer.cancel();
    super.dispose();
  }

  void startTimer() {
    questionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timerValue > 0) {
          timerValue -= 1.0 / maxTimeInSeconds;
        } else {
          timer.cancel();
          handleTimeout();
        }
      });
    });
  }

  void handleTimeout() {
    String randomOption = "##########noanas";
    setState(() {
      selectedAnswer = randomOption;
      resetTimer();
      goToNextQuestion();
    });
  }

  void resetTimer() {
    questionTimer.cancel();
    setState(() {
      timerValue = 1.0;
    });
    startTimer();
  }

  Future<void> fetchQuestions() async {
    final response =
        await http.get(Uri.parse('https://opentdb.com/api.php?amount=10&category=9&difficulty=medium'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['results'] != null) {
        setState(() {
          questions = List<QuizQuestion>.from(
            data['results'].map((question) => QuizQuestion.fromJson(question)),
          );
        });
      }
    } else {
      throw Exception('Failed to load questions');
    }
  }

  void checkAnswer(String selectedAnswer) {
    String correctAnswer = questions[currentQuestionIndex].correctAnswer;
    double timeRemaining = timerValue * maxTimeInSeconds;
    double timePoints = maxTimeInSeconds - timeRemaining;
    double accuracyPoints = 0.0;
    if (selectedAnswer == correctAnswer) {
      accuracyPoints = 1.0;
      double totalPoints = accuracyPoints + timePoints;
      double roundedScore =
          double.parse((totalPoints * 3.3).toStringAsFixed(1));
      setState(() {
        score = roundedScore;
      });
    }

    goToNextQuestion();
  }

  void resetQuiz() {
    setState(() {
      questions.clear();
      currentQuestionIndex = 0;
      score = 0;
      selectedAnswer = null;
      timerValue = 1.0;
    });
    fetchQuestions();
    startTimer();
  }

  void goToNextQuestion() {
    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        questionTimer.cancel();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            final authProvider = Provider.of<Auth_Provider>(context);
            UsersInfo? _usersInfo = authProvider.usersInfo;
            final DatabaseReference _database =
                FirebaseDatabase.instance.ref().child('LeaderboardInfo');

            return AlertDialog(
              title: Text('Quiz Completed'),
              content: Text('Your Score: $score'),
              actions: [
                TextButton(
                  onPressed: () {                     
                    if (_usersInfo?.emailAddress != null) {
                      _database.once().then((snapshot) {
                         DataSnapshot dataSnapshot = snapshot.snapshot;
                      if (dataSnapshot.value != null) {
                        Map<String, dynamic>? data = dataSnapshot.value as Map<String, dynamic>?;
                        bool emailExists = false;
                        String? existingKey;

                        if (data != null) {
                          data.forEach((key, value) {
                            if (value['email'] == _usersInfo?.emailAddress) {
                              emailExists = true;
                              existingKey = key;
                            }
                          });
                        }
                        final leaderboardData = LeaderboardInfo(
                          name: _usersInfo?.name,
                          email: _usersInfo?.emailAddress,
                          score: score,
                        );

                        if (emailExists && existingKey != null) {
                          // If the email exists, update the existing entry
                          _database
                              .child(existingKey!)
                              .set(leaderboardData.toJson());
                          print('Updated existing entry for ${_usersInfo?.emailAddress},');
                        } else {
                          // If the email doesn't exist, create a new entry
                          String newKey = _database.push().key ?? '';
                          _database.child(newKey).set(leaderboardData.toJson());
                          print('Created a new entry for ${_usersInfo?.emailAddress},');
                        }
                      }}).catchError((error) {
                        print('Error: $error');
                      });
                    }
                    
                    Navigator.of(context).pop();
                    
                    questionTimer.cancel();
                  },
                  child: Text('ok'),
                ),
              ],
              
            );
            
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: questions.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text(
                    'Loading Questions',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment:
                  CrossAxisAlignment.stretch, // Adjusted crossAxisAlignment
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0), // Added vertical padding
                  child: Text(
                    'Question ${currentQuestionIndex + 1}/${questions.length}',
                    style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold), // Increased font weight
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: LinearProgressIndicator(
                    value: timerValue,
                    minHeight: 10,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    questions[currentQuestionIndex].question,
                    style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold), // Increased font weight
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20.0),
                ...List.generate(
                  questions[currentQuestionIndex].options.length,
                  (index) {
                    final option =
                        questions[currentQuestionIndex].options[index];
                    return ListTile(
                      title: Text(
                        option,
                        style: TextStyle(fontSize: 18.0), // Adjusted font size
                      ),
                      leading: Radio<String>(
                        value: option,
                        groupValue: selectedAnswer,
                        onChanged: (value) {
                          setState(() {
                            selectedAnswer = value!;
                          });
                        },
                      ),
                    );
                  },
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedAnswer != null &&
                          selectedAnswer!.isNotEmpty) {
                        checkAnswer(selectedAnswer!);
                        resetTimer();
                        setState(() {
                          selectedAnswer = null;
                        });
                      }
                    },
                    child: Text('Submit',
                        style: TextStyle(fontSize: 18.0)), // Adjusted font size
                  ),
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      resetQuiz();
                    },
                    child: Text('Reset',
                        style: TextStyle(fontSize: 18.0)), // Adjusted font size
                  ),
                ),
              ],
            ),
    );
  }
}
// final leaderboardData = LeaderboardInfo(
//                       name: _usersInfo?.name,
//                       email: _user?.email,
//                       score: score,
//                     );
//                     _database.child(newkey!).set(leaderboardData.toJson());
//                     questionTimer.cancel();
//                     Navigator.of(context).pop();