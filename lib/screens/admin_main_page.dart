import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:p/models/user_model.dart';
import 'package:p/widgets/my_drawer_widget.dart';
import 'package:p/widgets/profile_widget.dart';
import 'package:p/widgets/user_list_widget.dart';
import '../widgets/admin_poem_list.dart';
import '../widgets/user_list_widget.dart';

class AdminDashboardPage extends ConsumerStatefulWidget {
  @override
  _AdminDashboardPageState createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends ConsumerState<AdminDashboardPage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    AdminPoemsScreen(),
    AdminUsersScreen()
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
          'Admin Dashboard',
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/add_poem');
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue[900],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Poems',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'users',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[900],
        onTap: _onItemTapped,
      ),
    );
  }
}
