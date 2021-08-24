import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/pages/add_todo.dart';
import 'package:todo_app/Helpers/database_helper.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //List list = ['deneme', 'denem 2', 'deneme 3', 'falan', 'filan'];
  /* List assocArr = [
    {'title': 'Deneme title 1', 'desc': 'description deneme 1'},
    {'title': 'Deneme title 2', 'desc': 'description deneme 2'},
  ]; */
  Map selectedItems = {};
  List todoList = [];
  bool isLoading = true;

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

  void getTodosfromDb() async {
    DatabaseHelper instance = DatabaseHelper.instance;
    await instance.getTodoMapList().then((value) {
      setState(() {
        todoList = value;
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    //getTodosfromApi();
    getTodosfromDb();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => AddTodo()))),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: !isLoading
                  ? ListView.builder(
                      itemCount: todoList.length,
                      itemBuilder: (context, index) {
                        Map item = todoList[index];
                        return new ListTile(
                          title: Text(item['title']),
                          isThreeLine: true,
                          subtitle: Text(item['date'].toString().split(' ')[0] +
                              "-" +
                              item['priority']),
                          leading: Icon(
                            item['status'] == 1 ? Icons.done : Icons.update,
                            color: item['status'] == 1
                                ? Colors.green
                                : Colors.amber,
                          ),
                          trailing: Checkbox(
                            value: selectedItems[index] == null
                                ? false
                                : selectedItems[index],
                            onChanged: (value) {
                              setState(() {
                                if (selectedItems[index] == null) {
                                  selectedItems[index] = true;
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
          ],
        ),
      ),
    );
  }
}
