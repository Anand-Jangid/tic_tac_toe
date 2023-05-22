import 'package:flutter/material.dart';
import 'package:tic_tac_toe/screens/home_page.dart';
import 'package:tic_tac_toe/screens/score_card.dart';
import 'package:tic_tac_toe/screens/play_page.dart';

import '../board_tile.dart';
import '../models/tile_state.dart';

class GamePage extends StatefulWidget {
  const GamePage(
      {super.key, required this.user1Name, required this.user2Name});
  final String user1Name;
  final String user2Name;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  var _boardState = List.filled(9, TileState.EMPTY);
  var _currentTurn = TileState.CROSS;

  int user1Won = 0;
  int user2Won = 0;
  int draw = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Tic Tac Toe"),
        actions: [
          IconButton(
              onPressed: () {
                _resetGame();
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurpleAccent,
              Colors.deepOrangeAccent
            ]
          )
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                (_currentTurn == TileState.CROSS)
                    ? "${widget.user1Name}'s turn"
                    : "${widget.user2Name}'s turn",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: 80,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Stack(
                      children: [
                        Image.asset("assets/images/board.png"),
                        _boardTiles(),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const HomePage()));
                  },
                  child: const Text("Quit Game"))
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _boardTiles() {
    return Builder(builder: (context) {
      final boardDimension = MediaQuery.of(context).size.width;
      final tileDimension = boardDimension / 3;
      return SizedBox(
        height: boardDimension,
        width: boardDimension,
        child: Column(
            children: chunk(_boardState, 3).asMap().entries.map((entry) {
          final chunkIndex = entry.key;
          final tileStateChunk = entry.value;
          return Row(
              children: tileStateChunk.asMap().entries.map((innerEntry) {
            final innerIndex = innerEntry.key;
            final tileState = innerEntry.value;
            final tileIndex = (chunkIndex * 3) + innerIndex;
            return BoardTile(
                dimension: tileDimension,
                onPressed: () => updateTileStateForIndex(tileIndex),
                tileState: tileState);
          }).toList());
        }).toList()),
      );
    });
  }

  void updateTileStateForIndex(int index) {
    if (_boardState[index] == TileState.EMPTY) {
      setState(() {
        _boardState[index] = _currentTurn;
        _currentTurn = _currentTurn == TileState.CROSS
            ? TileState.CIRCLE
            : TileState.CROSS;
      });

      final winner = _findWinner();
      if (winner != null) {
        if(winner == TileState.CROSS){
          user1Won++;
        }else if(winner == TileState.CIRCLE){
          user2Won++;
        }else if(winner == TileState.EMPTY){
          draw++;
        }
        _showWinnerDialog(winner);
      }
    }
  }

  TileState? _findWinner() {
    TileState? Function(int, int, int) winnerForMatch = (a, b, c) {
      if (_boardState[a] != TileState.EMPTY) {
        if ((_boardState[a] == _boardState[b]) &&
            (_boardState[b] == _boardState[c])) {
          return _boardState[a];
        }
      }
      return null;
    };

    final checks = [
      winnerForMatch(0, 1, 2),
      winnerForMatch(3, 4, 5),
      winnerForMatch(6, 7, 8),
      winnerForMatch(0, 3, 6),
      winnerForMatch(1, 4, 7),
      winnerForMatch(2, 5, 8),
      winnerForMatch(0, 4, 8),
      winnerForMatch(2, 4, 6),
    ];

    TileState? winner;
    for (int i = 0; i < checks.length; i++) {
      if (checks[i] != null) {
        winner = checks[i]!;
        break;
      }
    }

    if (!_boardState.contains(TileState.EMPTY)) {
      return TileState.EMPTY;
    }

    return winner;
  }

  void _showWinnerDialog(TileState tileState) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return (tileState == TileState.EMPTY)
              ? AlertDialog(
                  title: const Text('Draw'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          _resetGame();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => ScoreCard(
                              user1Name: widget.user1Name,
                              user2Name: widget.user2Name,
                              user1Won: user1Won,
                              user2Won: user2Won,
                              draw: draw,
                            ))
                          );
                        },
                        child: const Text("Check Score Card")),
                    TextButton(
                        onPressed: () {
                          _resetGame();
                          Navigator.of(context).pop();
                        },
                        child: const Text("New Game"))
                  ],
                )
              : AlertDialog(
                  title: Text((tileState == TileState.CROSS)
                      ? '${widget.user1Name} is winner'
                      : '${widget.user2Name} is winner'),
                  content: Image.asset(tileState == TileState.CROSS
                      ? 'assets/images/x.png'
                      : 'assets/images/o.png'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          _resetGame();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => ScoreCard(
                                user1Name: widget.user1Name,
                                user2Name: widget.user2Name,
                                user1Won: user1Won,
                                user2Won: user2Won,
                                draw: draw,
                              ))
                          );
                        },
                        child: const Text("Check Score Card")),
                    TextButton(
                        onPressed: () {
                          _resetGame();
                          Navigator.of(context).pop();
                        },
                        child: const Text('New Game'))
                  ],
                );
        });
  }

  void _resetGame() {
    setState(() {
      _boardState = List.filled(9, TileState.EMPTY);
      _currentTurn = TileState.CROSS;
    });
  }
}
