import 'dart:math';
import 'package:flutter/material.dart';
import '../data/image_mapping.dart';
import '../data/family.dart';
import '../data/cousin.dart';

class GameScreen extends StatefulWidget {
  final String category;
  const GameScreen({super.key, required this.category});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late String hiddenWord;
  late String currentGuess;
  late String currentImagePath;
  int attemptsLeft = 6;
  String message = "";
  final TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    resetGame();
  }

  void resetGame() {
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
    final words = widget.category == "Family" ? familyWords : cousinWords;
    return words[random.nextInt(words.length)];
  }

  void handleGuess(String input) {
    if (input.isEmpty || input.length != 1) {
      setState(() {
        message = "Please enter a single letter.";
      });
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
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text("Game Over"),
          content: SizedBox(
            width: 500,
            height: 1000,
            child: Column(
              children: [
                Text("Game Over! The word was: $hiddenWord"),
                SizedBox(height: 20),
                Expanded(
                  child: Image.asset(
                    currentImagePath,
                    fit: BoxFit.cover,
                    width: 450,
                    height: 800,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  resetGame();
                },
                child: Text("Play Again")),
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
          content: SizedBox(
            width: 500,
            height: 1000,
            child: Column(
              children: [
                Text(
                    "Congratulations! You've guessed the word: $hiddenWord"),
                SizedBox(height: 20),
                Expanded(
                  child: Image.asset(
                    currentImagePath,
                    fit: BoxFit.cover,
                    width: 450,
                    height: 800,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  resetGame();
                },
                child: Text("Play Again")),
            TextButton(
                onPressed: () => Navigator.pop(context), child: Text("Ok"))
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF00008B), Colors.cyan],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Word: $currentGuess",
                  style: TextStyle(
                    fontFamily: 'Times New Roman',
                    fontSize: 35,
                    color: Colors.yellow,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Attempts Left: $attemptsLeft",
                  style: TextStyle(
                    fontFamily: 'Arial Rounded MT Bold',
                    fontSize: 26,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _inputController,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Arial Black',
                    color: Colors.white,
                  ),
                  cursorColor: Colors.blue,
                  decoration: InputDecoration(
                      hintText: "Enter a letter",
                      hintStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      )),
                  onSubmitted: (input) => handleGuess(input),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => handleGuess(_inputController.text),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Color(0xFFFF4500)),
                      ),
                      child: Text("Guess"),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: resetGame,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Color(0xFF007519)),
                      ),
                      child: Text("Play Again"),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Color(0xFF9370DB)),
                      ),
                      child: Text("Back"),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  message,
                  style: TextStyle(
                      fontFamily: 'Arial', fontSize: 18, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }
}
