import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// create the GamePage
class GamePage extends StatelessWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Play Game")),
        body: Center(child: Container(child: Text("The game page"))));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blackjack',
      theme: ThemeData(primarySwatch: Colors.red),
      routes: {
        // '/': (context) => const MyHomePage(),
        '/game': (context) => const GamePage(),
      },
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(18.0),
                child: Text(
                  'Blackjack',
                  style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              ),
              TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                    foregroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  onPressed: () => {
                        Navigator.pushNamed(context, '/game'),
                      },
                  child: const Text('Start Game')),
            ],
          ),
        ),
      ),
    );
  }
}
