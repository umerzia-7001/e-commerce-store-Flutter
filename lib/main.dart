import 'package:flutter/material.dart';
import 'helpers/colors.dart' as color;
import 'screens/products_page.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'models/app_state.dart';
import 'redux/actions.dart';
import 'redux/reducers.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

void main() {
  final store = Store<AppState>(appReducer,
      initialState: AppState.initial(), middleware: [thunkMiddleware]);
  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;
  MyApp({required this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: store,
        child: MaterialApp(
            title: 'Flutter E-Commerce',
            routes: {
              '/': (BuildContext context) => ProductsPage(onInit: () {
                    StoreProvider.of<AppState>(context).dispatch(getUserAction);
                    StoreProvider.of<AppState>(context)
                        .dispatch(getProductsAction);
                  }),
              '/login': (BuildContext context) => LoginPage(),
              '/register': (BuildContext context) => RegisterPage()
            },
            theme: ThemeData(
                brightness: Brightness.dark,
                primaryColor: color.Palette.mainScheme,
                accentColor: color.Palette.secondaryTheme,
                textTheme: TextTheme(
                    headline1:
                        TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
                    headline2:
                        TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
                    bodyText1: TextStyle(fontSize: 18.0))),
            ));
  }
}
