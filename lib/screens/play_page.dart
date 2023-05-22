import 'package:flutter/material.dart';
import 'package:tic_tac_toe/screens/game_page.dart';

class PlayPage extends StatefulWidget {
  const PlayPage({Key? key}) : super(key: key);

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  final _formKey = GlobalKey<FormState>();
  final user1Controller = TextEditingController();
  final user2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.deepPurple,
                Colors.deepOrangeAccent
              ]
            )
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 48),
            child: Form(
              key: _formKey,
              child: Card(
                child: Column(
                  children: [
                    const SizedBox(height: 50,),
                    Center(
                      child: Text(
                        "Welcome to \n Tic Tac Toe \n Game",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineLarge!.copyWith(color: Colors.deepPurple),),
                    ),
                    const SizedBox(height: 80,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: user1Controller,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            hintText: "Enter player1 name",
                            labelText: "Player 1",
                            contentPadding: const EdgeInsets.all(8),
                            prefixIcon: Icon(Icons.person, color: Colors.deepPurple.shade400,),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                            )
                        ),
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return "Please enter the name";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: user2Controller,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            hintText: "Enter player2 name",
                            labelText: "Player 2",
                            contentPadding: const EdgeInsets.all(8),
                            prefixIcon: Icon(Icons.person, color: Colors.deepPurple.shade400,),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                            )
                        ),
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return "Please enter the name";
                          }
                          return null;
                        },
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: (){
                        if(_formKey.currentState!.validate()){
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder:
                              (context) => GamePage(
                                user1Name: user1Controller.text,
                                user2Name: user2Controller.text,
                              )));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple.shade800,
                        shadowColor: Colors.deepPurple.shade50,
                      ),
                      child: const Text("Let's Play", style: TextStyle(color: Colors.white),),
                    ),
                    const SizedBox(height: 20,)
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  }
}