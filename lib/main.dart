import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class Game extends StatefulWidget {
  Game({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GameState();

  // return deckId
}

class Deck {
  final String deckId;
  final bool success;
  final int remaining;
  final bool shuffled;

  Deck(
      {required this.deckId,
      required this.success,
      required this.remaining,
      required this.shuffled});

  factory Deck.fromJson(Map<String, dynamic> json) {
    return Deck(
        deckId: json['deck_id'],
        success: json['success'],
        remaining: json['remaining'],
        shuffled: json['shuffled']);
  }
}

class _GameState extends State<Game> {
  final Uri dec = Uri.https('deckofcardsapi.com', '/api/deck/new/shuffle/');
  late Future<Deck> futureDeck;

  Future<Deck> fetchDeck() async {
    var resp = await http.get(dec);
    return Deck.fromJson(jsonDecode(resp.body));
  }

  @override
  initState() {
    super.initState();
    futureDeck = fetchDeck();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Let\s Play Blackjack!'),
        ),
        body: FutureBuilder<Deck>(
            future: futureDeck,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Center(child: Text(snapshot.data!.deckId));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
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
        '/game': (context) => Game(),
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
