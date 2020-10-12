import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/item.dart';
import 'package:todo_app/screens/add_todo_task.dart';

class HomePageScreen extends StatefulWidget {
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[50],
      appBar: AppBar(
        title: const Text("To Do App"),
      ),
      body: FutureBuilder(
        future: Provider.of<ItemsList>(context, listen: false).fetchTasks(),
        builder: (ctx, snapshot) => (snapshot.connectionState ==
                ConnectionState.waiting)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<ItemsList>(
                child: Center(
                  child: Text(
                    'No Tasks added !',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                builder: (ctx, itemData, ch) => itemData.items.length <= 0
                    ? ch
                    : ListView.builder(
                        itemCount: itemData.items.length,
                        itemBuilder: (ctx, i) {
                          Items items = itemData.items[i];
                          return Container(
                            margin: const EdgeInsets.only(top: 5),
                            height: 110,
                            child: Dismissible(
                              key: ValueKey(items.id),
                              background: Container(
                                color: Theme.of(context).errorColor,
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                padding: const EdgeInsets.only(right: 20),
                                alignment: Alignment.centerRight,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 4,
                                ),
                              ),
                              direction: DismissDirection.endToStart,
                              confirmDismiss: (direction) {
                                return showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Are you sure !'),
                                    content: const Text(
                                        'You want to remove this entry ?'),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop(false);
                                        },
                                        child: Text('No'),
                                      ),
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop(true);
                                        },
                                        child: Text('Yes'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              onDismissed: (direction) {
                                setState(() {
                                  Provider.of<ItemsList>(context, listen: false)
                                      .removeItem(
                                    items.id,
                                  );
                                });
                              },
                              child: Container(
                                height: 110,
                                child: TaskItem(
                                  items: items,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(
            AddToDoScreen.routeName,
          );
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}

class TaskItem extends StatefulWidget {
  TaskItem({
    Key key,
    @required this.items,
  }) : super(key: key);

  final Items items;

  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Task done ?'),
            content:
                const Text('You want to remove this task from To-Do List ?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text('No'),
              ),
              FlatButton(
                onPressed: () {
                  setState(() {
                    Provider.of<ItemsList>(context, listen: false).removeItem(
                      widget.items.id,
                    );
                  });
                  Navigator.of(ctx).pop();
                },
                child: Text('Yes'),
              ),
            ],
          ),
        );
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(10),
          title: Text(widget.items.title),
          subtitle: Text(widget.items.description),
          trailing: (widget.items.date == null || widget.items.time == null)
              ? Text('')
              : Text(
                  'Due By:' +
                      '\n' +
                      '${widget.items.time.toString().substring(10, 15)},' +
                      '\n' +
                      '${DateFormat.yMMMd().format(DateTime.parse(widget.items.date))}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 4,
                ),
        ),
      ),
    );
  }
}
