import 'package:flutter/material.dart';
import 'package:flutter_animator_widgets/flutter_animator_widgets.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<FlyOutMenuState> _flyoutMenuKey = GlobalKey<FlyOutMenuState>();
  List<String> buttonLabels =
      List<String>.generate(4, (index) => "Button ${index + 1}");
  List<Widget> buttons = [];

  String? pressedItem;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        buttons = buttonLabels
            .map((label) => ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Theme.of(context).buttonColor)),
                  onPressed: () {
                    setState(() {
                      pressedItem = label;
                    });
                    _flyoutMenuKey.currentState!.close();
                  },
                  child: Text(label),
                ))
            .toList();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Center(
        child: Text(pressedItem != null
            ? "Last pressed: $pressedItem"
            : "No items pressed"),
      ),
      floatingActionButton: FlyOutMenu(
        key: _flyoutMenuKey,
        buttons: buttons,
        animation: FlyOutAnimation.flipperCard,
        defaultIcon: Icons.add,
        activeIcon: Icons.close,
      ),
    );
  }
}
