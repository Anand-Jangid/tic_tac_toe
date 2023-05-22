import 'package:flutter/material.dart';
import 'package:tic_tac_toe/screens/play_page.dart';
import 'package:tic_tac_toe/screens/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final List<BottomNavigationBarItem> _bottomNavigationBarItems = const [
    BottomNavigationBarItem(
        icon: Icon(Icons.games),
        label: 'Play'
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Profile',
    )
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int _selectedIndex = 0;

  final _buildBody = <Widget>[PlayPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _buildBody,),
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomNavigationBarItems,
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
      ),
    );
  }
}
