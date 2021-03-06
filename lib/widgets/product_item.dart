import 'package:flutter/material.dart';
import '/models/app_state.dart';
import '/models/product.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ProductItem extends StatelessWidget {
  final Product item;
  ProductItem({required this.item});

  @override
  Widget build(BuildContext context) {
    final String pictureUrl = 'http://localhost:1337${item.picture['url']}';
    return GridTile(
        footer: GridTileBar(
            title: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(item.name, style: TextStyle(fontSize: 20.0))),
            subtitle: Text("\$${item.price}", style: TextStyle(fontSize: 16.0)),
            backgroundColor: Color(0xBB000000),
            trailing: StoreConnector<AppState, AppState>(
                converter: (store) => store.state,
                builder: (_, state) {
                  return state.user != null
                      ? IconButton(
                          icon: Icon(Icons.shopping_cart),
                          color: Colors.white,
                          onPressed: () => print('pressed'))
                      : Text('');
                })),
        child: Image.network(pictureUrl, fit: BoxFit.cover));
  }
}
