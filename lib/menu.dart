import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  @override
  State<MenuPage> createState() => MenuPageState();
}

class MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('เมนู')),
    body: Center(child:
      Column(children: [
        SizedBox(height: 30),
        Text(
            'Menu Page\n\nกำหนดเมนูตามต้องการ',
            textScaleFactor: 1.8,
            textAlign: TextAlign.center
        ),
      ]),
    ),
  );
}
