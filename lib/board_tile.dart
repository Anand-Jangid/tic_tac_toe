import 'package:flutter/material.dart';
import 'package:tic_tac_toe/models/tile_state.dart';

class BoardTile extends StatelessWidget {
  final double dimension;
  final VoidCallback onPressed;
  final TileState tileState;

  const BoardTile({Key? key, required this.dimension, required this.onPressed, required this.tileState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: dimension,
      width: dimension,
      child: MaterialButton(
        onPressed: onPressed,
        child: _widgetForTileState(),
      ),
      
    );
  }

  Widget _widgetForTileState(){
    Widget widget;

    switch(tileState){
      case TileState.EMPTY:
        {
          widget = Container();
        }
        break;
      case TileState.CIRCLE:
        {
          widget = Image.asset("assets/images/o.png");
        }
        break;
      case TileState.CROSS:
        {
          widget = Image.asset('assets/images/x.png');
        }
        break;
    }
    return widget;
  }
}
