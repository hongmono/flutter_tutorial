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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TutorialItem(
              key: firstKey,
              child: const TestWidget(),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64.0),
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
            ..tooltipConfig = TooltipConfig(axis: Axis.horizontal)
            ..start(
              [
                [const TutorialMessage(message: 'hi')],
                [TutorialItemMessage(targetKey: firstKey, message: 'This is a first item')],
                [TutorialItemMessage(targetKey: secondKey, message: 'This is a second item')],
                [
                  TutorialItemMessage(
                    targetKey: fourthKey,
                    message:
                        'this is a fourth itemthis is a fourth itemthis is a fourth itemthis is a fourth itemthis is a fourth itemthis is a fourth itemthis is a fourth itemthis is a fourth itemthis is a fourth itemthis is a fourth itemthis is a fourth item',
                  ),
                  TutorialItemMessage(
                    targetKey: thirdKey,
                  ),
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
