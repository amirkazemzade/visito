import 'package:flutter/material.dart';
import 'package:visito_new/ui/pages/home_page.dart';
import 'package:visito_new/ui/pages/login_page.dart';
import 'package:visito_new/ui/pages/store_page.dart';

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();
void main() async {
  runApp(
    MaterialApp(
      title: 'Visito',
      initialRoute: '/login',
      navigatorObservers: [routeObserver],
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/store': (context) => const StorePage(),
      },
    ),
  );
}
