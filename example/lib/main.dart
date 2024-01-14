import 'package:flutter/material.dart';
import 'package:tutorial/tutorial.dart';

void main() {
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Tutorial coach mark example'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey firstKey = GlobalKey();
  final GlobalKey secondKey = GlobalKey();
  final GlobalKey thirdKey = GlobalKey();
  final GlobalKey fourthKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TutorialItem(
              key: firstKey,
              child: const TestWidget(),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TutorialItem(
                    key: thirdKey,
                    child: const TestWidget(),
                  ),
                  TutorialItem(
                    key: fourthKey,
                    child: const TestWidget(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TutorialItem(
              key: secondKey,
              child: const TestWidget(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Tutorial.of(context)
            ..messageDecoration = BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8))
            ..messagePadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
            ..triangleSize = const Size(14, 10)
            ..horizontalPadding = 32
            ..start(
              [
                [TutorialItemMessage(targetKey: firstKey, message: 'This is a first item')],
                [TutorialItemMessage(targetKey: secondKey, foregroundColor: Colors.white, message: 'This is a second item')],
                [
                  TutorialItemMessage(targetKey: thirdKey, foregroundColor: Colors.white, message: 'this is a third item'),
                  TutorialItemMessage(targetKey: fourthKey, foregroundColor: Colors.red, message: 'this is a fourth item'),
                ],
              ],
            );
        },
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}

class TestWidget extends StatelessWidget {
  const TestWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
