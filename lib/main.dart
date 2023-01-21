import 'package:esflix/carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    final items = [
      "https://static.actu.fr/uploads/2021/01/cine-affiche-tenet.jpg",
      "https://static.actu.fr/uploads/2021/01/cine-affiche-tenet.jpg",
      "https://static.actu.fr/uploads/2021/01/cine-affiche-tenet.jpg",
      "https://static.actu.fr/uploads/2021/01/cine-affiche-tenet.jpg",
      "https://static.actu.fr/uploads/2021/01/cine-affiche-tenet.jpg",
      "https://static.actu.fr/uploads/2021/01/cine-affiche-tenet.jpg",
      "https://static.actu.fr/uploads/2021/01/cine-affiche-tenet.jpg",
      "https://static.actu.fr/uploads/2021/01/cine-affiche-tenet.jpg",
      "https://static.actu.fr/uploads/2021/01/cine-affiche-tenet.jpg",
      "https://static.actu.fr/uploads/2021/01/cine-affiche-tenet.jpg",
      "https://static.actu.fr/uploads/2021/01/cine-affiche-tenet.jpg",
      "https://static.actu.fr/uploads/2021/01/cine-affiche-tenet.jpg",
    ];

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: 200,
          child: Carousel(
            items: items,
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
