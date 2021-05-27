import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lab3/favorites.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab3-1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Set<Color> colors = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Color picker'),
        actions: <Widget>[
          TextButton.icon(
            style: TextButton.styleFrom(primary: Colors.white),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FavoritesPage(colors)));
            },
            icon: Icon(Icons.favorite),
            label: Text('Favorites'),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 100,
        cacheExtent: 20.0,
        controller: ScrollController(),
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemBuilder: (context, index) =>
            ItemTile((Color c) => colors.add(c), (Color c) => colors.remove(c)),
      ),
    );
  }
}

class ItemTile extends StatefulWidget {
  final Function add;
  final Function remove;

  ItemTile(this.add, this.remove);

  @override
  State<StatefulWidget> createState() => _ItemTileState(add, remove);
}

class _ItemTileState extends State<ItemTile> {
  Color color = ColorGen.next();
  bool isFav = false;
  Function add;
  Function remove;

  _ItemTileState(this.add, this.remove);

  @override
  Widget build(BuildContext context) {
    var c = color.value.toRadixString(16).padLeft(6, '0');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
        ),
        title: Text(
          '#$c',
        ),
        trailing: IconButton(
            icon: isFav ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
            onPressed: () => _toggleFav()),
      ),
    );
  }

  void _toggleFav() {
    setState(() {
      if (isFav) {
        isFav = false;
        remove(color);
      } else {
        isFav = true;
        add(color);
      }
    });
  }
}

class ColorGen {
  static Random rng = new Random();
  static Color next() => Color.fromARGB(
      0xff, rng.nextInt(0xff), rng.nextInt(0xff), rng.nextInt(0xff));
}
