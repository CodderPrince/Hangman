import 'package:flutter/material.dart';
import 'styled_button.dart';
import 'package:flutter/services.dart';
import 'leaderboard_screen.dart';
import 'screen_layout.dart';

class InitialScreen extends StatelessWidget {
  final String currentCategory;
  final Map<String, List<String>> categoryWordBank;
  final ValueChanged<String> onCategoryChanged;
  final VoidCallback onStartGame;
  final VoidCallback onExitGame;
  final VoidCallback showLeaderboard;

  const InitialScreen(
      {super.key,
        required this.currentCategory,
        required this.categoryWordBank,
        required this.onCategoryChanged,
        required this.onStartGame,
        required this.onExitGame,
        required this.showLeaderboard});

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      startColor: Color(0xFF006400),
      endColor: Colors.lightGreen,
      isHomeScreen: true,
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
                onCategoryChanged(newValue!);
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
          StyledButton(
            text: "Start Game",
            onPressed: onStartGame,
            startColor: Color(0xFF1E90FF),
            endColor: Color(0xFF87CEFA),
          ),
          SizedBox(height: 10),
          StyledButton(
            text: "Leaderboard",
            onPressed: showLeaderboard,
            startColor: Color(0xFF800080),
            endColor: Color(0xFFDA70D6),
          ),
          SizedBox(height: 10),
          StyledButton(
            text: "Exit Game",
            onPressed: onExitGame,
            startColor: Color(0xFFFF6347),
            endColor: Color(0xFFFF4500),
          ),
        ],
      ),
    );
  }
}

class GamePlayScreen extends StatelessWidget {
  final String currentGuess;
  final int attemptsLeft;
  final String message;
  final TextEditingController inputController;
  final Function(String) onGuess;
  final VoidCallback onPlayAgain;
  final VoidCallback onBack;
  final String currentImagePath;

  const GamePlayScreen(
      {super.key,
        required this.currentGuess,
        required this.attemptsLeft,
        required this.message,
        required this.inputController,
        required this.onGuess,
        required this.onPlayAgain,
        required this.onBack,
        required this.currentImagePath
      });

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      startColor: Color(0xFF00008B),
      endColor: Colors.cyan,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              constraints: BoxConstraints(
                maxHeight: 228,
              ),
              child: Image.asset(
                currentImagePath,
                fit: BoxFit.contain,
              ),
            ),
            Column(
              children: [
                Text(
                  "$currentGuess",
                  style: TextStyle(
                    fontFamily: 'Times New Roman',
                    fontSize: 30,
                    color: Colors.yellow,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Attempts Left: $attemptsLeft",
                  style: TextStyle(
                    fontFamily: 'Arial Rounded MT Bold',
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 40, // Reduced height of TextField
                  child: TextField(
                    controller: inputController,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20, // Reduced font size
                      fontFamily: 'Arial Rounded MT Bold',
                      color: Colors.white,
                    ),
                    maxLength: 1,
                    cursorColor: Colors.blue,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                    ],
                    decoration: InputDecoration(
                        counterText: "",
                        hintText: "Enter a letter",
                        hintStyle: TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        )),
                    onSubmitted: (input) => onGuess(input),
                    onChanged: (text){
                      if (text.length > 1) {
                        inputController.text = text.substring(0,1);
                        inputController.selection = TextSelection.fromPosition(TextPosition(offset: inputController.text.length));
                      }
                    },
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  message,
                  style: TextStyle(
                      fontFamily: 'Arial', fontSize: 18, color: Colors.white),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SmallStyledButton(
                  text: "Back",
                  onPressed: onBack,
                  startColor: Color(0xFF9370DB),
                  endColor: Color(0xFF8A2BE2),
                ),
                SizedBox(width: 8),
                SmallStyledButton(
                  text: "Play Again",
                  onPressed: onPlayAgain,
                  startColor: Color(0xFF007519),
                  endColor: Color(0xFF007519),
                ),
                SizedBox(width: 8),
                SmallStyledButton(
                  text: "Guess",
                  onPressed: () => onGuess(inputController.text),
                  startColor: Color(0xFFFF4500),
                  endColor: Color(0xFFFF8C00),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}