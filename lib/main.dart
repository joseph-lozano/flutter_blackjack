import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class Game extends StatefulWidget {
  Game({Key? key}) : super(key: key);

  bool _isDataLoading = true;
  String _deckId = "";

  final dec = Uri.https('https://deckofcardsapi.com', '/api/deck/new/shuffle/');
  // final response = await http.post(url, body: {'name': 'doodle', 'color': 'blue'});
// print('Response status: ${response.statusCode}');
// print('Response body: ${response.body}');

// print(await http.read(Uri.https('example.com', 'foobar.txt')));

  // const Game({super.key, this.deckId));

  // final String deckId;
  Future<Void> _getDeckId() async {
    var response = await http.get(
      Uri.encodeFull(dec),
      headers: {"Accept": 'application/json'},
    );

    setState(() {
      var data = json.decode(response.body);
      _isDataLoading = false;
      _deckId = data;
    })
    // return deckId
  }

  @override
  _GameState createState() => _GameState(deckId);
}

class _GameState extends State<Game> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text("Foobar"));
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
        '/game': (context) => const Game(),
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
