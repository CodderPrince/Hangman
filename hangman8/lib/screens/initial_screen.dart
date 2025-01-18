import 'package:flutter/material.dart';
import '../data/cousin.dart';
import '../data/family.dart';
import '../data/image_mapping.dart';
import 'game_screen.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  String currentCategory = "Family";
  final Map<String, List<String>> categoryWordBank = {
    "Family": familyWords,
    "Cousin": cousinWords,
  };

  void _switchToGameScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(category: currentCategory),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              ElevatedButton(
                onPressed: () => _switchToGameScreen(context),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFF1E90FF)),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
                child: Text("Start Game"),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFFFF6347)),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
                child: Text("Exit Game"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
