import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:visito_new/ui/pages/home_page.dart';
import 'package:visito_new/ui/pages/login_page.dart';
import 'package:visito_new/ui/pages/navigation_bar_wrapper.dart';
import 'package:visito_new/ui/pages/store_page.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

void main() async {
  await Sentry.init(
    (options) {
      options.dsn =
          'https://150e9f3d783c4f7eb8bf1e14e1a9a4da@o1146657.ingest.sentry.io/6215664';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(
      const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Visito',
      initialRoute: '/login',
      navigatorObservers: [routeObserver],
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/store': (context) => const StorePage(),
        '/navigationBarWrapper': (context) => const NavigationBarWrapper(),
      },
    );
  }
}
