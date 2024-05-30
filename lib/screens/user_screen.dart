import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:p/widgets/my_drawer_widget.dart';
import 'package:p/widgets/profile_widget.dart';
import '../widgets/poems_list.dart';
import 'favorite_screen.dart';

class poemsScreenPage extends ConsumerStatefulWidget {
  @override
  _PoemsScreenPageState createState() => _PoemsScreenPageState();
}

class _PoemsScreenPageState extends ConsumerState<poemsScreenPage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    PoemsScreen(),
    FavoriteScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Poems',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      drawer: MyDrawer(),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Profile(),
            SizedBox(height: 20),
            Expanded(child: _widgetOptions.elementAt(_selectedIndex)),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Poems',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[900],
        onTap: _onItemTapped,
      ),
    );
  }
}
