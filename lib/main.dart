import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'TODO App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _todos = [
    {"name": "hello"},
  ];

  var _completedTodos = [];

  void _addTodo(value) {
    setState(() {
      _todos.add({"name": value});
    });
  }

  void _removeTodo(index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  void _updateTodo(text, index) {
    setState(() {
      _todos[index]['name'] = text;
    });
  }

  void _completeTodo(index) {
    setState(() {
      _completedTodos.add(_todos[index]);
      _todos.removeAt(index);
    });
  }

  void _undoTodo(index) {
    setState(() {
      _todos.add(_completedTodos[index]);
      _completedTodos.removeAt(index);
    });
  }

  void _askAdd(String titleText, String type, {index}) {
    final TextEditingController todoTextController = TextEditingController();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(titleText, locale: Locale('ja')),
            children: <Widget>[
              TextField(
                controller: todoTextController,
                decoration: InputDecoration(
                    hintText: "イヌの散歩",
                    contentPadding: const EdgeInsets.all(20.0)),
                keyboardType: TextInputType.text,
              ),
              FlatButton(
                child: Text('追加'),
                onPressed: () {
                  if (type == 'add') {
                    _addTodo(todoTextController.text);
                  } else if (type == 'update') {
                    _updateTodo(todoTextController.text, index);
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: Text(widget.title),
                centerTitle: true,
                bottom: TabBar(
                  tabs: [
                    Tab(
                      icon: Icon(Icons.work),
                      text: 'TODO',
                    ),
                    Tab(
                      icon: Icon(Icons.thumb_up),
                      text: 'DONE',
                    ),
                  ],
                ),
              ),
              body: TabBarView(children: [
                ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
                      child: Container(
                        color: Colors.white,
                        child: ListTile(
                          title: Text(
                            _todos[index]['name'],
                            style: TextStyle(fontSize: 22.0),
                          ),
                        ),
                      ),
                      actions: <Widget>[
                        IconSlideAction(
                          caption: 'Delete',
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: () => _removeTodo(index),
                        ),
                        IconSlideAction(
                          caption: 'Update',
                          color: Colors.green,
                          icon: Icons.update,
                          onTap: () =>
                              _askAdd('変更後のタスク名を入力', 'update', index: index),
                        ),
                      ],
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: 'Done',
                          color: Colors.blue,
                          icon: Icons.thumb_up,
                          onTap: () => _completeTodo(index),
                        ),
                      ],
                    );
                  },
                  itemCount: _todos.length,
                ),
                ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
                      child: Container(
                        color: Colors.white,
                        child: ListTile(
                          title: Text(
                            _completedTodos[index]['name'],
                            style: TextStyle(fontSize: 22.0),
                          ),
                        ),
                      ),
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: 'Undo',
                          color: Colors.purple,
                          icon: Icons.backspace,
                          onTap: () => _undoTodo(index),
                        ),
                      ],
                    );
                  },
                  itemCount: _completedTodos.length,
                ),
              ]),
              floatingActionButton: FloatingActionButton(
                onPressed: () => _askAdd('タスクを入力', 'add'),
                tooltip: 'Increment',
                child: Icon(Icons.add),
              ),
            )));
  }
}
