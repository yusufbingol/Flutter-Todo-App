import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/Model/todo_model.dart';
import 'package:todo_app/pages/add_todo.dart';
import 'package:todo_app/pages/edit_todo.dart';
import 'package:todo_app/Helpers/database_helper.dart';
import 'package:badges/badges.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map selectedItems = {};
  List todoList = [];
  bool isLoading = true;
  DatabaseHelper instance = DatabaseHelper.instance;
  void getTodosfromApi() async {
    http
        .get(Uri.parse("https://jsonplaceholder.typicode.com/todos"))
        .then((value) {
      setState(() {
        todoList = json.decode(value.body);
        isLoading = false;
      });
    });
  }

  showSnackBar(String val) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              val,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
            Icon(
              Icons.delete_rounded,
              color: Colors.red,
              size: 25.0,
            )
          ],
        ),
      ),
    ));
  }

  void getTodosfromDb() async {
    await instance.getTodoMapList().then((value) {
      setState(() {
        todoList = value;
        isLoading = false;
      });
    });
  }

  void deleteTodoFromDb() async {
    List<int> ids = [];
    selectedItems.forEach((key, value) {
      ids.add(value);
    });
    await instance.deleteTodo(ids).then((value) {
      selectedItems.clear();
      ids.clear();
      getTodosfromDb();
      showSnackBar('Successfully Deleted');
    });
  }

  void changeTodo(Map<String, dynamic> todo) async {
    Todo item = Todo.fromMap(todo);
    if (item.status == 1) {
      item.status = 0;
    } else {
      item.status = 1;
    }
    instance.updateTodo(item).then((value) => getTodosfromDb());
  }

  @override
  void initState() {
    super.initState();
    getTodosfromDb();
  }

  Widget exitApp() {
    if (todoList.length > 0) {
      return WillPopScope(
        onWillPop: _onBackPressed,
        child: new Scaffold(),
      );
    }
    return Text('');
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: Text("NO"),
          ),
          SizedBox(height: 16),
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(true),
            child: Text("YES"),
          ),
        ],
      ),
    ).then((value) => value ?? false);
  }

  Widget _buildWelcome() {
    // Eğer listede görev yoksa bir karşılama ekranı gösterecek
    if (todoList.length == 0) {
      return new Container(
        constraints: BoxConstraints(
            minWidth: 100, maxWidth: 330, minHeight: 100, maxHeight: 400),
        margin: const EdgeInsets.only(top: 50.0),
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(30),
          border: Border.all(width: 3),
        ),
        child: Container(
          child: Column(
            children: [
              Image.asset(
                'assets/splash.png',
                fit: BoxFit.fitWidth,
                width: 250,
              ),
              Text(
                'Welcome',
                style: GoogleFonts.raleway(
                    fontWeight: FontWeight.bold, fontSize: 34),
                textAlign: TextAlign.center,
              ),
              Text(
                'To add a new task, click the add button below.',
                style: GoogleFonts.raleway(
                    fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
    return new Text('');
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: null,
        title: Text("Quinlan's Todo App"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: selectedItems.length > 0
              ? Colors.red[400]
              : Theme.of(context).primaryColor,
          child: Icon(
            selectedItems.length > 0 ? Icons.delete : Icons.add,
          ),
          onPressed: () {
            if (selectedItems.length > 0) {
              deleteTodoFromDb();
            } else {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => AddTodo()));
            }
          }),
      body: Column(
        children: <Widget>[
          _buildWelcome(),
          WillPopScope(
            // WillPopScope: Geri düğmesini kontrol eden widget
            onWillPop: _onBackPressed,
            child: Flexible(
              child: !isLoading
                  ? ListView.builder(
                      itemCount: todoList.length,
                      // itemCount: null,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> item = todoList[index];
                        return new ListTile(
                          title: Padding(
                            padding: EdgeInsets.only(bottom: 6.0),
                            child: Text(item['title']),
                          ),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => new EditTodo(item))),
                          isThreeLine: true,
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 4.0, right: 3.0, bottom: 4.0),
                                child: Badge(
                                    animationType: BadgeAnimationType.slide,
                                    animationDuration:
                                        Duration(milliseconds: 650),
                                    badgeContent: Text(
                                      item['date'].toString().split(' ')[0] +
                                          " " +
                                          item['date']
                                              .toString()
                                              .split(' ')[1]
                                              .split(":")[0] +
                                          ":" +
                                          item['date']
                                              .toString()
                                              .split(' ')[1]
                                              .split(":")[1],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    badgeColor: Theme.of(context).primaryColor,
                                    shape: BadgeShape.square,
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 0),
                                child: item['priority'].isEmpty
                                    ? null
                                    : Badge(
                                        animationType: BadgeAnimationType.slide,
                                        animationDuration:
                                            Duration(milliseconds: 650),
                                        badgeContent: Text(
                                          item['priority'],
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        badgeColor: (() {
                                          switch (item['priority']) {
                                            case 'Medium':
                                              return Colors.indigoAccent;
                                            case 'High':
                                              return Colors.red;

                                            default:
                                              return Colors.green;
                                          }
                                        }()),
                                        shape: BadgeShape.square,
                                        borderRadius: BorderRadius.circular(8)),
                              )
                            ],
                          ),
                          leading: IconButton(
                            padding: EdgeInsets.only(bottom: 10),
                            icon: Icon(
                              item['status'] == 1 ? Icons.done : Icons.update,
                              color: item['status'] == 1
                                  ? Colors.green
                                  : Colors.yellow[900],
                              size: 40.0,
                            ),
                            onPressed: () => changeTodo(item),
                          ),
                          trailing: Checkbox(
                            value: selectedItems[index] == null ? false : true,
                            onChanged: (value) {
                              setState(() {
                                if (selectedItems[index] == null) {
                                  selectedItems[index] = item['id'];
                                } else {
                                  selectedItems.remove(index);
                                }
                              });
                            },
                          ),
                        );
                      },
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
