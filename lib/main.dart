import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/item.dart';
import 'package:todo_app/screens/add_todo_task.dart';
import 'package:todo_app/screens/home_page_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: ItemsList(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'To Do App',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomePageScreen(),
        routes: {
          AddToDoScreen.routeName: (ctx) => AddToDoScreen(),
        },
      ),
    );
  }
}
