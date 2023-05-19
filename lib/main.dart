import 'package:flutter/material.dart';
import 'package:tic_tac_toe/board_tile.dart';
import 'package:tic_tac_toe/tile_state.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  // final navigatorKey = GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Pacifico-Regular',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Screen1(),
    );
  }
}

class Screen1 extends StatefulWidget {
  const Screen1({Key? key}) : super(key: key);

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  final _formKey = GlobalKey<FormState>();
  final user1Controller = TextEditingController();
  final user2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Form(
            key: _formKey,
            child: Card(
              child: Column(
                children: [
                  Text("Welcome to Tic Tac Toe Game", style: Theme.of(context).textTheme.headlineLarge!.copyWith(color: Colors.deepPurple),),
                  SizedBox(height: 20,),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: user1Controller,
                    decoration: InputDecoration(
                      hintText: "Enter user1 name",
                      labelText: "User 1",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                    ),
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return "Please enter the name";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: user2Controller,
                    decoration: InputDecoration(
                      hintText: "Enter user2 name",
                      labelText: "User 2",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )
                    ),
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return "Please enter the name";
                      }
                      return null;
                    },
                  ),
                  Spacer(),
                  ElevatedButton(
                      onPressed: (){
                        if(_formKey.currentState!.validate()){
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyHomePage(
                            user1Name: user1Controller.text,
                            user2Name: user2Controller.text,
                          )));
                        }
                      },
                      child: Text("SUBMIT"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.user1Name, required this.user2Name});
  final String user1Name;
  final String user2Name;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  var _boardState = List.filled(9, TileState.EMPTY);
  var _currentTurn = TileState.CROSS;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Tic Tac Toe"),
        actions: [
          IconButton(
              onPressed: (){
                _resetGame();
              },
              icon: Icon(Icons.refresh))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text((_currentTurn == TileState.CROSS) ? "${widget.user1Name} turn" : "${widget.user2Name} turn", style: Theme.of(context).textTheme.headlineMedium,),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Stack(
                children:[
                   Image.asset("assets/images/board.png"),
                  _boardTiles(),
                ],
              ),
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _boardTiles(){
    return Builder(
        builder: (context){
          final boardDimension = MediaQuery.of(context).size.width ;
          final tileDimension = boardDimension / 3;
          return Container(
            height: boardDimension,
            width: boardDimension,
            child: Column(
              children: chunk(_boardState, 3).asMap().entries.map((entry) {
                final chunkIndex = entry.key;
                final tileStateChunk = entry.value;
                return Row(children: tileStateChunk.asMap().entries.map((innerEntry) {
                  final innerIndex = innerEntry.key;
                  final tileState = innerEntry.value;
                  final tileIndex = (chunkIndex * 3) + innerIndex;
                  return BoardTile(
                      dimension: tileDimension,
                      onPressed: () => updateTileStateForIndex(tileIndex),
                      tileState: tileState);
                }).toList());
              }).toList()
            ),
          );
        });
  }

  void updateTileStateForIndex(int index){
    if(_boardState[index] == TileState.EMPTY){
      setState(() {
        _boardState[index] = _currentTurn;
        _currentTurn = _currentTurn == TileState.CROSS
            ? TileState.CIRCLE
            : TileState.CROSS;
      });

      final winner = _findWinner();
      if(winner != null){
        print('Winner is ${winner}');
        _showWinnerDialog(winner);
      }
    }
  }

  TileState? _findWinner(){

    TileState? Function(int, int, int) winnerForMatch = (a,b,c){
      if(_boardState[a] != TileState.EMPTY){
        if((_boardState[a] == _boardState[b]) && (_boardState[b] == _boardState[c])){
          return _boardState[a];
        }
      }
      return null;
    };

    final checks =[
      winnerForMatch(0,1,2),
      winnerForMatch(3,4,5),
      winnerForMatch(6,7,8),
      winnerForMatch(0,3,6),
      winnerForMatch(1,4,7),
      winnerForMatch(2,5,8),
      winnerForMatch(0,4,8),
      winnerForMatch(2,4,6),
    ];

    TileState? winner;
    for(int i=0; i < checks.length; i++){
      if(checks[i] != null){
        winner = checks[i]!;
        break;
      }
    }

    if(!_boardState.contains(TileState.EMPTY)){
      return TileState.EMPTY;
    }

    return winner;
  }

  void _showWinnerDialog(TileState tileState){
    showDialog(
        context: context,
        builder:(context){
          return (tileState == TileState.EMPTY)
          ? AlertDialog(
            title: Text('Draw'),
            actions: [
              TextButton(
                  onPressed: (){
                    _resetGame();
                    Navigator.of(context).pop();
                  },
                  child: Text("New Game")
              )
            ],
          )
          : AlertDialog(
            title: Text((tileState == TileState.CROSS) ? '${widget.user1Name} Winner' : '${widget.user2Name} Winner'),
            content: Image.asset(tileState == TileState.CROSS ? 'assets/images/x.png' : 'assets/images/o.png'),
            actions: [
              TextButton(
                  onPressed: (){
                    _resetGame();
                    Navigator.of(context).pop();
                  },
                  child: Text('New Game')
              )
            ],
          );
        }
    );
  }

  void _resetGame(){
    setState(() {
      _boardState = List.filled(9, TileState.EMPTY);
      _currentTurn = TileState.CROSS;
    });
  }
}
