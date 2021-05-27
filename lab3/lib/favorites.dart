import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  final Set<Color> colors;

  FavoritesPage(this.colors);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Favorites'),
        ),
        body: ListView.builder(
          itemCount: colors.length,
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemBuilder: (context, index) =>
              FavoriteItemTile(colors.elementAt(index)),
        ));
  }
}

class FavoriteItemTile extends StatelessWidget {
  final Color color;

  FavoriteItemTile(this.color);

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
      ),
    );
  }
}
