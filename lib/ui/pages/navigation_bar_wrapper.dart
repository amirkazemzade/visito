import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visito_new/ui/pages/history_page.dart';

import 'home_page.dart';

class NavigationBarWrapper extends StatefulWidget {
  const NavigationBarWrapper({Key? key}) : super(key: key);

  @override
  _NavigationBarWrapperState createState() => _NavigationBarWrapperState();
}

class _NavigationBarWrapperState extends State<NavigationBarWrapper> {
  int _selectedPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedPageIndex == 0 ? const HomePage() : const HistoryPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          )
        ],
        currentIndex: _selectedPageIndex,
        onTap: (index) {
          setState(() {
            _selectedPageIndex = index;
          });
        },
      ),
    );
  }
}
