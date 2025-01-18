import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'hangman_game.dart';
import 'styled_button.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _nameController = TextEditingController();
  bool _isCreateAccount = false;

  Future<void> _saveName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      await prefs.setString('userName', name);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HangmanGame()));
    }
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
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
                TextField(
                  controller: _nameController,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'Arial Black',
                    color: Colors.black,
                  ),
                  cursorColor: Colors.blue,
                  decoration: InputDecoration(
                      hintText: "Enter your name",
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      )),
                ),
                SizedBox(height: 20),
                StyledButton(
                  text: _isCreateAccount ? "Create Account" : "Login",
                  onPressed: () {
                    _saveName();
                  },
                  startColor: Color(0xFF1E90FF),
                  endColor: Color(0xFF87CEFA),
                ),
                TextButton(
                    onPressed: () {
                      setState(() {
                        _isCreateAccount = !_isCreateAccount;
                      });
                    },
                    child: Text(
                      _isCreateAccount
                          ? "Already have an account? Login."
                          : "New user? Create Account.",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}