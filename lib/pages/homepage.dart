import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  List todoList = [];

  void getTodosfromApi() async {
    http
        .get(Uri.parse("https://jsonplaceholder.typicode.com/todos"))
        .then((value) {
      setState(() {
        todoList = json.decode(value.body);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getTodosfromApi();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quinlan's Todo App"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.add),
          onPressed: () {
            //print('Ekle');
          }),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
                child: ListView.builder(
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                Map item = todoList[index];
                return new ListTile(
                  title: Text(item['title']),
                  isThreeLine: true,
                  subtitle:
                      Text(item['completed'] ? 'Tamamlandı' : 'Tamamlanmadı!'),
                  leading: Icon(item['completed'] ? Icons.done : Icons.update),
                  trailing: Checkbox(
                    value: false,
                    onChanged: (value) {},
                  ),
                );
              },
            ))
          ],
        ),
      ),
    );
  }
}
