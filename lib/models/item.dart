import 'package:flutter/material.dart';
import 'package:todo_app/helper/db_helper.dart';

class Items {
  final String id;
  final String title;
  final String description;
  final String date;
  final String time;

  Items({
    this.id,
    this.title,
    this.description,
    this.date,
    this.time,
  });
}

class ItemsList with ChangeNotifier {
  List<Items> _items = [];

  List<Items> get items {
    return _items;
  }

  Items findById(String id) {
    return _items.firstWhere(
      (item) => item.id == id,
    );
  }

  Future<void> addItem(Items item, String chosenDate, String chosenTime) async {
    final newItem = Items(
      id: DateTime.now().toIso8601String(),
      title: item.title,
      description: item.description,
      date: chosenDate.toString(),
      time: chosenTime.toString(),
    );
    _items.add(newItem);
    notifyListeners();
    DBHelper.insert('todo_tasks', {
      'id': newItem.id,
      'title': newItem.title,
      'description': newItem.description,
      'date': newItem.date ?? '',
      'time': newItem.time ?? '',
    });
  }

  Future<void> fetchTasks() async {
    final dataList = await DBHelper.getData('todo_tasks');
    _items = dataList
        .map((item) => Items(
              id: item['id'],
              title: item['title'],
              description: item['description'],
              date: item['date'] ?? null,
              time: item['time'] ?? null,
            ))
        .toList();
    notifyListeners();
  }

  Future<void> removeItem(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    _items.removeAt(index);
    notifyListeners();
    DBHelper.delete('todo_tasks', id);
  }
}
