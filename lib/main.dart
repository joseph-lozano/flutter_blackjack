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

class CardsResponse {
  final List<dynamic> cards;
  CardsResponse({required this.cards});

  factory CardsResponse.fromJson(Map<String, dynamic> json) {
    return CardsResponse(cards: json['cards']);
  }
}

class Card {
  final String value;
  final String imageUrl;

  Card({required this.value, required this.imageUrl});

  factory Card.fromJson(Map<String, dynamic> json) {
    return Card(value: json["value"], imageUrl: json["image"]);
  }
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
  late Future<List<Card>> futureCards;

  Future<Deck> fetchDeck() async {
    var resp = await http.get(dec);
    return Deck.fromJson(jsonDecode(resp.body));
  }

  Future<List<Card>> fetchCard() async {
    var deck = await futureDeck;
    final Uri getCard = Uri.https(
        'deckofcardsapi.com', '/api/deck/${deck.deckId}/draw/', {'count': '2'});
    var resp = await http.get(getCard);
    var cardResp = CardsResponse.fromJson(jsonDecode(resp.body));

    return cardResp.cards.map((cardJson) => Card.fromJson(cardJson)).toList();
  }

  @override
  initState() {
    super.initState();
    futureDeck = fetchDeck();
    futureCards = fetchCard();
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
                return Container(
                  child: FutureBuilder<List<Card>>(
                      future: futureCards,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Center(
                            child: Row(
                              children: [
                                Image.network(snapshot.data![0].imageUrl),
                                Image.network(snapshot.data![1].imageUrl),
                              ],
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }
                        return const Center(child: CircularProgressIndicator());
                      }),
                );
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
