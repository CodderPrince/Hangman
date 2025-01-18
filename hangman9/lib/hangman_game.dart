import 'dart:math';
import 'package:flutter/material.dart';
import 'game_screens.dart';
import 'styled_button.dart';
import 'family.dart';
import 'cousin.dart';

class HangmanGame extends StatefulWidget {
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

  late String hiddenWord;
  late String currentGuess;
  late String currentImagePath;
  int attemptsLeft = 6;
  String currentCategory = "Family";
  String message = "";
  GameScreen _currentScreen = GameScreen.initial;

  final TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategoryData(currentCategory);
    resetGame();
  }

  void _loadCategoryData(String category) {
    if (category == "Family") {
      categoryWordBank = FamilyData.categoryWordBank;
      imageMapping = FamilyData.imageMapping;
    } else if (category == "Cousin") {
      categoryWordBank = CousinData.categoryWordBank;
      imageMapping = CousinData.imageMapping;
    } else {
      categoryWordBank = {};
      imageMapping = {};
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
    if(!letterRegex.hasMatch(input)){
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
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Rounded corners
          ),
          title: Text("Game Over"),
          content: Container(
            width: 500, // Adjusted dialog width
            height: 1000, // Adjusted dialog height
            child: Column(
              children: [
                Text("Game Over! The word was: $hiddenWord"),
                SizedBox(height: 20),
                Expanded(
                  child: Image.asset(
                    currentImagePath,
                    fit: BoxFit.cover, // Makes the image fill the space
                    width: 450, // Adjusted image width
                    height: 800, // Adjusted image height
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () => Navigator.pop(context), child: Text("Ok"))
          ],
        ));
  }

  void showVictoryDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Congratulations!"),
          content: Container(
            width: 500, // Adjusted dialog width
            height: 1000, // Adjusted dialog height
            child: Column(
              children: [
                Text("Congratulations! You've guessed the word: $hiddenWord"),
                SizedBox(height: 20),
                Expanded(
                  child: Image.asset(
                    currentImagePath,
                    fit: BoxFit.cover, // Makes the image fill the space
                    width: 450, // Adjusted image width
                    height: 800, // Adjusted image height
                  ),
                ),
              ],
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
          categoryWordBank: {
            "Family": FamilyData.categoryWordBank["Family"] ?? [],
            "Cousin": CousinData.categoryWordBank["Cousin"] ?? []
          },
          onCategoryChanged: (newValue) {
            setState(() {
              currentCategory = newValue;
            });
          },
          onStartGame: _switchToGameScreen,
          onExitGame: () => Navigator.of(context).pop(),
        );
      case GameScreen.game:
        return GamePlayScreen(
          currentGuess: currentGuess,
          attemptsLeft: attemptsLeft,
          message: message,
          inputController: _inputController,
          onGuess: handleGuess,
          onPlayAgain: resetGame,
          onBack: _switchToInitialScreen,
        );
      default:
        return InitialScreen(
          currentCategory: currentCategory,
          categoryWordBank: {
            "Family": FamilyData.categoryWordBank["Family"] ?? [],
            "Cousin": CousinData.categoryWordBank["Cousin"] ?? []
          },
          onCategoryChanged: (newValue) {
            setState(() {
              currentCategory = newValue;
            });
          },
          onStartGame: _switchToGameScreen,
          onExitGame: () => Navigator.of(context).pop(),
        );
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }
}