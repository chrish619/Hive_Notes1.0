// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable
import './todo.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());

  await Hive.openBox('mybox');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  // This widget is the root/Skeleton of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, this.name, this.isChecked});
  final Todo? name;
  final Todo? isChecked;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // ------------------------------------------------------
  final myController = TextEditingController();
  final box = Hive.box('mybox');
  bool isChecked = false;

  onAdd() {
    setState(() {
      Todo newTodo = Todo(name: myController.text, isChecked: false);
      box.add(newTodo);
    });
  }

  onDelete(int index) {
    setState(() {
      box.deleteAt(index);
    });
  }

  final List<int> ColorCodes = <int>[400, 500, 600, 200, 100];

  @override
  Widget build(BuildContext context) {
    String data = 'Hive Notes';
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            data,
            style: TextStyle(color: Color.fromARGB(255, 167, 230, 49)),
          )),
      body: ListView.builder(
        itemCount: box.length,
        itemBuilder: (context, index) {
          Todo getter = box.getAt(index);

          return Card(
            color: Colors.green[ColorCodes[index]],
            child: CheckboxListTile(
              title: Text(
                getter.name,
                style: TextStyle(
                  decoration:
                      getter.isChecked ? TextDecoration.lineThrough : null,
                ),
              ),
              value: getter.isChecked,
              onChanged: (bool? value) {
                setState(() {
                  getter.isChecked = value!;
                  box.put(getter.key, getter);
                });
              },
              secondary: IconButton(
                onPressed: () {
                  onDelete(index);
                },
                icon: Icon(Icons.delete),
              ),
            ),
          );
        },
      ),

      // ------------------------------------------------
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Color.fromARGB(255, 200, 206, 210),
                title: Text('please add a Note'),
                content: TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      
                    ),
                    labelText: 'Notes',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear), onPressed: () { 
                        myController.clear();
                       },)
                    ),
                  
                  controller: myController,
                ),
                actions: [
                  TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.greenAccent),
                      onPressed: () {
                        onAdd();

                        Navigator.of(context).pop();
                      },
                      child: Text('add')),
                  TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('cancel')),
                ],
              );
            },
          );
        },
        child: Text('+'),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }
}
