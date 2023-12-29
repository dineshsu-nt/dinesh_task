import 'package:dinesh_project/screens/home_screen.dart';
import 'package:dinesh_project/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class BnbScreen extends StatefulWidget {
  BnbScreen({super.key, this.selectedIndex});
  int? selectedIndex = 0;
  @override
  _BnbScreenState createState() => _BnbScreenState();
}

class _BnbScreenState extends State<BnbScreen> {
  final List<Widget> _widgetOptions = <Widget>[HomeScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: widget.selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Task',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: widget.selectedIndex!,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      widget.selectedIndex = index;
    });
  }
}
