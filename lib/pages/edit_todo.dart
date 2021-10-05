import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/Helpers/database_helper.dart';
import 'package:todo_app/Model/todo_model.dart';
import 'package:todo_app/pages/homepage.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class EditTodo extends StatefulWidget {
  final Map todoItem;

  EditTodo(this.todoItem);

  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<EditTodo> {
  final _formKey = GlobalKey<FormState>();
  int todoId = 0;
  String _title = '';
  String _priority = '';
  String selectedPriority = 'Low';
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  TextEditingController _dateController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  final DateFormat _dateFormat = DateFormat('dd MMM, yyy').add_Hm();
  final List<String> _priorities = [
    'Low',
    'Medium',
    'High',
    ''
  ]; // Öncelik seçilmemişte edit yapmıyordu. Null string ekledim ve düzeldi.

  _handleDatePicker() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date != null && date != _date) {
      setState(() {
        _date = date;
      });
      _dateController.text = _dateFormat.format(date);
      _handleTimePicker();
    }
  }

  _handleTimePicker() async {
    final time = await showTimePicker(context: context, initialTime: _time);
    if (time != null && time != _time) {
      setState(() {
        _time = time;
      });
      DateTime ndt = DateTime.utc(
          _date.year, _date.month, _date.day, _time.hour, _time.minute, 00);
      _dateController.text = _dateFormat.format(ndt);
      setState(() {
        _date = ndt;
      });
    }
  }

  Future sendForm() async {
    Todo todo = Todo.withId(
        id: todoId,
        title: _title,
        date: _date.toString(),
        priority: _priority,
        status: 0);
    DatabaseHelper instance = DatabaseHelper.instance;
    return await instance.updateTodo(todo).then((value) {
      String sheduleDate =
          DateTime.parse(_date.toString()).toString().split(" ")[0].toString();
      String sheduleTime = DateTime.parse(_date.toString())
          .toString()
          .split(" ")[1]
          .split(".")[0]
          .toString();
      notify(todoId, sheduleDate + " " + sheduleTime, _title);
    });
  }

  @override
  void initState() {
    super.initState();
    _dateController.text =
        _dateFormat.format(DateTime.parse(widget.todoItem['date']));
    titleController.text = widget.todoItem['title'];
    setState(() {
      todoId = widget.todoItem['id'];
      selectedPriority = widget.todoItem['priority'];
      _priority = widget.todoItem['priority'];
      _title = widget.todoItem['title'];
      _date = DateTime.parse(widget.todoItem['date']);
    });
  }

  void notify(int id, String date, String title) async {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: id,
            channelKey: 'basic_channel',
            title: 'Reminding',
            body: title),
        schedule: NotificationCalendar.fromDate(date: DateTime.parse(date)));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Transform.translate(
          offset: Offset(25, 10),
          child: IconButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHomePage(),
                )).then((value) => setState(() {})),
            icon: Icon(
              Icons.arrow_back_ios,
              size: 30.0,
              color: Colors.white,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 15.0),
            child: Column(
              children: [
                Text(
                  'Edit Todo',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.ubuntu(
                    fontWeight: FontWeight.bold,
                    fontSize: 44.0,
                    color: Colors.white,
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 15.0),
                        child: TextFormField(
                          controller: titleController,
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                              labelText: 'Title',
                              labelStyle: TextStyle(
                                color: Colors.white,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              )),
                          validator: (input) => _title.toString().trim().isEmpty
                              ? 'Please enter a Todo Title'
                              : null,
                          onSaved: (input) {
                            _title = input.toString();
                          },
                          onChanged: (input) {
                            setState(() {
                              _title = input.toString();
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 15.0),
                        child: TextFormField(
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                          readOnly: true,
                          controller: _dateController,
                          onTap: _handleDatePicker,
                          decoration: InputDecoration(
                              labelText: 'Date',
                              labelStyle: TextStyle(
                                color: Colors.white,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              )),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 15.0),
                        child: DropdownButtonFormField(
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                          dropdownColor: Colors.black,
                          value: selectedPriority,
                          items: _priorities.map((String priority) {
                            return DropdownMenuItem<String>(
                              value: priority,
                              child: Text(
                                priority,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                ),
                              ),
                            );
                          }).toList(),
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                              labelText: 'Priority',
                              labelStyle: TextStyle(
                                color: Colors.white,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              )),
                          validator: (input) => _priority.toString().isEmpty
                              ? 'Please Select a Priority'
                              : null,
                          onSaved: (input) => _priority = input.toString(),
                          onChanged: (value) {
                            setState(() {
                              _priority = value.toString();
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 15.0),
                        child: MaterialButton(
                          onPressed: () => sendForm()
                              .then((value) => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyHomePage(),
                                  )))
                              .then((value) => setState(() {})),
                          minWidth: double.infinity,
                          height: 55.0,
                          color: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          splashColor: Colors.indigo,
                          child: Text(
                            'Update',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
