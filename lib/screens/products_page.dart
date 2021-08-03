import 'package:e_commerce_app/redux/actions.dart';
import 'package:flutter/material.dart';
import '/models/app_state.dart';
import '/widgets/product_item.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import '/models/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
final gradientBackground = BoxDecoration(
    gradient: LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        stops: [
      0.1,
      0.3,
      0.5,
      0.8,
    ],
        colors: [
      Colors.purple[100]!,
      Colors.purple[200]!,
      Colors.purple[300]!,
      Colors.purple[400]!,
    ]));


class ProductsPage extends StatefulWidget {
  final void Function() onInit;
  ProductsPage({required this.onInit});

  @override
  ProductsPageState createState() => ProductsPageState();
}

 class ProductsPageState extends State<ProductsPage> {
  void initState() {
    super.initState();
    widget.onInit();
  }
                                                            
  final _appBar = PreferredSize(
      preferredSize: Size.fromHeight(60.0),
      child: StoreConnector<AppState, AppState>(
          converter: (store) => store.state,
          builder: (context, state) {
            return AppBar(
                centerTitle: true,
                title: SizedBox(
                    child: state.user != null
                        ? Text(state.user.username)
                        : FlatButton(
                            child: Text('Register Here',
                                style: Theme.of(context).textTheme.bodyText1),
                            onPressed: () =>
                                Navigator.pushNamed(context, '/register'))),
                leading: state.user != null ? Icon(Icons.store) : Text(''),
                actions: [
                  Padding(
                      padding: EdgeInsets.only(right: 12.0),
                      child: StoreConnector<AppState, VoidCallback>(  // logging out activity
                          converter: (store) {
                        return () => store.dispatch(logoutUserAction);
                      }, builder: (_, callback) {
                        return state.user != null
                            ? IconButton(
                                icon: Icon(Icons.exit_to_app),
                                onPressed: callback)
                            : Text('');
                      }))
                ]);
          }));

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
        appBar: _appBar,
        body: Container(
            decoration: gradientBackground,
            child: StoreConnector<AppState, AppState>(
                converter: (store) => store.state,
                builder: (_, state) {
                  return Column(children: [
                    Expanded(
                        child: SafeArea(
                            top: false,
                            bottom: false,
                            child: GridView.builder(
                                itemCount: state.products.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount:
                                            orientation == Orientation.portrait
                                                ? 2
                                                : 3,
                                        crossAxisSpacing: 4.0,
                                        mainAxisSpacing: 4.0,
                                        childAspectRatio:
                                            orientation == Orientation.portrait
                                                ? 1.0
                                                : 1.3),
                                itemBuilder: (context, i) =>
                                    ProductItem(item: state.products[i]))))
                  ]);
                })));
  }
}
