import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'animal.dart';
import 'game_screens.dart';
import 'leaderboard_screen.dart';
import 'styled_button.dart';
import 'progress_manager.dart';
import 'flower.dart'; // Import flower.dart

// CategoryData Class
abstract class CategoryData {
  static Map<String, List<String>> categoryWordBank = {};
  static Map<String, String> imageMapping = {};
}

class HangmanGame extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HangmanGameState createState() => _HangmanGameState();
}

enum GameScreen {
  initial,
  game,
}

class _HangmanGameState extends State<HangmanGame> {
  late Map<String, List<String>> categoryWordBank;
  late Map<String, String> imageMapping;
  late SharedPreferences prefs;

  late String hiddenWord;
  late String currentGuess;
  late String currentImagePath;
  int attemptsLeft = 6;
  String currentCategory = "Animal";
  String message = "";
  GameScreen _currentScreen = GameScreen.initial;
  final TextEditingController _inputController = TextEditingController();
  late String userId;
  late Map<String, Type> categories;

  @override
  void initState() {
    super.initState();
    _initPrefs();
    _initializeCategories();
    _loadCategoryData(currentCategory);
    resetGame();
  }
  void _initializeCategories() {
    categories = {
      'Animal': AnimalData,
      'Flower': FlowerData,
    };
  }

  Future<void> _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? '';
  }
  void _loadCategoryData(String category) {
    if (categories.containsKey(category)) {
      if (category == "Flower"){
        categoryWordBank = FlowerData.categoryWordBank;
        imageMapping = FlowerData.imageMapping;
      } else if (category == "Animal"){
        categoryWordBank = AnimalData.categoryWordBank;
        imageMapping = AnimalData.imageMapping;
      }
    } else {
      categoryWordBank = AnimalData.categoryWordBank;
      imageMapping = AnimalData.imageMapping;
    }
  }

  void resetGame() {
    _loadCategoryData(currentCategory);
    hiddenWord = selectRandomWord();
    currentImagePath = imageMapping[hiddenWord] ?? "assets/images/default.jpg";
    currentGuess = "_ " * hiddenWord.length;
    attemptsLeft = 6;
    message = "";
    _inputController.clear();
    setState(() {});
  }

  String selectRandomWord() {
    final random = Random();
    final words = categoryWordBank[currentCategory] ?? ["UNKNOWN"];
    return words[random.nextInt(words.length)];
  }

  void handleGuess(String input) {
    if (input.isEmpty) {
      setState(() {
        message = "Please enter a letter.";
      });
      return;
    }

    final RegExp letterRegex = RegExp(r'^[a-zA-Z]$');
    if (!letterRegex.hasMatch(input)) {
      setState(() {
        message = "Please enter a valid Letter.";
      });
      _inputController.clear();
      return;
    }

    final guessedLetter = input.toUpperCase().characters.first;

    bool correctGuess = false;
    List<String> newGuessList = [];

    for (int i = 0; i < hiddenWord.length; i++) {
      if (hiddenWord[i] == guessedLetter) {
        newGuessList.add(guessedLetter);
        correctGuess = true;
      } else {
        newGuessList.add(
            currentGuess[i * 2]); // Correct indexing for the letter/underscore
      }
      if (i < hiddenWord.length - 1) newGuessList.add(" ");
    }
    String newGuess = newGuessList.join();

    if (!correctGuess) {
      attemptsLeft--;
      setState(() {
        message = "Incorrect guess!";
      });
    } else {
      setState(() {
        message = "Correct guess!";
      });
    }
    currentGuess = newGuess;
    _inputController.clear();

    if (attemptsLeft == 0) {
      showGameOverDialog();
    } else if (currentGuess.replaceAll(" ", "") == hiddenWord) {
      showVictoryDialog();
    }

    setState(() {});
  }

  void showGameOverDialog() {
    ProgressManager.saveProgress(userId, currentCategory, attemptsLeft, false);
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Rounded corners
          ),
          title: Text("Game Over"),
          content: Container(
            constraints: BoxConstraints(
              maxWidth: 600,
              maxHeight: 850,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Game Over! The word was: $hiddenWord"),
                  SizedBox(height: 20),
                  Image.asset(
                    currentImagePath,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () => Navigator.pop(context), child: Text("Ok"))
          ],
        ));
  }

  void showVictoryDialog() {
    ProgressManager.saveProgress(userId, currentCategory, attemptsLeft, true);
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Congratulations!"),
          content: Container(
            constraints: BoxConstraints(
              maxWidth: 600,
              maxHeight: 850,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      "Congratulations! You've guessed the word: $hiddenWord"),
                  SizedBox(height: 20),
                  Image.asset(
                    currentImagePath,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () => Navigator.pop(context), child: Text("Ok"))
          ],
        ));
  }

  void _switchToGameScreen() {
    setState(() {
      _currentScreen = GameScreen.game;
      resetGame();
    });
  }

  void _switchToInitialScreen() {
    setState(() {
      _currentScreen = GameScreen.initial;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentScreen) {
      case GameScreen.initial:

        return InitialScreen(
          currentCategory: currentCategory,
          categoryWordBank: categories.keys.fold({}, (map, key) {
            if (key == "Flower"){
              return map..addAll(FlowerData.categoryWordBank);
            } else if (key == "Animal"){
              return map..addAll(AnimalData.categoryWordBank);
            } else{
              return map;
            }
          }),
          onCategoryChanged: (newValue) {
            setState(() {
              currentCategory = newValue;
            });
          },
          onStartGame: _switchToGameScreen,
          onExitGame: () => Navigator.of(context).pop(),
          showLeaderboard: () => _showLeaderboard(),
        );
      case GameScreen.game:
        return GamePlayScreen(
          currentGuess: currentGuess,
          attemptsLeft: attemptsLeft,
          message: message,
          inputController: _inputController,
          onGuess: handleGuess,
          onPlayAgain: () {
            ProgressManager.saveProgress(
                userId, currentCategory, attemptsLeft, false);
            resetGame();
          },
          onBack: _switchToInitialScreen,
          currentImagePath: currentImagePath,
        );
      default:
        return InitialScreen(
          currentCategory: currentCategory,
          categoryWordBank: categories.keys.fold({}, (map, key) {
            if (key == "Flower"){
              return map..addAll(FlowerData.categoryWordBank);
            } else if (key == "Animal"){
              return map..addAll(AnimalData.categoryWordBank);
            } else{
              return map;
            }
          }),
          onCategoryChanged: (newValue) {
            setState(() {
              currentCategory = newValue;
            });
          },
          onStartGame: _switchToGameScreen,
          onExitGame: () => Navigator.of(context).pop(),
          showLeaderboard: () => _showLeaderboard(),
        );
    }
  }

  void _showLeaderboard() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LeaderboardScreen()),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }
}