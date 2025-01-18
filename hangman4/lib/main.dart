import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(HangmanApp());
}

class HangmanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hangman Game',
      debugShowCheckedModeBanner: false, // Disable the debug banner
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HangmanGame(),
    );
  }
}

class HangmanGame extends StatefulWidget {
  @override
  _HangmanGameState createState() => _HangmanGameState();
}

enum GameScreen {
  initial,
  game,
}

class _HangmanGameState extends State<HangmanGame> {
  Map<String, List<String>> categoryWordBank = {
    "Family": [
      "PRINCE",
      "NAZMUL",
      "NISHAT",
      "JAHANARA",
      "AMIRUL",
      "PRIYANKA",
    ],
    "Cousin": ["SH", "NOO"],
  };

  Map<String, String> imageMapping = {
    // Family category images
    "PRINCE": "assets/images/PRINCE.jpg",
    "NAZMUL": "assets/images/NAZMUL.jpg",
    "NISHAT": "assets/images/NISHAT.jpg",
    "JAHANARA": "assets/images/JAHANARA.jpg",
    "AMIRUL": "assets/images/AMIRUL.jpg",
    "PRIYANKA": "assets/images/PRIYANKA.jpg",

    // Cousin category images
    "SH": "assets/images/SH.jpg",
    "NOO": "assets/images/NOO.jpg",
  };

  late String hiddenWord;
  late String currentGuess;
  late String currentImagePath;
  int attemptsLeft = 6;
  String currentCategory = "Family";
  String message = "";
  GameScreen _currentScreen = GameScreen.initial;

  final TextEditingController _inputController = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    resetGame();
  }

  Future<void> playSound(String fileName) async {
    await _audioPlayer.play(AssetSource('sounds/$fileName'));
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
    final words = categoryWordBank[currentCategory] ?? ["UNKNOWN"];
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
      playSound('incorrect.mp3');
      setState(() {
        message = "Incorrect guess!";
      });
    } else {
      playSound('correct.mp3');
      setState(() {
        message = "Correct guess!";
      });
    }
    currentGuess = newGuess;
    _inputController.clear();

    if (attemptsLeft == 0) {
      playSound('game_over.mp3');
      showGameOverDialog();
    } else if (currentGuess.replaceAll(" ", "") == hiddenWord) {
      playSound('victory.mp3');
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

  Widget _buildInitialScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF006400), Colors.lightGreen],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Welcome to Hangman Game!",
                style: TextStyle(
                  fontFamily: 'Arial Rounded MT Bold',
                  fontSize: 30,
                  color: Colors.yellow,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Select Category",
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 25,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                      colors: [Color(0xFF6B3000), Color(0xFF754D00)]),
                ),
                child: DropdownButton<String>(
                  dropdownColor: Color(0xFF724B00),
                  value: currentCategory,
                  onChanged: (String? newValue) {
                    setState(() {
                      currentCategory = newValue!;
                    });
                  },
                  items: categoryWordBank.keys
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          fontSize: 25,
                          fontFamily: 'Arial',
                          color: Colors.white,
                        ),
                      ),
                    );
                  }).toList(),
                  style: TextStyle(
                      color: Colors.white, fontSize: 25, fontFamily: 'Arial'),
                  underline: Container(),
                ),
              ),
              SizedBox(height: 10),
              _createStyledButton(
                "Start Game",
                _switchToGameScreen,
                startColor: Color(0xFF1E90FF),
                endColor: Color(0xFF87CEFA),
              ),
              SizedBox(height: 10),
              _createStyledButton(
                "Exit Game",
                    () => Navigator.of(context).pop(),
                startColor: Color(0xFFFF6347),
                endColor: Color(0xFFFF4500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameScreen() {
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
                      fillColor: Colors.white.withOpacity(0.5),
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
                    _createSmallStyledButton(
                        "Guess", () => handleGuess(_inputController.text),
                        startColor: Color(0xFFFF4500),
                        endColor: Color(0xFFFF8C00)),
                    SizedBox(width: 8),
                    _createSmallStyledButton("Play Again", () {
                      resetGame();
                    },
                        startColor: Color(0xFF007519),
                        endColor: Color(0xFF007519)),
                    SizedBox(width: 8),
                    _createSmallStyledButton(
                      "Back",
                      _switchToInitialScreen,
                      startColor: Color(0xFF9370DB),
                      endColor: Color(0xFF8A2BE2),
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

  Widget _createStyledButton(String text, VoidCallback onPressed,
      {required Color startColor, required Color endColor}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 300,
        height: 70,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white, width: 2),
            gradient: LinearGradient(colors: [startColor, endColor]),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 10,
                offset: Offset(0, 3),
              )
            ]),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontSize: 24, fontFamily: 'Arial', color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _createSmallStyledButton(String text, VoidCallback onPressed,
      {required Color startColor, required Color endColor}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 95,
        height: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white, width: 2),
            gradient: LinearGradient(colors: [startColor, endColor]),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 10,
                offset: Offset(0, 3),
              )
            ]),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontSize: 18, fontFamily: 'Arial', color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentScreen) {
      case GameScreen.initial:
        return _buildInitialScreen();
      case GameScreen.game:
        return _buildGameScreen();
      default:
        return _buildInitialScreen();
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }
}
