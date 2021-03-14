import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solutions_challenge/providers/map_provider.dart';
import 'package:solutions_challenge/screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => MapProvider.initialize())
    ],
    child: MaterialApp(
      title: "App",
      home: MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      routes: {
        '/': (context) => Home(),
      },
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
    );
  }
}
