import 'dart:developer' as devtools show log;
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var color1 = Colors.yellow;
  var color2 = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: AvailableColorInherited(
        color1: color1,
        color2: color2,
        child: Column(
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      color1 = colors.getRandomElemet();
                    });
                  },
                  child: const Text('Change color1'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      color2 = colors.getRandomElemet();
                    });
                  },
                  child: const Text('Change color2'),
                ),
              ],
            ),
            const ColorWidget(color: AvailableColor.one),
            const ColorWidget(color: AvailableColor.two),
          ],
        ),
      ),
    );
  }
}

enum AvailableColor { one, two }

class AvailableColorInherited extends InheritedModel<AvailableColor> {
  final MaterialColor color1;
  final MaterialColor color2;

  const AvailableColorInherited({
    super.key,
    required this.color1,
    required this.color2,
    required super.child,
  });

  static AvailableColorInherited of(
      BuildContext context, AvailableColor aspect) {
    return InheritedModel.inheritFrom<AvailableColorInherited>(
      context,
      aspect: aspect,
    )!;
  }

  @override
  bool updateShouldNotify(covariant AvailableColorInherited oldWidget) {
    devtools.log('updateShouldNotify');
    return color1 != oldWidget.color1 || color2 != oldWidget.color2;
  }

  @override
  bool updateShouldNotifyDependent(
    covariant AvailableColorInherited oldWidget,
    Set<AvailableColor> dependencies,
  ) {
    devtools.log('updateShouldNotifyDependent');

    if (dependencies.contains(AvailableColor.one) &&
        color1 != oldWidget.color1) {
      return true;
    }

    if (dependencies.contains(AvailableColor.two) &&
        color2 != oldWidget.color2) {
      return true;
    }

    return false;
  }
}

class ColorWidget extends StatelessWidget {
  final AvailableColor color;

  const ColorWidget({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    switch (color) {
      case AvailableColor.one:
        devtools.log('Color1 widget got rebuilt');
        break;

      case AvailableColor.two:
        devtools.log('Color2 widget got rebuilt');
        break;
    }
    final provider = AvailableColorInherited.of(context, color);
    return Container(
      height: 100,
      color: color == AvailableColor.one ? provider.color1 : provider.color2,
    );
  }
}

final colors = [
  Colors.amber,
  Colors.blue,
  Colors.yellow,
  Colors.green,
  Colors.purple,
  Colors.brown,
  Colors.indigo,
  Colors.red,
  Colors.cyan,
  Colors.deepOrange,
  Colors.teal,
];

extension RandomElement<T> on Iterable<T> {
  T getRandomElemet() {
    return elementAt(Random().nextInt(length));
  }
}
