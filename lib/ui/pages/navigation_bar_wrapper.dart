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
  final pages = [
    const HomePage(),
    const HistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedPageIndex,
        children: pages,
      ),
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
          if (index == _selectedPageIndex) {
            switch (index) {
              case 0:
                setState(() {
                  pages[0] = const HomePage();
                });
                break;
              case 1:
                setState(() {
                  pages[1] = const HistoryPage();
                });
                break;
            }
          }
          setState(() {
            _selectedPageIndex = index;
          });
        },
      ),
    );
  }
}
